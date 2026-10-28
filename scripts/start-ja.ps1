#!/usr/bin/env pwsh
# start-ja.ps1 — Claude-Code-Agent-Monitor 日本語版フォークの準備+起動スクリプト。
#
# そのPCでの初回実行時は依存(root・client)をインストールし、本番用 client が
# 無ければビルドする。2回目以降はサーバーを起動するだけ
# (何度実行しても安全。起動済みなら ccam start は何もしない)。
#
# 使い方:
#   pwsh scripts/start-ja.ps1            # (必要なら)ビルド → 起動 → ブラウザで開く
#   pwsh scripts/start-ja.ps1 -Dev       # 代わりに開発用サーバー2つを起動(npm run dev)
#   pwsh scripts/start-ja.ps1 -NoOpen    # ブラウザを開かずに起動
#
# 注: 日本語を含むため Windows PowerShell 5.1(powershell.exe)ではなく pwsh で実行すること。

param(
  [switch]$Dev,
  [switch]$NoOpen
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $RepoRoot

# 「node_modules があるか」で判定せず、毎回 npm install する。その判定では、
# node_modules は既にある(別PC・前のコミット由来)のに、マージで package.json に
# 依存が増えた場合(例: 本家更新で cross-spawn が追加)を見逃した。
# 変更が無ければ npm install は数秒で終わるので、不要な回でもコストは小さい。
Write-Host "[start-ja] root の依存を同期しています..." -ForegroundColor Cyan
npm install
if ($LASTEXITCODE -ne 0) { Write-Host "[start-ja] npm install (root) に失敗しました" -ForegroundColor Red; exit 1 }

Write-Host "[start-ja] client の依存を同期しています..." -ForegroundColor Cyan
Push-Location (Join-Path $RepoRoot "client")
npm install
$clientInstallExit = $LASTEXITCODE
Pop-Location
if ($clientInstallExit -ne 0) { Write-Host "[start-ja] npm install (client) に失敗しました" -ForegroundColor Red; exit 1 }

function Test-ServerUp {
  try {
    $resp = Invoke-WebRequest -Uri "http://127.0.0.1:4820/api/health" -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop
    return $resp.StatusCode -eq 200
  } catch {
    return $false
  }
}

# このリポジトリはポータブルドライブで複数PC間を持ち運ぶことが多い
# (node_modules は同じで、PCだけ毎回違う)。better-sqlite3 などのネイティブ
# アドオンは特定の Node.js ABI(process.versions.modules)向けにコンパイル
# されるため、Node.js のバージョンが違うPCに移ると、再ビルドするまで
# ERR_DLOPEN_FAILED で壊れる。
#
# サーバーが既に起動中ならここは丸ごと飛ばす。ネイティブモジュールが読み込み済みで
# Windows は読み込み中の .node ファイルをロックするため、再ビルドが必要かどうかに
# 関係なく削除時に EPERM になる。
if (-not (Test-ServerUp)) {
  $abiMarker = Join-Path $RepoRoot "node_modules\.ccam-node-abi"
  $currentAbi = (node -p "process.versions.modules").Trim()
  $lastAbi = if (Test-Path $abiMarker) { (Get-Content $abiMarker -Raw).Trim() } else { $null }
  if ($lastAbi -ne $currentAbi) {
    Write-Host "[start-ja] Node ABI が変わりました ($lastAbi -> $currentAbi)。ネイティブモジュールを再ビルドしています..." -ForegroundColor Cyan
    npm rebuild
    Set-Content -Path $abiMarker -Value $currentAbi -NoNewline
  }
}

if ($Dev) {
  Write-Host "[start-ja] 開発用サーバーを起動しています (npm run dev)..." -ForegroundColor Cyan
  npm run dev
  exit $LASTEXITCODE
}

$clientDist = Join-Path $RepoRoot "client\dist\index.html"
if (-not (Test-Path $clientDist)) {
  Write-Host "[start-ja] client\dist がありません。ビルドしています..." -ForegroundColor Cyan
  npm run build
}

node (Join-Path $RepoRoot "bin\ccam.js") start
if (-not $NoOpen) {
  node (Join-Path $RepoRoot "bin\ccam.js") open
}

Write-Host ""
Write-Host "[start-ja] VSCode: アクティビティバーのレーダーアイコンからダッシュボードを埋め込み表示できます。" -ForegroundColor DarkGray
Write-Host "[start-ja] サーバーの停止: node bin\ccam.js status で PID を確認して終了してください" -ForegroundColor DarkGray
