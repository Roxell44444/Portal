import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceResult {
  const PlaceResult({required this.id, required this.name, required this.label, required this.lat, required this.lon});
  final String id, name, label;
  final double lat, lon;
  factory PlaceResult.fromJson(Map<String, dynamic> j) {
    final label = j['display_name'] as String? ?? 'Lugar';
    final n = (j['name'] as String?)?.trim();
    return PlaceResult(id: j['place_id'].toString(), name: n == null || n.isEmpty ? label.split(',').first : n,
      label: label, lat: double.parse(j['lat'].toString()), lon: double.parse(j['lon'].toString()));
  }
}
class PlaceSearchService {
  Future<List<PlaceResult>> search(String query) async {
    if (query.trim().length < 3) return [];
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query.trim(), 'format': 'jsonv2', 'addressdetails': '1', 'limit': '10'
    });
    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'User-Agent': 'PORTAL-App/0.1 (global place search)',
    });
    if (response.statusCode != 200) throw Exception('Search service HTTP ${response.statusCode}');
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => PlaceResult.fromJson(e as Map<String, dynamic>)).toList();
  }
}
