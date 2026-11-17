import 'package:flutter_test/flutter_test.dart';
import 'package:portal/features/map/place_search_service.dart';

void main() {
  test('PlaceResult uses stable OSM type and object id', () {
    final place = PlaceResult.fromJson({
      'place_id': 999,
      'osm_type': 'way',
      'osm_id': 12345,
      'name': 'Central Park',
      'display_name': 'Central Park, Manhattan, New York, USA',
      'lat': '40.7829',
      'lon': '-73.9654',
    });
    expect(place.id, 'way:12345');
    expect(place.name, 'Central Park');
    expect(place.sourceUrl, 'https://www.openstreetmap.org/way/12345');
  });
}
