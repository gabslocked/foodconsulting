class EnvConfig {
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'development');
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  static const String firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY', defaultValue: '');
  
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
}
