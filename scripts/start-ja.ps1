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

function Test-ServerUp {
  try {
    $resp = Invoke-WebRequest -Uri "http://127.0.0.1:4820/api/health" -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop
    return $resp.StatusCode -eq 200
  } catch {
    return $false
  }
}

# This repo is often carried between machines on a portable drive (same
# node_modules directory, different PC each time). Native addons like
# better-sqlite3 are compiled against a specific Node.js ABI
# (process.versions.modules), so switching to a PC running a different
# Node.js version breaks them with ERR_DLOPEN_FAILED until rebuilt.
#
# Skip this entirely if a server is already up: its native module is loaded
# and Windows locks loaded .node files, so rebuilding now would EPERM on the
# unlink regardless of whether a rebuild is actually needed.
if (-not (Test-ServerUp)) {
  $abiMarker = Join-Path $RepoRoot "node_modules\.ccam-node-abi"
  $currentAbi = (node -p "process.versions.modules").Trim()
  $lastAbi = if (Test-Path $abiMarker) { (Get-Content $abiMarker -Raw).Trim() } else { $null }
  if ($lastAbi -ne $currentAbi) {
    Write-Host "[start-ja] Node ABI changed ($lastAbi -> $currentAbi) — rebuilding native modules..." -ForegroundColor Cyan
    npm rebuild
    Set-Content -Path $abiMarker -Value $currentAbi -NoNewline
  }
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