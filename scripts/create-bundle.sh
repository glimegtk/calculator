#!/bin/bash
# Calculator App Bundle Script
# Run this to create an app bundle for the calculator

set -e

APP_NAME="Calculator"
BUNDLE_DIR="${APP_NAME}.app"
CONTENTS_DIR="${BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Building ${APP_NAME}.app bundle..."

# Create bundle directories
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# Copy the executable
EXE_PATH=$(cabal exec which hello-gtk 2>/dev/null || echo "dist-newstyle/build/*/ghc-*/hello-gtk-*/x/hello-gtk/build/hello-gtk/hello-gtk")
cp -r dist-newstyle/build/aarch64-osx/ghc-9.14.1/hello-gtk-0.1.1.0/x/hello-gtk/build/hello-gtk/hello-gtk "${MACOS_DIR}/${APP_NAME}"

# Get version from cabal file
VERSION=$(grep -E "^version:" hello-gtk.cabal | awk '{print $2}')

# Create Info.plist
cat > "${CONTENTS_DIR}/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.Calculator</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>${VERSION}</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.utilities</string>
</dict>
</plist>
EOF

# Copy icon (if exists)
if [ -f "GUI/hello-gtk.png" ]; then
    cp "GUI/hello-gtk.png" "${RESOURCES_DIR}/icon.png"
fi

echo "Bundle created at ${BUNDLE_DIR}"
echo "To run: open ${BUNDLE_DIR}"