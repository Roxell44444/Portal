import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceResult {
  const PlaceResult({
    required this.id,
    required this.name,
    required this.label,
    required this.lat,
    required this.lon,
    required this.sourceUrl,
  });

  /// Stable OpenStreetMap object identity, e.g. "way:123456".
  final String id;
  final String name;
  final String label;
  final double lat;
  final double lon;
  final String sourceUrl;

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    final label = json['display_name'] as String? ?? 'Lugar';
    final rawName = (json['name'] as String?)?.trim();
    final osmType = json['osm_type'] as String?;
    final osmId = json['osm_id']?.toString();
    if (osmType == null || osmId == null) {
      throw const FormatException('The place result has no stable OSM identity.');
    }
    return PlaceResult(
      id: '$osmType:$osmId',
      name: rawName == null || rawName.isEmpty ? label.split(',').first : rawName,
      label: label,
      lat: double.parse(json['lat'].toString()),
      lon: double.parse(json['lon'].toString()),
      sourceUrl: 'https://www.openstreetmap.org/$osmType/$osmId',
    );
  }
}

class PlaceSearchService {
  static const endpoint = String.fromEnvironment(
    'PORTAL_GEOCODER_URL',
    defaultValue: 'https://nominatim.openstreetmap.org/search',
  );
  static DateTime? _lastRequest;
  static Future<void> _queue = Future<void>.value();
  static final Map<String, List<PlaceResult>> _cache = {};
  static const _minimumInterval = Duration(seconds: 1);

  Future<List<PlaceResult>> search(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.length < 3) return [];
    final cached = _cache[normalized];
    if (cached != null) return cached;

    final previous = _queue;
    final release = Completer<void>();
    _queue = release.future;
    await previous;
    try {
      final secondCheck = _cache[normalized];
      if (secondCheck != null) return secondCheck;

      final last = _lastRequest;
      if (last != null) {
        final elapsed = DateTime.now().difference(last);
        if (elapsed < _minimumInterval) {
          await Future<void>.delayed(_minimumInterval - elapsed);
        }
      }

      final uri = Uri.parse(endpoint).replace(queryParameters: {
        'q': query.trim(),
        'format': 'jsonv2',
        'addressdetails': '1',
        'limit': '10',
      });
      _lastRequest = DateTime.now();
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        'User-Agent': 'PORTAL-App/0.1 (https://github.com/Roxell44444/Portal)',
      });
      if (response.statusCode != 200) {
        throw Exception('Search service HTTP ${response.statusCode}');
      }
      final data = jsonDecode(response.body) as List<dynamic>;
      final results = data
          .map((item) => PlaceResult.fromJson(item as Map<String, dynamic>))
          .toList();
      _cache[normalized] = results;
      return results;
    } finally {
      release.complete();
    }
  }
}
