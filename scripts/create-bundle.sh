#!/bin/bash
# Create a macOS app bundle for the calculator.

set -e

APP_NAME="Calculator"
APP_ID="io.github.bniladridas.calculator"
BUNDLE_DIR="${APP_NAME}.app"
CONTENTS_DIR="${BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"
EXECUTABLE_NAME="hello-gtk"
ICON_PNG_PATH=""

echo "Building ${APP_NAME}.app bundle..."

# Recreate the bundle so stale metadata or icons do not leak into new builds.
rm -rf "${BUNDLE_DIR}"
mkdir -p "${MACOS_DIR}" "${RESOURCES_DIR}"

# Locate the built executable from the current Cabal build output.
EXE_PATH=$(cabal list-bin "${EXECUTABLE_NAME}" 2>/dev/null || true)
if [ -z "${EXE_PATH}" ]; then
    EXE_PATH=$(find dist-newstyle -type f -path "*/build/${EXECUTABLE_NAME}/${EXECUTABLE_NAME}" | sort | tail -n 1)
fi
if [ -z "${EXE_PATH}" ]; then
    echo "Could not find built executable for ${EXECUTABLE_NAME}."
    echo "Run: cabal build ${EXECUTABLE_NAME}"
    exit 1
fi
cp "${EXE_PATH}" "${MACOS_DIR}/${APP_NAME}"
chmod +x "${MACOS_DIR}/${APP_NAME}"

# Get version from cabal file.
VERSION=$(grep -E "^version:" hello-gtk.cabal | awk '{print $2}')

# Create Info.plist.
cat > "${CONTENTS_DIR}/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>${APP_ID}</string>
    <key>CFBundleDisplayName</key>
    <string>${APP_NAME}</string>
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
    <key>CFBundleIconFile</key>
    <string>icon.icns</string>
</dict>
</plist>
EOF

# Copy icon assets for the bundle and About dialog.
if [ -f "GUI/app-icon.png" ]; then
    ICON_PNG_PATH="GUI/app-icon.png"
elif [ -f "GUI/hello-gtk.png" ]; then
    ICON_PNG_PATH="GUI/hello-gtk.png"
fi

if [ -f "GUI/icon.icns" ]; then
    cp "GUI/icon.icns" "${RESOURCES_DIR}/icon.icns"
fi

if [ -n "${ICON_PNG_PATH}" ]; then
    cp "${ICON_PNG_PATH}" "${RESOURCES_DIR}/icon.png"
fi

echo "Bundle created at ${BUNDLE_DIR}"
echo "To run: open ${BUNDLE_DIR}"
