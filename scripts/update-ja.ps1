#!/usr/bin/env pwsh
# update-ja.ps1 — pull upstream (hoangsonww/Claude-Code-Agent-Monitor) changes
# into this ja-locale fork, repeatably.
#
# Why not the manual_command the dashboard's own update banner suggests
# ("git fetch upstream && git merge --ff-only upstream/master && ...")?
# --ff-only only works if this branch has NO commits of its own beyond the
# fork point. This fork always has local-only commits (the ja translations),
# so it can never fast-forward — that command will always fail here with
# "Not possible to fast-forward". A real merge (no --ff-only) is required,
# which occasionally needs a human to resolve a conflict.
#
# Why does this also strip .github/workflows/ on every run? This is a
# private repo pushed via Git Credential Manager (OAuth) without the
# "workflow" scope. GitHub refuses any push that creates/updates
# .github/workflows/*, and a plain merge re-adds that path whenever upstream
# touches it (.gitignore alone doesn't stop a merge from bringing in changes
# to an already-tracked-upstream path). So every merge here explicitly drops
# that directory before committing, rather than failing at push time.
#
# Usage:
#   pwsh scripts/update-ja.ps1              # fetch + merge + verify + build
#   pwsh scripts/update-ja.ps1 -Continue     # after resolving conflicts by hand
#                                             # and `git add`-ing them, finishes
#                                             # the merge commit and carries on

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
  # Common tail for both the conflict-free path and the -Continue path:
  # strip .github/workflows/ (see header comment), then finalize the commit.
  $workflowsDir = Join-Path $RepoRoot ".github\workflows"
  if (Test-Path $workflowsDir) {
    Step "excluding .github/workflows/ from this merge (OAuth push restriction — see .gitignore)"
    git rm -r --cached --ignore-unmatch .github/workflows | Out-Null
    Remove-Item -Recurse -Force $workflowsDir -ErrorAction SilentlyContinue
  }
  git commit --no-edit
  if ($LASTEXITCODE -ne 0) { Fail "git commit failed (see above) — is a merge actually in progress? Check: git status" }
}

if ($Continue) {
  $unmerged = git diff --name-only --diff-filter=U
  if ($unmerged) {
    Fail "still unresolved: $($unmerged -join ', ')`nResolve the conflict markers in those files, then `git add` them and re-run with -Continue."
  }
  Step "no unresolved conflicts — completing the merge..."
  Complete-Merge
}
else {
  $dirty = git status --porcelain
  if ($dirty) {
    Fail "working tree isn't clean — commit or stash your changes first:`n$dirty"
  }

  Step "fetching upstream..."
  git fetch upstream --prune
  if ($LASTEXITCODE -ne 0) { Fail "git fetch upstream failed — check the 'upstream' remote is configured (git remote -v)" }

  $behind = (git rev-list --count HEAD..upstream/master).Trim()
  if ($behind -eq "0") {
    Step "already up to date with upstream/master. Nothing to do."
    exit 0
  }
  Step "$behind commit(s) behind upstream/master — merging (not --ff-only; this fork always has local-only ja commits)..."

  # --no-commit even on a clean merge, so we can strip .github/workflows/
  # before the commit exists (avoids an extra follow-up commit every time).
  git merge upstream/master --no-commit --no-ff
  if ($LASTEXITCODE -ne 0) {
    $conflicts = git diff --name-only --diff-filter=U
    if (-not $conflicts) { Fail "git merge failed for a reason other than conflicts (see above)" }
    Warn "merge stopped with conflicts in:`n  $($conflicts -join "`n  ")"
    Warn "Resolve each file by hand. client/src/i18n/index.ts and client/src/components/Sidebar.tsx are the files most likely to conflict — when they do, keep BOTH upstream's changes AND the 'ja' additions (see JA-SETUP.md)."
    Warn "When done: git add <resolved files>, then re-run:  pwsh scripts/update-ja.ps1 -Continue"
    exit 1
  }
  Complete-Merge
}

Step "checking ja/ locale files for new untranslated keys..."
node (Join-Path $RepoRoot "scripts\verify-ja-locales.js")
if ($LASTEXITCODE -ne 0) {
  Warn "upstream added new keys that don't have Japanese translations yet (listed above as MISSING)."
  Warn "Add them to the corresponding client/src/i18n/locales/ja/*.json file(s), then re-run this script (the merge is already committed, so it will just skip ahead to setup/build)."
  exit 1
}

Step "running npm run setup (root + client + vscode-extension deps)..."
npm run setup
if ($LASTEXITCODE -ne 0) { Fail "npm run setup failed (see above)" }

Step "building client..."
npm run build
if ($LASTEXITCODE -ne 0) { Fail "npm run build failed (see above)" }

Write-Host ""
Step "done. If the dashboard server is running, restart it: pwsh scripts/start-ja.ps1"
Step "then: git push"