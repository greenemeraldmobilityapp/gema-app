import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseClient? _instance;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    _instance = Supabase.instance.client;
  }

  static SupabaseClient get client {
    if (_instance == null) {
      throw StateError('Supabase not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  static bool get isAuthenticated =>
      _instance?.auth.currentSession != null;

  static User? get currentUser => _instance?.auth.currentUser;

  static String? get currentSessionToken =>
      _instance?.auth.currentSession?.accessToken;

  static Stream<AuthState> get authStateChanges =>
      _instance!.auth.onAuthStateChange;
}
