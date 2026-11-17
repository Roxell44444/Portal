import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceResult {
  const PlaceResult({required this.id, required this.name, required this.label, required this.lat, required this.lon});
  final String id, name, label;
  final double lat, lon;

  factory PlaceResult.fromJson(Map<String, dynamic> j) {
    final label = j['display_name'] as String? ?? 'Lugar';
    final n = (j['name'] as String?)?.trim();
    return PlaceResult(
      id: j['place_id'].toString(),
      name: n == null || n.isEmpty ? label.split(',').first : n,
      label: label,
      lat: double.parse(j['lat'].toString()),
      lon: double.parse(j['lon'].toString()),
    );
  }
}

class PlaceSearchService {
  static const endpoint = String.fromEnvironment(
    'PORTAL_GEOCODER_URL',
    defaultValue: 'https://nominatim.openstreetmap.org/search',
  );
  static DateTime? _lastRequest;
  static final Map<String, List<PlaceResult>> _cache = {};
  static const _minimumInterval = Duration(seconds: 1);

  Future<List<PlaceResult>> search(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.length < 3) return [];
    if (_cache.containsKey(normalized)) return _cache[normalized]!;

    final previous = _lastRequest;
    if (previous != null) {
      final elapsed = DateTime.now().difference(previous);
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
      'User-Agent': 'PORTAL-App/0.1 (global place search; contact: portal-project)',
    });
    if (response.statusCode != 200) {
      throw Exception('Search service HTTP ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    final results = data.map((e) => PlaceResult.fromJson(e as Map<String, dynamic>)).toList();
    _cache[normalized] = results;
    return results;
  }
}
