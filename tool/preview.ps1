# Start or refresh the Flutter web preview (Chrome).
$flutterBin = "$env:USERPROFILE\flutter\bin"
if (Test-Path $flutterBin) {
  $env:PATH = "$flutterBin;$env:PATH"
}

Set-Location (Split-Path $PSScriptRoot -Parent)
flutter run -d chrome
