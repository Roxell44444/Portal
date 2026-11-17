import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'place_search_service.dart';

class PortalMapPage extends StatefulWidget {
  const PortalMapPage({super.key});
  @override
  State<PortalMapPage> createState() => _PortalMapPageState();
}
class _PortalMapPageState extends State<PortalMapPage> {
  final map = MapController();
  final query = TextEditingController();
  final search = PlaceSearchService();
  List<PlaceResult> results = [];
  List<Marker> markers = [];
  bool busy = false, locating = false;
  String? message;
  LatLng center = const LatLng(20, 0);

  @override
  void dispose() { query.dispose(); super.dispose(); }

  Future<void> findPlaces() async {
    setState(() { busy = true; message = null; });
    try {
      final found = await search.search(query.text);
      if (mounted) setState(() { results = found; if (found.isEmpty) message = 'No se encontraron lugares.'; });
    } catch (_) {
      if (mounted) setState(() => message = 'La búsqueda no está disponible ahora. Inténtalo más tarde.');
    } finally { if (mounted) setState(() => busy = false); }
  }

  Future<void> locate() async {
    setState(() { locating = true; message = null; });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) throw Exception('Activa la ubicación del dispositivo.');
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Permiso denegado. Puedes explorar el mapa sin ubicación.');
      }
      final p = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium));
      final point = LatLng(p.latitude, p.longitude);
      if (!mounted) return;
      setState(() { center = point; markers = [Marker(point: point, width: 42, height: 42,
        child: const Icon(Icons.my_location, color: Colors.cyanAccent, size: 34))]; });
      map.move(point, 14);
    } catch (e) {
      if (mounted) setState(() => message = e.toString().replaceFirst('Exception: ', ''));
    } finally { if (mounted) setState(() => locating = false); }
  }

  void selectPlace(PlaceResult p) {
    final point = LatLng(p.lat, p.lon);
    setState(() { center = point; results = []; query.text = p.name;
      markers = [Marker(point: point, width: 42, height: 42, child: const Icon(Icons.location_on, color: Colors.deepPurpleAccent, size: 40))]; });
    map.move(point, 15);
    showPlace(p);
  }

  Future<void> showPlace(PlaceResult p) async {
    await showModalBottomSheet<void>(context: context, showDragHandle: true, builder: (ctx) => Padding(
      padding: const EdgeInsets.all(22), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.name, style: Theme.of(ctx).textTheme.titleLarge),
        const SizedBox(height: 6), Text(p.label, style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 8), Text('Lat ${p.lat.toStringAsFixed(5)} · Lon ${p.lon.toStringAsFixed(5)}'),
        const SizedBox(height: 16), Wrap(spacing: 10, children: [
          FilledButton.icon(onPressed: () => savePlace(p), icon: const Icon(Icons.bookmark_add), label: const Text('Guardar')),
          OutlinedButton.icon(onPressed: () => openMap(p), icon: const Icon(Icons.directions), label: const Text('Abrir mapa')),
        ]),
      ]),
    ));
  }

  Future<void> savePlace(PlaceResult p) async {
    try {
      final db = Supabase.instance.client;
      final existing = await db.from('places').select('id')
        .eq('provider', 'openstreetmap').eq('provider_place_id', p.id).maybeSingle();
      final place = existing ?? await db.from('places').insert({
        'provider': 'openstreetmap', 'provider_place_id': p.id, 'name': p.name,
        'display_name': p.label, 'latitude': p.lat, 'longitude': p.lon,
        'source_url': p.sourceUrl, 'source_license': 'ODbL-1.0',
      }).select('id').single();
      final userId = db.auth.currentUser!.id;
      final alreadySaved = await db.from('saved_places').select('place_id')
        .eq('user_id', userId).eq('place_id', place['id']).maybeSingle();
      if (alreadySaved == null) {
        await db.from('saved_places').insert({'user_id': userId, 'place_id': place['id']});
      }
      if (mounted) { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lugar guardado en tu cuenta.'))); }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo guardar. Revisa la configuración de la base de datos.')));
    }
  }

  Future<void> openMap(PlaceResult p) async {
    final uri = Uri.parse('https://www.openstreetmap.org/?mlat=${p.lat}&mlon=${p.lon}#map=16/${p.lat}/${p.lon}');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('PORTAL MAP'), actions: [
      IconButton(onPressed: locating ? null : locate, tooltip: 'Mi ubicación',
        icon: locating ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.my_location)),
    ]),
    body: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(12, 4, 12, 10), child: Column(children: [
        Row(children: [
          Expanded(child: TextField(controller: query, textInputAction: TextInputAction.search, onSubmitted: (_) => findPlaces(),
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Busca ciudades, parques, monumentos…'))),
          const SizedBox(width: 8),
          IconButton.filled(onPressed: busy ? null : findPlaces, icon: busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.arrow_forward)),
        ]),
        if (message != null) Padding(padding: const EdgeInsets.all(6), child: Text(message!, style: const TextStyle(color: Colors.orangeAccent))),
        if (results.isNotEmpty) Container(height: 180, margin: const EdgeInsets.only(top: 8), decoration: BoxDecoration(color: const Color(0xFF20283A), borderRadius: BorderRadius.circular(12)),
          child: ListView.builder(itemCount: results.length, itemBuilder: (ctx, i) {
            final p = results[i];
            return ListTile(dense: true, leading: const Icon(Icons.place_outlined), title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(p.label, maxLines: 1, overflow: TextOverflow.ellipsis), onTap: () => selectPlace(p));
          })),
      ])),
      Expanded(child: FlutterMap(mapController: map, options: MapOptions(initialCenter: center, initialZoom: 2,
        onTap: (_, point) => setState(() { center = point; markers = [Marker(point: point, width: 40, height: 40, child: const Icon(Icons.place, color: Colors.orangeAccent, size: 38))]; })),
        children: [
          TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'app.portal.mobile'),
          MarkerLayer(markers: markers),
          RichAttributionWidget(attributions: [TextSourceAttribution('© OpenStreetMap contributors',
            onTap: () => launchUrl(Uri.parse('https://www.openstreetmap.org/copyright')))]),
        ])),
    ]),
  );
}
