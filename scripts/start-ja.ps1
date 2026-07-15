#!/usr/bin/env pwsh
# start-ja.ps1 — bootstrap + start for this ja-locale fork of Claude-Code-Agent-Monitor.
#
# First run on a machine: installs dependencies (root + client) and builds the
# production client if missing. Every run after that just starts the server
# (idempotent — safe to run repeatedly; ccam start no-ops if already running).
#
# Usage:
#   pwsh scripts/start-ja.ps1            # build (if needed) + start + open browser
#   pwsh scripts/start-ja.ps1 -Dev       # run the two dev servers instead (npm run dev)
#   pwsh scripts/start-ja.ps1 -NoOpen    # start without opening a browser tab

param(
  [switch]$Dev,
  [switch]$NoOpen
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $RepoRoot

if (-not (Test-Path (Join-Path $RepoRoot "node_modules"))) {
  Write-Host "[start-ja] installing root dependencies..." -ForegroundColor Cyan
  npm install
}

if (-not (Test-Path (Join-Path $RepoRoot "client\node_modules"))) {
  Write-Host "[start-ja] installing client dependencies..." -ForegroundColor Cyan
  Push-Location (Join-Path $RepoRoot "client")
  npm install
  Pop-Location
}

if ($Dev) {
  Write-Host "[start-ja] starting dev servers (npm run dev)..." -ForegroundColor Cyan
  npm run dev
  exit $LASTEXITCODE
}

$clientDist = Join-Path $RepoRoot "client\dist\index.html"
if (-not (Test-Path $clientDist)) {
  Write-Host "[start-ja] client\dist missing — building..." -ForegroundColor Cyan
  npm run build
}

node (Join-Path $RepoRoot "bin\ccam.js") start
if (-not $NoOpen) {
  node (Join-Path $RepoRoot "bin\ccam.js") open
}

Write-Host ""
Write-Host "[start-ja] VSCode: open the radar icon in the activity bar to embed the dashboard." -ForegroundColor DarkGray
Write-Host "[start-ja] stop the server: node bin\ccam.js status   (shows the PID to kill)" -ForegroundColor DarkGray