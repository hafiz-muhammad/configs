@echo off
echo Setting execution policy and unblocking PowerShell 7+ profile files...

:: Override policy to set RemoteSigned and unblock the profile folder
pwsh -NoProfile -ExecutionPolicy Bypass -Command ^
  "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force -WarningAction SilentlyContinue; " ^
  "$pwDir = Split-Path $PROFILE; " ^
  "if (Test-Path $pwDir) { Get-ChildItem -Path $pwDir -Recurse | Unblock-File -ErrorAction SilentlyContinue }"

echo.
echo Done! CurrentUser execution policy set and profile directory files unblocked.
pause
