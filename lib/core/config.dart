class PortalConfig {
  PortalConfig._();
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static bool get ready => url.startsWith('https://') && anonKey.isNotEmpty;
}
