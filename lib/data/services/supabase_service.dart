import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  
  static SupabaseClient get client => _client;
  
  // Auth methods
  static User? get currentUser => _client.auth.currentUser;
  static Session? get currentSession => _client.auth.currentSession;
  
  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  // Database queries
  static SupabaseQueryBuilder from(String table) => _client.from(table);
  
  // Storage
  static SupabaseStorageClient get storage => _client.storage;
  
  // Real-time subscriptions
  static RealtimeChannel channel(String name) => _client.channel(name);
  
  // RPC calls
  static Future<PostgrestResponse> rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) {
    return _client.rpc(functionName, params: params);
  }
  
  // Error handling
  static String getErrorMessage(dynamic error) {
    if (error is PostgrestException) {
      switch (error.code) {
        case 'PGRST116':
          return 'Dados não encontrados';
        case '23505':
          return 'Registro duplicado';
        case '42501':
          return 'Acesso negado';
        default:
          return error.message ?? 'Erro ao processar solicitação';
      }
    } else if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Credenciais inválidas';
        case 'Email not confirmed':
          return 'E-mail não confirmado';
        default:
          return error.message ?? 'Erro de autenticação';
      }
    }
    // Log the full error details for debugging
    print('DEBUG - Unexpected error type: ${error.runtimeType}');
    print('DEBUG - Error details: $error');
    return 'Erro inesperado: ${error.toString()}';
  }
}
