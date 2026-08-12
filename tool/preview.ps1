# Start Flutter web preview in Chrome (full DWDS debug session).
# Keeps stdin open so tool/hot_restart.ps1 can send R / r.
# Run ONCE. After code edits use tool/hot_restart.ps1 — do not start a second Chrome.
$ErrorActionPreference = 'Continue'
$flutterBin = "$env:USERPROFILE\flutter\bin"
if (Test-Path $flutterBin) {
  $env:PATH = "$flutterBin;$env:PATH"
}

Set-Location (Split-Path $PSScriptRoot -Parent)

$port = 7357
$uriFile = Join-Path $PSScriptRoot '.preview_url.txt'
$vmUriFile = Join-Path $PSScriptRoot '.preview_vm_uri.txt'
$pidFile = Join-Path $PSScriptRoot '.preview_pid.txt'
$cmdFile = Join-Path $PSScriptRoot '.preview_cmd.txt'
Set-Content -Path $uriFile -Value "http://localhost:$port" -NoNewline

$listening = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
if ($listening) {
  Write-Host "Preview already running on port $port."
  Write-Host "Refreshing existing Chrome window (not opening a new one)..."
  & (Join-Path $PSScriptRoot 'hot_restart.ps1')
  exit $LASTEXITCODE
}

# Clear stale control files
Remove-Item -Force -ErrorAction SilentlyContinue $cmdFile, $pidFile
Set-Content -Path $cmdFile -Value '' -NoNewline

$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterCmd) {
  Write-Host "flutter not found on PATH. Install Flutter or add it to PATH."
  exit 1
}

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $flutterCmd.Source
$psi.Arguments = "run -d chrome --web-hostname=localhost --web-port=$port"
$psi.WorkingDirectory = (Get-Location).Path
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
# Ensure UTF-8 so VM URI lines parse correctly
$psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8
$psi.StandardErrorEncoding = [System.Text.Encoding]::UTF8

Write-Host "Starting Flutter Chrome preview (port $port)..."
Write-Host "Leave this terminal open. After code edits run: tool/hot_restart.ps1"

$proc = [System.Diagnostics.Process]::Start($psi)
Set-Content -Path $pidFile -Value $proc.Id -NoNewline
Write-Host "Flutter PID $($proc.Id) (stdin attached for hot restart)."

# Async line readers for stdout/stderr
$outQueue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
$errHandler = {
  if (-not [string]::IsNullOrEmpty($EventArgs.Data)) {
    $Event.MessageData.Enqueue('[err] ' + $EventArgs.Data)
  }
}
$outHandler = {
  if (-not [string]::IsNullOrEmpty($EventArgs.Data)) {
    $Event.MessageData.Enqueue($EventArgs.Data)
  }
}
Register-ObjectEvent -InputObject $proc -EventName OutputDataReceived -Action $outHandler -MessageData $outQueue | Out-Null
Register-ObjectEvent -InputObject $proc -EventName ErrorDataReceived -Action $outHandler -MessageData $outQueue | Out-Null
$proc.BeginOutputReadLine()
$proc.BeginErrorReadLine()

$lastCmdWrite = Get-Item $cmdFile | Select-Object -ExpandProperty LastWriteTimeUtc

try {
  while (-not $proc.HasExited) {
    # Drain flutter logs
    $line = $null
    while ($outQueue.TryDequeue([ref]$line)) {
      Write-Host $line
      if ($line -match 'Dart VM Service on Chrome is available at:\s+(\S+)') {
        Set-Content -Path $vmUriFile -Value $Matches[1].Trim() -NoNewline
        Write-Host "Saved VM URI for hot_restart.ps1"
      }
    }

    # Poll command file for R / r / q from hot_restart.ps1
    if (Test-Path $cmdFile) {
      $info = Get-Item $cmdFile
      if ($info.LastWriteTimeUtc -gt $lastCmdWrite) {
        $lastCmdWrite = $info.LastWriteTimeUtc
        $cmds = @(Get-Content $cmdFile -ErrorAction SilentlyContinue | Where-Object { $_.Trim() -ne '' })
        # Clear file so we don't re-send
        Set-Content -Path $cmdFile -Value '' -NoNewline
        foreach ($c in $cmds) {
          $key = $c.Trim()
          if ($key -match '^[rRq]$') {
            Write-Host ">> Sending '$key' to flutter run"
            $proc.StandardInput.WriteLine($key)
            $proc.StandardInput.Flush()
          }
        }
      }
    }

    Start-Sleep -Milliseconds 200
  }
}
finally {
  Remove-Item -Force -ErrorAction SilentlyContinue $pidFile
  if (-not $proc.HasExited) {
    try { $proc.Kill() } catch {}
  }
  Write-Host "Flutter preview exited with code $($proc.ExitCode)."
}
