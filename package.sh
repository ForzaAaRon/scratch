#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Generating Xcode project from project.yml"
xcodegen generate --quiet

echo ""
echo "==> Archiving (Release)"
chmod -R u+w build 2>/dev/null || true
rm -rf build
xcodebuild \
  -project Scratch.xcodeproj \
  -scheme Scratch \
  -configuration Release \
  -destination 'generic/platform=macOS' \
  -archivePath build/Scratch.xcarchive \
  -allowProvisioningUpdates \
  archive | tail -5

echo ""
echo "==> Exporting signed Developer ID build"
xcodebuild \
  -exportArchive \
  -archivePath build/Scratch.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist \
  -allowProvisioningUpdates | tail -5

echo ""
echo "==> App signature"
codesign -dv --verbose=2 build/export/Scratch.app 2>&1 | grep -E "Authority|Identifier|TeamIdentifier"

echo ""
echo "==> Staging .dmg contents (Scratch.app + Applications symlink)"
rm -rf build/dmg-src
mkdir -p build/dmg-src
cp -R build/export/Scratch.app build/dmg-src/
ln -s /Applications build/dmg-src/Applications

echo ""
echo "==> Building .dmg into ~/Downloads"
rm -f ~/Downloads/Scratch.dmg
hdiutil create \
  -volname "Scratch" \
  -srcfolder build/dmg-src \
  -ov -format UDZO \
  ~/Downloads/Scratch.dmg | tail -3

echo ""
ls -lh ~/Downloads/Scratch.dmg
echo "Done."
