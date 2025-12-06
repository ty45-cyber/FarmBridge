@echo off
echo Starting FarmBridge build and installation...

echo.
echo Step 1: Starting backend server...
cd backend_dart
start "Backend Server" cmd /k "dart pub get && dart run bin/server.dart"
cd ..

echo.
echo Step 2: Building Flutter APK...
cd frontend_flutter
call flutter pub get
call flutter build apk --release

echo.
echo Step 3: APK built successfully!
echo Location: frontend_flutter\build\app\outputs\flutter-apk\app-release.apk

echo.
echo Step 4: Installing on connected Android device...
call flutter install --release

echo.
echo Installation complete! Check your Android device.
pause