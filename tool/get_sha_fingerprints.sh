#!/usr/bin/env bash
# Prints SHA-1 and SHA-256 fingerprints for both debug and release keystores.
# Add these to Firebase Console → Project Settings → Your Android App → Add fingerprint.

set -euo pipefail

DEBUG_KEYSTORE="${HOME}/.android/debug.keystore"
RELEASE_KEYSTORE="$(dirname "$0")/../android/keystore/productive_muslim.jks"

echo "=== Debug keystore ==="
if [ -f "$DEBUG_KEYSTORE" ]; then
  keytool -list -v \
    -keystore "$DEBUG_KEYSTORE" \
    -alias androiddebugkey \
    -storepass android \
    -keypass android 2>/dev/null \
    | grep -E "SHA1:|SHA256:"
else
  echo "Debug keystore not found at $DEBUG_KEYSTORE"
  echo "Run: tool/create_debug_keystore.bat  (Windows) or keytool manually."
fi

echo ""
echo "=== Release keystore ==="
if [ -f "$RELEASE_KEYSTORE" ]; then
  keytool -list -v \
    -keystore "$RELEASE_KEYSTORE" \
    -storepass "${KEYSTORE_PASSWORD:-}" \
    2>/dev/null \
    | grep -E "SHA1:|SHA256:" || echo "Wrong password or no entries."
else
  echo "Release keystore not found at $RELEASE_KEYSTORE"
fi
