import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://hykorszulmehingfzqso.supabase.co'; // Replace with: https://hykorszulmehingfzqso.supabase.co
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh5a29yc3p1bG1laGluZ2Z6cXNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc5MTc1MzgsImV4cCI6MjA4MzQ5MzUzOH0.x2F1GdUD5X6Vl9ngz6uHh4WeWUZGkOhz_RrNc1u-goY'; // Replace with your key

  static SupabaseClient? _client;

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call SupabaseConfig.initialize() first.');
    }
    return _client!;
  }

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  static bool get isInitialized => _client != null;
}

