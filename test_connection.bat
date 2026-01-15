@echo off
cls
echo ================================================================
echo          SUPABASE CONNECTION TEST
echo ================================================================
echo.
echo This script will:
echo 1. Check if database is set up
echo 2. Launch your Flutter app
echo 3. Guide you through testing
echo.
echo ================================================================
echo.

echo Step 1: Checking Supabase configuration...
echo.

if exist "lib\data\supabase\supabase_config.dart" (
    echo [OK] Configuration file found
    findstr /C:"hykorszulmehingfzqso" lib\data\supabase\supabase_config.dart >nul
    if %errorlevel% equ 0 (
        echo [OK] Supabase URL configured
    ) else (
        echo [ERROR] Supabase URL not found
        pause
        exit /b 1
    )

    findstr /C:"eyJ" lib\data\supabase\supabase_config.dart >nul
    if %errorlevel% equ 0 (
        echo [OK] Anon key configured
    ) else (
        echo [ERROR] Anon key not configured
        pause
        exit /b 1
    )
) else (
    echo [ERROR] Configuration file not found
    pause
    exit /b 1
)

echo.
echo ================================================================
echo Step 2: Checking if SQL was run in Supabase...
echo ================================================================
echo.
echo Please confirm: Did you run the SQL in Supabase SQL Editor?
echo.
echo If NO:
echo   1. Go to: https://supabase.com/dashboard/project/hykorszulmehingfzqso/editor
echo   2. Paste the SQL from supabase_setup.sql
echo   3. Click RUN
echo   4. Come back and run this script again
echo.
echo If YES: Press any key to continue...
pause >nul

echo.
echo ================================================================
echo Step 3: Launching Flutter App...
echo ================================================================
echo.
echo Starting app in debug mode...
echo.

start cmd /k "cd /d %~dp0 && flutter run -d windows"

echo.
echo ================================================================
echo App is launching! Please wait...
echo ================================================================
echo.
echo Once the app opens:
echo.
echo 1. Click the "Products" tab at the top
echo 2. You should see 3 sample products:
echo    - Rose Gold Ring
echo    - Silver Hoop Earrings
echo    - Gold Chain Necklace
echo.
echo 3. Click "+ Add Product" button
echo 4. Fill in the form:
echo    Name:     Test Product
echo    Category: Rings
echo    Price:    500
echo    Stock:    10
echo.
echo 5. Click "Save"
echo 6. Product should appear in the grid!
echo.
echo 7. Verify in Supabase:
echo    Go to: https://supabase.com/dashboard/project/hykorszulmehingfzqso/editor
echo    Click "products" table
echo    You should see your new product!
echo.
echo ================================================================
echo.
echo Opening Supabase Table Editor for verification...
start https://supabase.com/dashboard/project/hykorszulmehingfzqso/editor
echo.
echo ================================================================
echo.
echo                    TESTING CHECKLIST
echo ================================================================
echo.
echo [ ] App launched successfully
echo [ ] Products tab visible
echo [ ] Sample products showing (3 products)
echo [ ] Add Product button works
echo [ ] Form can be filled
echo [ ] Product saves successfully
echo [ ] New product appears in grid
echo [ ] Product visible in Supabase Table Editor
echo.
echo ================================================================
echo.
echo If ALL checkboxes are checked: SUCCESS! Everything works!
echo.
echo If any issues, check:
echo - Supabase project is not paused
echo - SQL was run successfully
echo - Internet connection is active
echo.
echo ================================================================
echo.
pause

