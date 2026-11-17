import 'package:flutter/material.dart';
import 'core/config.dart';
import 'features/auth/auth_page.dart';

class PortalApp extends StatelessWidget {
  const PortalApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'PORTAL',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7657FF), brightness: Brightness.dark),
      scaffoldBackgroundColor: const Color(0xFF101522),
    ),
    home: PortalConfig.ready ? const AuthPage() : const SetupPage(),
  );
}

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SafeArea(child: Center(child: Padding(
      padding: EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('PORTAL', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 5)),
        SizedBox(height: 16),
        Text('La aplicación necesita conectar un proyecto Supabase para activar cuentas, publicaciones y almacenamiento reales.'),
        SizedBox(height: 18),
        SelectableText('SUPABASE_URL\nSUPABASE_ANON_KEY'),
        SizedBox(height: 10),
        Text('No se utiliza una cuenta de demostración. Nunca introduzcas una clave service_role en la aplicación.', style: TextStyle(color: Colors.white60)),
      ]),
    ))),
  );
}
