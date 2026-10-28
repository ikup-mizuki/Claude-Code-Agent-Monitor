#!/usr/bin/env pwsh
# update-ja.ps1 — 本家(hoangsonww/Claude-Code-Agent-Monitor)の更新を
# この日本語版フォークに繰り返し取り込むためのスクリプト。
#
# ダッシュボードの更新バナーが勧める manual_command
# ("git fetch upstream && git merge --ff-only upstream/master && ...")を使わない理由:
# --ff-only は、このブランチが分岐点より後に独自コミットを持たない場合しか通らない。
# このフォークには常に独自コミット(日本語訳)があるので fast-forward できず、
# 必ず "Not possible to fast-forward" で失敗する。通常のマージ(--ff-only なし)が
# 必要で、まれに人手でのコンフリクト解消が要る。
#
# 毎回 .github/workflows/ を取り除く理由: このリポジトリは Git Credential Manager
# (OAuth)経由で push しており、"workflow" スコープを持たない。GitHub は
# .github/workflows/* を作成・更新する push を拒否し、本家がそのパスを触るたびに
# 通常のマージで再び入ってくる(.gitignore だけでは、本家で追跡済みのパスへの
# 変更がマージで入るのを止められない)。そこで push 時に失敗させるのではなく、
# マージのたびにコミット前にこのディレクトリを明示的に除外する。
#
# 使い方:
#   pwsh scripts/update-ja.ps1              # fetch → merge → 検証 → ビルド
#   pwsh scripts/update-ja.ps1 -Continue     # 手でコンフリクトを解消して git add した後、
#                                             # マージコミットを完了させて続きを実行
#
# 注: 日本語を含むため Windows PowerShell 5.1(powershell.exe)ではなく pwsh で実行すること。

param(
  [switch]$Continue
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $RepoRoot

function Step($msg) { Write-Host "[update-ja] $msg" -ForegroundColor Cyan }
function Warn($msg) { Write-Host "[update-ja] $msg" -ForegroundColor Yellow }
function Fail($msg) { Write-Host "[update-ja] $msg" -ForegroundColor Red; exit 1 }

function Complete-Merge {
  # コンフリクトなしの場合と -Continue の場合で共通の後半処理:
  # .github/workflows/ を除外し(冒頭コメント参照)、コミットを確定する。
  $workflowsDir = Join-Path $RepoRoot ".github\workflows"
  if (Test-Path $workflowsDir) {
    Step "このマージから .github/workflows/ を除外します(OAuth の push 制限のため。.gitignore 参照)"
    git rm -r --cached --ignore-unmatch .github/workflows | Out-Null
    Remove-Item -Recurse -Force $workflowsDir -ErrorAction SilentlyContinue
  }
  git commit --no-edit
  if ($LASTEXITCODE -ne 0) { Fail "git commit に失敗しました(上の出力を参照)。マージが本当に進行中か git status で確認してください" }
}

if ($Continue) {
  $unmerged = git diff --name-only --diff-filter=U
  if ($unmerged) {
    Fail "未解消のファイルがあります: $($unmerged -join ', ')`nそれらのファイルのコンフリクトマーカーを解消して git add し、-Continue を付けて再実行してください。"
  }
  Step "未解消のコンフリクトはありません。マージを完了します..."
  Complete-Merge
}
else {
  $dirty = git status --porcelain
  if ($dirty) {
    Fail "作業ツリーに未コミットの変更があります。先にコミットか stash をしてください:`n$dirty"
  }

  Step "upstream を fetch しています..."
  git fetch upstream --prune
  if ($LASTEXITCODE -ne 0) { Fail "git fetch upstream に失敗しました。'upstream' リモートが設定されているか確認してください(git remote -v)" }

  $behind = (git rev-list --count HEAD..upstream/master).Trim()
  if ($behind -eq "0") {
    Step "upstream/master と同じ状態です。やることはありません。"
    exit 0
  }
  Step "upstream/master より $behind コミット遅れています。マージします(このフォークには常に日本語版の独自コミットがあるため --ff-only は使いません)..."

  # コンフリクトが無くても --no-commit にして、コミット作成前に .github/workflows/ を
  # 除外できるようにする(毎回追加の後始末コミットが要らなくなる)。
  git merge upstream/master --no-commit --no-ff
  if ($LASTEXITCODE -ne 0) {
    $conflicts = git diff --name-only --diff-filter=U
    if (-not $conflicts) { Fail "コンフリクト以外の理由で git merge に失敗しました(上の出力を参照)" }
    Warn "コンフリクトでマージが止まりました:`n  $($conflicts -join "`n  ")"
    Warn "各ファイルを手で解消してください。client/src/i18n/index.ts と client/src/components/Sidebar.tsx が最もコンフリクトしやすく、その場合は本家の変更と 'ja' の追加の両方を残してください(JA-SETUP.md 参照)。"
    Warn "解消後: git add <解消したファイル> をしてから再実行:  pwsh scripts/update-ja.ps1 -Continue"
    exit 1
  }
  Complete-Merge
}

Step "ja/ ロケールに未翻訳の新規キーがないか確認しています..."
node (Join-Path $RepoRoot "scripts\verify-ja-locales.js")
if ($LASTEXITCODE -ne 0) {
  Warn "本家で追加されたキーに日本語訳がありません(上に MISSING として表示)。"
  Warn "対応する client/src/i18n/locales/ja/*.json に追加してから、このスクリプトを再実行してください(マージはコミット済みなので、セットアップ・ビルドまで進みます)。"
  exit 1
}

# `npm run setup` を使わない理由: v2.3.0 以降これは mcp/ もインストールし、mcp/ の
# `file:..` 依存はシンボリックリンク/ジャンクションを必要とするが、このリポジトリを
# 置いている exFAT ドライブでは作れない(EISDIR)。そこで mcp/ は --install-links
# (リンクの代わりにコピー。--no-save で mcp/package-lock.json は変更しない)で入れる。
Step "root・client・mcp の依存を同期しています..."
npm install
if ($LASTEXITCODE -ne 0) { Fail "npm install (root) に失敗しました(上の出力を参照)" }
# `npm --prefix client install` を使わない理由: v2.4.x 以降、リポジトリ直下から実行すると
# root パッケージを client の `file:..` 依存として解決し、シンボリックリンクを作ろうとする
# (exFAT では EISDIR)。client/ の中で実行すればこれを避けられる。
Push-Location client
npm install
$clientExit = $LASTEXITCODE
Pop-Location
if ($clientExit -ne 0) { Fail "npm install (client) に失敗しました(上の出力を参照)" }
npm --prefix mcp install --install-links --no-save
if ($LASTEXITCODE -ne 0) { Fail "npm install (mcp) に失敗しました(上の出力を参照)" }
npm run mcp:build
if ($LASTEXITCODE -ne 0) { Fail "npm run mcp:build に失敗しました(上の出力を参照)" }

Step "client をビルドしています..."
npm run build
if ($LASTEXITCODE -ne 0) { Fail "npm run build に失敗しました(上の出力を参照)" }

Write-Host ""
Step "完了しました。ダッシュボードのサーバーが起動中なら再起動してください: pwsh scripts/start-ja.ps1"
Step "その後: git push"
