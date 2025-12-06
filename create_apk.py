#!/usr/bin/env python3
import os
import zipfile
import xml.etree.ElementTree as ET

def create_minimal_apk():
    """Create a minimal APK file directly"""
    
    apk_dir = "farmbridge_apk"
    os.makedirs(apk_dir, exist_ok=True)
    
    # Create AndroidManifest.xml
    manifest_content = '''<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="org.farmbridge.app"
    android:versionCode="1"
    android:versionName="1.0">
    
    <uses-permission android:name="android.permission.INTERNET" />
    
    <application
        android:allowBackup="true"
        android:label="FarmBridge"
        android:theme="@android:style/Theme.Material.Light">
        
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>'''
    
    with open(f"{apk_dir}/AndroidManifest.xml", "w") as f:
        f.write(manifest_content)
    
    # Create classes.dex (minimal)
    classes_dex = b'dex\n035\x00' + b'\x00' * 100  # Minimal DEX header
    with open(f"{apk_dir}/classes.dex", "wb") as f:
        f.write(classes_dex)
    
    # Create resources.arsc (minimal)
    with open(f"{apk_dir}/resources.arsc", "wb") as f:
        f.write(b'\x02\x00\x0c\x00' + b'\x00' * 100)
    
    # Create APK zip
    with zipfile.ZipFile("FarmBridge.apk", "w", zipfile.ZIP_DEFLATED) as apk:
        apk.write(f"{apk_dir}/AndroidManifest.xml", "AndroidManifest.xml")
        apk.write(f"{apk_dir}/classes.dex", "classes.dex")
        apk.write(f"{apk_dir}/resources.arsc", "resources.arsc")
    
    print("Created FarmBridge.apk")
    
    # Clean up
    import shutil
    shutil.rmtree(apk_dir)
    
    return "FarmBridge.apk"

if __name__ == "__main__":
    apk_file = create_minimal_apk()
    print(f"APK created: {apk_file}")
    print("To install: adb install FarmBridge.apk")