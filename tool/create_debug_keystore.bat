@echo off
REM Creates the standard Android debug keystore if it does not already exist.
REM This is safe to run multiple times — it skips creation if the file exists.

set KEYSTORE_PATH=%USERPROFILE%\.android\debug.keystore

if exist "%KEYSTORE_PATH%" (
  echo Debug keystore already exists at %KEYSTORE_PATH%
  goto :eof
)

mkdir "%USERPROFILE%\.android" 2>nul

keytool -genkeypair ^
  -keystore "%KEYSTORE_PATH%" ^
  -alias androiddebugkey ^
  -storepass android ^
  -keypass android ^
  -keyalg RSA ^
  -keysize 2048 ^
  -validity 10000 ^
  -dname "CN=Android Debug,O=Android,C=US"

echo.
echo Debug keystore created at %KEYSTORE_PATH%
echo Run tool\get_sha_fingerprints.bat to get the SHA-1 for Firebase Console.
