import 'dart:io';

// Custom environment variable manager
class EnvManager {
  static final Map<String, String> _envVars = {};

  static String get(String key, {String defaultValue = ''}) {
    return _envVars[key] ?? defaultValue;
  }

  static void set(String key, String value) {
    _envVars[key] = value;
  }

  static Map<String, String> get all => Map.unmodifiable(_envVars);

  static Future<void> loadEnvFile() async {
    try {
      final envFile = File('.env');
      if (await envFile.exists()) {
        final contents = await envFile.readAsString();
        final lines = contents.split('\n');

        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isNotEmpty && !trimmed.startsWith('#')) {
            final parts = trimmed.split('=');
            if (parts.length == 2) {
              final key = parts[0].trim();
              final value = parts[1].trim();
              // Use our custom EnvManager instead of Platform.environment
              EnvManager.set(key, value);
            }
          }
        }
        // Note: debugPrint is not available here since this is a utility class
        // debugPrint('Environment variables loaded successfully');
      } else {
        // debugPrint('Warning: .env file not found');
      }
    } catch (e) {
      // debugPrint('Error loading .env file: $e');
    }
  }
}
