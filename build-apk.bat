@echo off
echo ============================================
echo   Coin Strategy Lab - Build APK
echo ============================================
echo.

where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js not found. Please install Node.js 18+
    echo https://nodejs.org/
    pause & exit /b 1
)

where java >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java JDK not found. Please install JDK 17+
    echo https://adoptium.net/
    pause & exit /b 1
)

echo [1/4] Installing dependencies...
call npm install
if errorlevel 1 ( echo [ERROR] npm install failed & pause & exit /b 1 )

echo.
echo [2/4] Building frontend...
call npm run build
if errorlevel 1 ( echo [ERROR] npm run build failed & pause & exit /b 1 )

echo.
echo [3/4] Setting up Capacitor Android...
if not exist "android" (
    call npx cap add android
    if errorlevel 1 ( echo [ERROR] cap add android failed & pause & exit /b 1 )
)
call npx cap sync android
if errorlevel 1 ( echo [ERROR] cap sync failed & pause & exit /b 1 )

echo.
echo [4/4] Building Debug APK...
cd android
call gradlew.bat assembleDebug
if errorlevel 1 (
    echo [ERROR] Gradle build failed.
    echo Make sure ANDROID_HOME is set correctly.
    echo Default path: C:\Users\%USERNAME%\AppData\Local\Android\Sdk
    cd ..
    pause & exit /b 1
)
cd ..

echo.
echo ============================================
echo [SUCCESS] APK is ready!
echo Location: android\app\build\outputs\apk\debug\app-debug.apk
echo ============================================
echo.
echo Transfer app-debug.apk to your phone and install it.
echo (Enable "Install from unknown sources" on your phone first)
pause
