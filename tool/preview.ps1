# Start Flutter web preview in Chrome (full DWDS debug session).
# Prefer this over web-server — Chrome shows a blank page without the Dart Debug extension.
$ErrorActionPreference = 'Continue'
$flutterBin = "$env:USERPROFILE\flutter\bin"
if (Test-Path $flutterBin) {
  $env:PATH = "$flutterBin;$env:PATH"
}

Set-Location (Split-Path $PSScriptRoot -Parent)

$port = 7357
$uriFile = Join-Path $PSScriptRoot '.preview_url.txt'
Set-Content -Path $uriFile -Value "http://localhost:$port" -NoNewline

Write-Host "Starting Flutter Chrome preview (port $port)..."
flutter run -d chrome --web-hostname=localhost --web-port=$port
