import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_shell.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}
class _AuthPageState extends State<AuthPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final displayName = TextEditingController();
  bool register = false, busy = false, obscure = true;
  String? error;

  @override
  void dispose() { email.dispose(); password.dispose(); displayName.dispose(); super.dispose(); }

  Future<void> submit() async {
    setState(() { busy = true; error = null; });
    try {
      final auth = Supabase.instance.client.auth;
      if (register) {
        await auth.signUp(email: email.text.trim(), password: password.text,
          data: {'display_name': displayName.text.trim()});
      } else {
        await auth.signInWithPassword(email: email.text.trim(), password: password.text);
      }
    } on AuthException catch (e) {
      setState(() => error = e.message);
    } catch (_) {
      setState(() => error = 'No se pudo conectar. Comprueba tu conexión.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> resetPassword() async {
    if (email.text.trim().isEmpty) { setState(() => error = 'Escribe tu correo primero.'); return; }
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email.text.trim());
      if (mounted) setState(() => error = 'Si la cuenta existe, recibirás instrucciones por correo.');
    } on AuthException catch (e) { if (mounted) setState(() => error = e.message); }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<AuthState>(
    stream: Supabase.instance.client.auth.onAuthStateChange,
    builder: (context, snapshot) {
      if (Supabase.instance.client.auth.currentSession != null) return const HomeShell();
      return Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(height: 28),
            const Text('PORTAL', textAlign: TextAlign.center, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 5)),
            const SizedBox(height: 8),
            const Text('Descubre el mundo. Conecta con él.', textAlign: TextAlign.center),
            const SizedBox(height: 36),
            Text(register ? 'Crear cuenta' : 'Iniciar sesión', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            if (register) ...[
              TextField(controller: displayName, decoration: const InputDecoration(labelText: 'Nombre para mostrar')),
              const SizedBox(height: 12),
            ],
            TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Correo electrónico')),
            const SizedBox(height: 12),
            TextField(controller: password, obscureText: obscure, decoration: InputDecoration(
              labelText: 'Contraseña', suffixIcon: IconButton(
                onPressed: () => setState(() => obscure = !obscure),
                icon: Icon(obscure ? Icons.visibility : Icons.visibility_off)))),
            if (!register) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: resetPassword, child: const Text('¿Olvidaste tu contraseña?'))),
            if (error != null) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(error!, style: const TextStyle(color: Colors.orangeAccent))),
            const SizedBox(height: 12),
            FilledButton(onPressed: busy ? null : submit, child: busy ? const CircularProgressIndicator() : Text(register ? 'Crear mi cuenta' : 'Entrar')),
            TextButton(onPressed: () => setState(() { register = !register; error = null; }),
              child: Text(register ? 'Ya tengo una cuenta' : 'Crear cuenta nueva')),
          ],
        )),
      ))));
    },
  );
}
