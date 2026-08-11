# Hot-restart / reload the Flutter web preview started by tool/preview.ps1.
# Prefers Dart VM Service when available; otherwise signals that a full restart is needed.
$ErrorActionPreference = 'Stop'
$flutterBin = "$env:USERPROFILE\flutter\bin"
if (Test-Path $flutterBin) {
  $env:PATH = "$flutterBin;$env:PATH"
}

Set-Location (Split-Path $PSScriptRoot -Parent)

$previewUrl = 'http://localhost:7357'
$urlFile = Join-Path $PSScriptRoot '.preview_url.txt'
if (Test-Path $urlFile) {
  $previewUrl = (Get-Content $urlFile -Raw).Trim()
}

function Test-PreviewUp([string]$Url) {
  try {
    $r = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 2
    return $true
  } catch {
    # web-server may return various codes while serving
    if ($_.Exception.Response) { return $true }
    return $false
  }
}

if (-not (Test-PreviewUp $previewUrl)) {
  Write-Host "Preview not reachable at $previewUrl — start with tool/preview.ps1"
  exit 2
}

# Find a recent Dart VM Service URI from flutter run output if we cached it.
$vmFile = Join-Path $PSScriptRoot '.preview_vmservice.txt'
$restarted = $false
if (Test-Path $vmFile) {
  $vmHttp = (Get-Content $vmFile -Raw).Trim()
  if ($vmHttp -match '^https?://') {
    try {
      # Hot reload via VM service HTTP (DDS may expose this path on some builds).
      $reloadUrl = $vmHttp.TrimEnd('/') + '/'
      Invoke-WebRequest -Uri $reloadUrl -UseBasicParsing -TimeoutSec 2 | Out-Null
    } catch {
      # ignore — Chrome reload below is the reliable path for web-server
    }
  }
}

Write-Host "PREVIEW_URL=$previewUrl"
Write-Host "Reload Chrome at that URL (or re-run tool/preview.ps1 for a full restart)."
exit 0
