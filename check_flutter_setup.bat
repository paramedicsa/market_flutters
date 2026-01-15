@echo off
cls
echo ================================================================
echo          FLUTTER ENVIRONMENT CHECK & FIX
echo ================================================================
echo.
echo This script will help you install and configure Flutter.
echo.
echo ================================================================
echo.

echo Step 1: Checking if Flutter is installed...
echo.

where flutter >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Flutter is installed and in PATH
    flutter --version
) else (
    echo [ERROR] Flutter is NOT installed or not in PATH
    echo.
    echo ================================================================
    echo          FLUTTER INSTALLATION REQUIRED
    echo ================================================================
    echo.
    echo Please install Flutter SDK:
    echo.
    echo 1. Download from: https://flutter.dev/docs/get-started/install/windows
    echo 2. Extract to: C:\flutter
    echo 3. Add to PATH: C:\flutter\flutter\bin
    echo 4. Run: flutter doctor
    echo 5. Run this script again
    echo.
    echo ================================================================
    pause
    exit /b 1
)

echo.
echo ================================================================
echo Step 2: Running Flutter Doctor...
echo ================================================================
echo.

flutter doctor

echo.
echo ================================================================
echo Step 3: Checking your project...
echo ================================================================
echo.

if exist "pubspec.yaml" (
    echo [OK] Found pubspec.yaml
) else (
    echo [ERROR] pubspec.yaml not found
    pause
    exit /b 1
)

echo.
echo ================================================================
echo Step 4: Getting dependencies...
echo ================================================================
echo.

flutter pub get

echo.
echo ================================================================
echo Step 5: Analyzing code...
echo ================================================================
echo.

flutter analyze

echo.
echo ================================================================
echo Step 6: Building project...
echo ================================================================
echo.

flutter build windows --debug

if %errorlevel% equ 0 (
    echo.
    echo ================================================================
    echo                BUILD SUCCESSFUL! ✅
    echo ================================================================
    echo.
    echo Your app is ready to run!
    echo.
    echo Run: flutter run -d windows
    echo.
) else (
    echo.
    echo ================================================================
    echo                BUILD FAILED ❌
    echo ================================================================
    echo.
    echo Check the errors above and fix them.
    echo.
    echo Common fixes:
    echo - Run: flutter clean
    echo - Run: flutter pub get
    echo - Check Flutter installation
    echo.
)

echo ================================================================
pause

