import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../map/portal_map_page.dart';
import '../social/social_feed_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [const SocialFeedPage(), const PortalMapPage(), const ExplorePage(), const ProfilePage()];
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dynamic_feed_outlined), label: 'Social'),
          NavigationDestination(icon: Icon(Icons.public), label: 'Mapa'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ]),
    );
  }
}
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('PORTAL EXPLORATION')),
    body: ListView(padding: const EdgeInsets.all(18), children: const [
      _ModuleCard('VISION', 'Cámara, OCR y reconocimiento de lugares.', Icons.document_scanner_outlined),
      _ModuleCard('AI', 'Personajes inteligentes claramente identificados.', Icons.auto_awesome),
      _ModuleCard('EXPLORATION', 'Misiones, descubrimientos y logros.', Icons.travel_explore),
      Padding(padding: EdgeInsets.all(12), child: Text('Estos módulos están planificados; no se muestran como funciones terminadas.', style: TextStyle(color: Colors.white54))),
    ]));
}
class _ModuleCard extends StatelessWidget {
  const _ModuleCard(this.title, this.description, this.icon);
  final String title, description;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(child: ListTile(contentPadding: const EdgeInsets.all(14),
    leading: CircleAvatar(child: Icon(icon)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(description), trailing: const Text('En desarrollo', style: TextStyle(fontSize: 10))));
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['display_name'] as String? ?? 'Usuario PORTAL';
    return Scaffold(appBar: AppBar(title: const Text('Mi perfil')), body: ListView(padding: const EdgeInsets.all(24), children: [
      const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
      const SizedBox(height: 12),
      Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      Text(user?.email ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60)),
      const SizedBox(height: 24),
      const ListTile(leading: Icon(Icons.privacy_tip_outlined), title: Text('Privacidad y ubicación'),
        subtitle: Text('La ubicación solo se solicita cuando utilizas una función que la necesita.')),
      OutlinedButton.icon(onPressed: () => Supabase.instance.client.auth.signOut(),
        icon: const Icon(Icons.logout), label: const Text('Cerrar sesión')),
    ]));
  }
}
