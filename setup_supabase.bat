@echo off
echo ============================================
echo Supabase Connection Helper
echo ============================================
echo.
echo Opening Supabase Dashboard...
echo.

REM Open Supabase API settings directly
start https://supabase.com/dashboard/project/hykorszulmehingfzqso/settings/api

echo.
echo ============================================
echo INSTRUCTIONS:
echo ============================================
echo.
echo 1. The Supabase API settings page is opening in your browser
echo 2. Look for "Project API keys" section
echo 3. Find "anon public" key
echo 4. Click the COPY button next to it
echo 5. Come back here and paste the key
echo.
echo The key should start with: eyJ
echo.
echo ============================================
echo.
echo After copying, paste the key here:
echo.

set /p ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh5a29yc3p1bG1laGluZ2Z6cXNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc5MTc1MzgsImV4cCI6MjA4MzQ5MzUzOH0.x2F1GdUD5X6Vl9ngz6uHh4WeWUZGkOhz_RrNc1u-goY"

echo.
echo ============================================
echo Validating key...
echo ============================================

REM Check if key starts with eyJ
echo %ANON_KEY% | findstr /B "eyJ" >nul
if %errorlevel% equ 0 (
    echo ✓ Key format looks correct!
    echo.
    echo ============================================
    echo SAVING CONFIGURATION...
    echo ============================================
    echo.
    echo Your key will be saved to: lib\data\supabase\supabase_config.dart
    echo.
    echo Key (first 50 chars): %ANON_KEY:~0,50%...
    echo.
    pause

    REM Create a temp file with the new config
    echo import 'package:supabase_flutter/supabase_flutter.dart'; > temp_config.dart
    echo. >> temp_config.dart
    echo class SupabaseConfig { >> temp_config.dart
    echo   static const String supabaseUrl = 'https://hykorszulmehingfzqso.supabase.co'; >> temp_config.dart
    echo   static const String supabaseAnonKey = '%ANON_KEY%'; >> temp_config.dart
    echo. >> temp_config.dart
    echo   static SupabaseClient? _client; >> temp_config.dart
    echo. >> temp_config.dart
    echo   static SupabaseClient get client { >> temp_config.dart
    echo     if (_client == null^) { >> temp_config.dart
    echo       throw Exception('Supabase not initialized. Call SupabaseConfig.initialize(^) first.'^); >> temp_config.dart
    echo     } >> temp_config.dart
    echo     return _client!; >> temp_config.dart
    echo   } >> temp_config.dart
    echo. >> temp_config.dart
    echo   static Future^<void^> initialize(^) async { >> temp_config.dart
    echo     await Supabase.initialize( >> temp_config.dart
    echo       url: supabaseUrl, >> temp_config.dart
    echo       anonKey: supabaseAnonKey, >> temp_config.dart
    echo     ^); >> temp_config.dart
    echo     _client = Supabase.instance.client; >> temp_config.dart
    echo   } >> temp_config.dart
    echo. >> temp_config.dart
    echo   static bool get isInitialized =^> _client != null; >> temp_config.dart
    echo } >> temp_config.dart

    move /Y temp_config.dart lib\data\supabase\supabase_config.dart >nul

    echo.
    echo ✓ Configuration saved successfully!
    echo.
    echo ============================================
    echo NEXT STEPS:
    echo ============================================
    echo.
    echo 1. Run the SQL setup in Supabase SQL Editor
    echo    (Use file: supabase_setup.sql)
    echo.
    echo 2. Run your Flutter app:
    echo    flutter run -d windows
    echo.
    echo 3. Test the Product Management feature!
    echo.

) else (
    echo ✗ Invalid key format!
    echo.
    echo The key should start with "eyJ"
    echo Please try again and make sure you copied the correct key.
    echo.
)

echo.
pause

