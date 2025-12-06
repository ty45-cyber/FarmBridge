#!/usr/bin/env python3
import os
import subprocess
import threading
import time
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import urllib.parse

class FarmBridgeHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(b'OK')
        
        elif self.path.startswith('/api/v1/market/price'):
            query = urllib.parse.urlparse(self.path).query
            params = urllib.parse.parse_qs(query)
            
            response = {
                "price": 45.50,
                "market": params.get('market', [''])[0],
                "crop": params.get('crop', [''])[0]
            }
            
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response).encode())
        
        elif self.path.startswith('/api/v1/matches/'):
            response = [{"buyerId": "buyer-001", "price": 46.0, "quantity": 100}]
            
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response).encode())
        
        else:
            self.send_response(404)
            self.end_headers()

def start_backend():
    """Start the backend server in a separate thread"""
    server = HTTPServer(('0.0.0.0', 8080), FarmBridgeHandler)
    print("Backend running on http://localhost:8080")
    server.serve_forever()

def build_android_apk():
    """Build and install Android APK"""
    print("Building Android APK...")
    
    # Check for connected devices
    result = subprocess.run(['adb', 'devices'], capture_output=True, text=True)
    if 'device' not in result.stdout:
        print("No Android device connected. Please connect a device or start an emulator.")
        return False
    
    # Build APK
    os.chdir('frontend/android')
    
    # Build debug APK
    build_result = subprocess.run(['gradlew.bat', 'assembleDebug'], capture_output=True, text=True)
    if build_result.returncode != 0:
        print(f"Build failed: {build_result.stderr}")
        return False
    
    # Install APK
    apk_path = 'app/build/outputs/apk/debug/app-debug.apk'
    install_result = subprocess.run(['adb', 'install', '-r', apk_path], capture_output=True, text=True)
    
    if install_result.returncode == 0:
        print("APK installed successfully!")
        # Launch the app
        subprocess.run(['adb', 'shell', 'am', 'start', '-n', 'org.farmbridge.app/.MainActivity'])
        return True
    else:
        print(f"Installation failed: {install_result.stderr}")
        return False

if __name__ == '__main__':
    # Start backend in background
    backend_thread = threading.Thread(target=start_backend, daemon=True)
    backend_thread.start()
    
    time.sleep(2)  # Wait for backend to start
    
    # Build and install Android app
    build_android_apk()
    
    print("Setup complete! Backend running on port 8080")
    print("Press Ctrl+C to stop")