@echo off
REM Prints SHA-1 and SHA-256 fingerprints for the debug keystore.
REM Add the SHA-1 to Firebase Console → Project Settings → Your Android App.

echo === Debug keystore ===
keytool -list -v ^
  -keystore "%USERPROFILE%\.android\debug.keystore" ^
  -alias androiddebugkey ^
  -storepass android ^
  -keypass android 2>nul | findstr /R "SHA1: SHA256:"

echo.
echo === Release keystore ===
if exist "%~dp0..\android\keystore\productive_muslim.jks" (
  set /p KPWD="Enter keystore password: "
  keytool -list -v ^
    -keystore "%~dp0..\android\keystore\productive_muslim.jks" ^
    -storepass %KPWD% 2>nul | findstr /R "SHA1: SHA256:"
) else (
  echo Release keystore not found at android\keystore\productive_muslim.jks
)
