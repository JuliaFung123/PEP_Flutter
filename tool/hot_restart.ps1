# Hot-restart the existing Flutter Chrome preview (~seconds, same window).
# Preferred path: send R to flutter run stdin (via tool/.preview_cmd.txt).
# Fallback: ext.flutter.reassemble over VM Service WebSocket (hot-reload-like).
# Use after code edits. Do NOT run preview.ps1 again while preview is up.
$ErrorActionPreference = 'Stop'
$flutterBin = "$env:USERPROFILE\flutter\bin"
if (Test-Path $flutterBin) {
  $env:PATH = "$env:PATH;$flutterBin"
}

Set-Location (Split-Path $PSScriptRoot -Parent)

$port = 7357
$vmUriFile = Join-Path $PSScriptRoot '.preview_vm_uri.txt'
$pidFile = Join-Path $PSScriptRoot '.preview_pid.txt'
$cmdFile = Join-Path $PSScriptRoot '.preview_cmd.txt'

$listening = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
if (-not $listening) {
  Write-Host "Preview is not running on port $port. Start it with: tool/preview.ps1"
  exit 1
}

# 1) Preferred: ask preview.ps1 to type R into flutter stdin (full hot restart).
if ((Test-Path $pidFile) -and (Test-Path $cmdFile)) {
  $flutterPid = [int]((Get-Content $pidFile -Raw).Trim())
  $proc = Get-Process -Id $flutterPid -ErrorAction SilentlyContinue
  if ($proc -and -not $proc.HasExited) {
    # Append so a concurrent poll doesn't miss it; preview.ps1 clears after read.
    Add-Content -Path $cmdFile -Value 'R'
    Write-Host "Hot restart requested (sent R to flutter PID $flutterPid)."
    Write-Host "Watch the Flutter terminal for 'Performing hot restart' / 'Reloaded'."
    exit 0
  }
}

# 2) Fallback: WebSocket reassemble (works when stdin runner is not used).
if (-not (Test-Path $vmUriFile)) {
  Write-Host "Cannot hot restart: no flutter stdin session and no VM URI."
  Write-Host "Press R in the Flutter terminal, or restart with tool/preview.ps1."
  exit 1
}

$vmHttp = (Get-Content $vmUriFile -Raw).Trim().TrimEnd('/')
if ($vmHttp -match '^https?://(.+)$') {
  $wsUri = "ws://$($Matches[1])/ws"
} else {
  Write-Host "Invalid VM URI: $vmHttp"
  exit 1
}

function Invoke-VmWs([string]$WsUri, [string]$JsonBody, [int]$TimeoutMs = 8000) {
  $ws = [System.Net.WebSockets.ClientWebSocket]::new()
  $cts = [System.Threading.CancellationTokenSource]::new()
  $cts.CancelAfter($TimeoutMs)
  try {
    $ws.ConnectAsync([Uri]$WsUri, $cts.Token).GetAwaiter().GetResult() | Out-Null
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($JsonBody)
    $ws.SendAsync(
      [ArraySegment[byte]]::new($bytes),
      [System.Net.WebSockets.WebSocketMessageType]::Text,
      $true,
      $cts.Token
    ).GetAwaiter().GetResult() | Out-Null

    $buffer = New-Object byte[] 262144
    $ms = [System.IO.MemoryStream]::new()
    do {
      $result = $ws.ReceiveAsync([ArraySegment[byte]]::new($buffer), $cts.Token).GetAwaiter().GetResult()
      $ms.Write($buffer, 0, $result.Count)
    } while (-not $result.EndOfMessage)

    return [System.Text.Encoding]::UTF8.GetString($ms.ToArray())
  }
  finally {
    if ($ws.State -eq [System.Net.WebSockets.WebSocketState]::Open) {
      $ws.CloseAsync(
        [System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure,
        'done',
        [System.Threading.CancellationToken]::None
      ).GetAwaiter().GetResult() | Out-Null
    }
    $ws.Dispose()
    $cts.Dispose()
  }
}

try {
  $vmJson = Invoke-VmWs $wsUri '{"jsonrpc":"2.0","method":"getVM","id":"1"}'
  $vm = $vmJson | ConvertFrom-Json
  $isolates = @($vm.result.isolates)
  $isolate = $isolates | Where-Object { $_.name -eq 'main' } | Select-Object -First 1
  if (-not $isolate) { $isolate = $isolates[0] }
  $iso = $isolate.id

  # Full hotRestart is not registered on Flutter web DWDS; reassemble = reload UI.
  $body = "{`"jsonrpc`":`"2.0`",`"method`":`"ext.flutter.reassemble`",`"params`":{`"isolateId`":`"$iso`"},`"id`":`"2`"}"
  $respJson = Invoke-VmWs $wsUri $body
  $resp = $respJson | ConvertFrom-Json
  if ($resp.error) {
    throw "reassemble error: $($resp.error.message)"
  }
  Write-Host "Hot reload-like reassemble sent (WebSocket fallback)."
  Write-Host "For a full restart, use the new preview.ps1 stdin session or press R."
}
catch {
  Write-Host "Hot restart failed: $($_.Exception.Message)"
  Write-Host "Press R in the Flutter terminal instead."
  exit 1
}
