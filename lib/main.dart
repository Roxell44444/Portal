import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (PortalConfig.ready) {
    await Supabase.initialize(url: PortalConfig.url, anonKey: PortalConfig.anonKey);
  }
  runApp(const PortalApp());
}
