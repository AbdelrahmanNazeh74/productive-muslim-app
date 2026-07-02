#!/usr/bin/env bash
# Generates all app icons and splash screens from code.
# Run from the project root:
#   bash tool/setup_icons.sh
#
# What this does:
#   1. Generates assets/icon/icon.png and icon_foreground.png from Dart code
#   2. Runs flutter_launcher_icons to install icons in all platform folders
#   3. Runs flutter_native_splash to install the native splash screen
#
# No Figma, Photoshop, or external tools required.
set -e

echo "=== Productive Muslim — Icon & Splash Generator ==="
echo ""

echo "Step 1/3: Generating icon PNGs from code..."
dart run tool/generate_icon.dart

echo ""
echo "Step 2/3: Installing launcher icons..."
dart run flutter_launcher_icons

echo ""
echo "Step 3/3: Generating native splash screens..."
dart run flutter_native_splash:create

echo ""
echo "✓ All icons and splash screens generated successfully."
echo ""
echo "Commit the following generated files:"
echo "  android/app/src/main/res/mipmap-*/launcher_icon*.png"
echo "  ios/Runner/Assets.xcassets/AppIcon.appiconset/"
echo "  android/app/src/main/res/drawable*/launch_background.xml"
echo "  ios/Runner/Base.lproj/LaunchScreen.storyboard"
