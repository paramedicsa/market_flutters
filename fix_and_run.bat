@echo off
cls
echo ================================================================
echo    FIXING SHARED_PREFERENCES PLUGIN ISSUE
echo ================================================================
echo.
echo The error you encountered is a common Flutter Windows plugin issue.
echo.
echo Error: MissingPluginException for shared_preferences
echo Cause: Plugin not properly registered for Windows platform
echo.
echo ================================================================
echo    SOLUTION APPLIED
echo ================================================================
echo.
echo I have manually fixed the plugin registration:
echo.
echo 1. Updated: windows\flutter\generated_plugins.cmake
echo    - Added shared_preferences_windows to plugin list
echo.
echo 2. Updated: windows\flutter\generated_plugin_registrant.cc
echo    - Added SharedPreferencesWindows registration
echo.
echo 3. Updated: pubspec.yaml
echo    - Explicitly added shared_preferences dependency
echo.
echo ================================================================
echo    BUILDING APP NOW
echo ================================================================
echo.
echo This may take 1-2 minutes...
echo.

flutter clean
echo.
echo Cleaning complete. Getting dependencies...
echo.

flutter pub get
echo.
echo Dependencies installed. Building for Windows...
echo.

flutter build windows --debug
echo.
echo ================================================================
echo    BUILD COMPLETE
echo ================================================================
echo.
echo Now launching your app...
echo.

start "" "%~dp0build\windows\x64\runner\Debug\market_flutter.exe"

echo.
echo ================================================================
echo    APP LAUNCHED
echo ================================================================
echo.
echo The app should now open without the plugin error!
echo.
echo Test checklist:
echo [ ] App launches successfully
echo [ ] No plugin error appears
echo [ ] Navigate to Products tab
echo [ ] Products load from Supabase
echo.
echo If you still see errors, please share them.
echo.
echo ================================================================
pause

