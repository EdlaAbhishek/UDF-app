import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/api_constants.dart';

class SupabaseService {
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: ApiConstants.supabaseUrl,
        anonKey: ApiConstants.supabaseAnonKey,
      );
    } catch (e) {
      // Allow app to continue gracefully in offline/mock mode if network is restricted
      print('Supabase init warning: $e');
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}
