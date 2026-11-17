import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SocialFeedPage extends StatefulWidget {
  const SocialFeedPage({super.key});
  @override
  State<SocialFeedPage> createState() => _SocialFeedPageState();
}
class _SocialFeedPageState extends State<SocialFeedPage> {
  final composer = TextEditingController();
  List<Map<String, dynamic>> posts = [];
  bool loading = true, posting = false;
  @override
  void initState() { super.initState(); load(); }
  @override
  void dispose() { composer.dispose(); super.dispose(); }

  Future<void> load() async {
    try {
      final rows = await Supabase.instance.client.from('posts')
        .select('id, content, created_at, profiles(display_name)')
        .eq('visibility', 'public').order('created_at', ascending: false).limit(50);
      if (mounted) setState(() => posts = List<Map<String, dynamic>>.from(rows));
    } catch (_) {
      // A missing migration is reported through the empty state, not fake data.
    } finally { if (mounted) setState(() => loading = false); }
  }

  Future<void> publish() async {
    final text = composer.text.trim();
    if (text.isEmpty || text.length > 2000) return;
    setState(() => posting = true);
    try {
      await Supabase.instance.client.from('posts').insert({
        'author_id': Supabase.instance.client.auth.currentUser!.id,
        'content': text, 'visibility': 'public',
      });
      composer.clear();
      await load();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo publicar. Revisa la migración de Supabase.')));
    } finally { if (mounted) setState(() => posting = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('PORTAL SOCIAL')),
    body: RefreshIndicator(onRefresh: load, child: ListView(padding: const EdgeInsets.all(14), children: [
      Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
        TextField(controller: composer, maxLength: 2000, maxLines: 3,
          decoration: const InputDecoration(border: InputBorder.none, hintText: '¿Qué descubriste hoy?')),
        Align(alignment: Alignment.centerRight, child: FilledButton.icon(
          onPressed: posting ? null : publish, icon: const Icon(Icons.send), label: Text(posting ? 'Publicando…' : 'Publicar'))),
      ]))),
      const SizedBox(height: 10),
      if (loading) const Center(child: CircularProgressIndicator()),
      if (!loading && posts.isEmpty) const Padding(padding: EdgeInsets.all(24),
        child: Text('Todavía no hay publicaciones. ¡Puedes iniciar la comunidad!', textAlign: TextAlign.center)),
      for (final post in posts) Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text((post['profiles']?['display_name'] as String?) ?? 'Usuario PORTAL', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10), Text(post['content'] as String? ?? ''),
          const SizedBox(height: 10), Text(post['created_at']?.toString() ?? '', style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ]))),
    ])),
  );
}
