# 日本語ロケール版 セットアップ・運用メモ

このリポジトリは [hoangsonww/Claude-Code-Agent-Monitor](https://github.com/hoangsonww/Claude-Code-Agent-Monitor) をベースに、日本語(ja)ロケールをローカルパッチとして追加したフォークです(本家へのPR予定なし)。

- **origin**: `https://github.com/ikup-mizuki/Claude-Code-Agent-Monitor.git`(このリポジトリ)
- **upstream**: `https://github.com/hoangsonww/Claude-Code-Agent-Monitor.git`(本家。更新取り込み用に登録済み)

日本語化の詳細な変更内容・翻訳の経緯は `git log` を参照(コミット: 「github設定を変更しました」「日本語設定ファイルを追加しました」)。

## 新しいPCでのセットアップ(初回のみ)

### 前提

- Node.js / npm インストール済み
- VSCode インストール済み
- git インストール済み

### 手順

```powershell
git clone https://github.com/ikup-mizuki/Claude-Code-Agent-Monitor.git
cd Claude-Code-Agent-Monitor
pwsh scripts/start-ja.ps1
```

`start-ja.ps1` が初回実行時に以下を自動で行う。

- ルート・`client/` 両方の `npm install`
- 本番用クライアントのビルド(`npm run build`、`client/dist` が無い場合のみ)
- サーバー起動 + ブラウザで自動オープン

依存パッケージ(`node_modules`)はマシンごとに作り直す必要がある(ネイティブモジュールのバイナリやパスがマシン依存のため)。他PCの `node_modules` をコピーしてこないこと。

### VSCode拡張機能(手動、マシンごとに1回)

```powershell
code --install-extension hoangsonw.claude-code-agent-monitor
```

インストール後、アクティビティバーのレーダーアイコンから開く。サーバー(上記手順で起動済み)を自動検出してiframe表示される。

### Claude Codeフック連携(任意、マシンごとに1回)

サブエージェント階層の可視化(DAG表示)に必要。**実行前に必ず `~/.claude/settings.json` をバックアップすること**(このスクリプトはバックアップを取らず直接上書きする)。

```powershell
Copy-Item ~/.claude/settings.json ~/.claude/settings.json.bak-(Get-Date -Format yyyyMMdd)
npm run install-hooks
```

このコマンドは冪等(何度実行してもエントリが重複しない設計)なので、「既に実行済みか分からない」場合も再実行して問題ない。既存のフック(RTKやトースト通知など、コマンド文字列に `hook-handler.js` を含まないもの)は保持される。

### MCP サーバー連携(任意、マシンごとに1回)

Claude Code からダッシュボードをツール(103種)として操作できるようにする。例:「今日のコストは?」「失敗したセッションを一覧して」。ダッシュボードのサーバーが起動している必要がある。

1. MCP をビルドする(`scripts/update-ja.ps1` を実行済みなら不要)

   ```powershell
   npm --prefix mcp install --install-links --no-save
   npm run mcp:build
   ```

   `npm run setup` でも入るが、リポジトリを exFAT のドライブに置いている場合は `mcp/` のリンク作成で失敗する(EISDIR)。上のコマンドはリンクではなくコピーで入れるため exFAT でも通る。

2. Claude Code のユーザー設定に登録する(パスは clone した場所に置き換える)

   ```powershell
   claude mcp add --scope user ccam-dashboard -- node "<cloneしたパス>\bin\ccam.js" mcp stdio
   claude mcp get ccam-dashboard   # Status: Connected なら OK
   ```

   本家のプラグイン(`plugins/ccam-dashboard`)は `ccam` コマンドがグローバルに登録されている前提(`npm run link-cli`)だが、この方法ならグローバルの変更は不要。ドライブレターやパスがマシンごとに違う場合は、マシンごとに登録する。

- **有効/無効**: 設定はユーザーごと(`~/.claude.json`)で、他のユーザーには影響しない。一時的に止めるときは Claude Code の `/mcp`、外すときは `claude mcp remove ccam-dashboard -s user`
- **権限**: 初期状態では参照系のツールだけ使える。書き込み系(アラートルールや設定の変更、エージェントの起動など)も許可する場合は、登録時に `-e MCP_DASHBOARD_ALLOW_MUTATIONS=true` を付ける。全データ消去などの破壊的操作には、さらに `MCP_DASHBOARD_ALLOW_DESTRUCTIVE=true` が必要
- ツールの一覧と詳細は `mcp/README.md`

## 日常の起動

```powershell
pwsh scripts/start-ja.ps1
```

サーバーが既に起動していれば何もせず終了する(重複起動しない)。ソースコードを変更した場合は `client/dist` が古いままになるため、`npm run build` を手動で実行してから再度スクリプトを実行すること(自動リビルドはしない)。

開発中(翻訳追加やコード変更を継続する場合)は代わりに以下を使う。

```powershell
pwsh scripts/start-ja.ps1 -Dev
```

Vite開発サーバー + バックエンドの2プロセス構成で起動し、ソース変更が即座に反映される(ビルド不要、起動はやや遅い)。

## 停止

`ccam` に組み込みの stop コマンドはない。PIDを確認して手動で終了する。

```powershell
node bin\ccam.js status
# 表示されたPIDに対して:
Stop-Process -Id <PID>
```

## 本家の更新を取り込む場合

```powershell
pwsh scripts/update-ja.ps1
```

fetch → merge(`.github/workflows` は自動除外)→ 日本語キーの不足チェック → 依存更新(root・client・mcp)→ ビルドまで行う。コンフリクト時は手で解消して `git add` 後に `-Continue` を付けて再実行。`client/src/i18n/index.ts` や `client/src/components/Sidebar.tsx`(言語切替UI)でコンフリクトが起きやすい。日本語ロケール追加箇所(`ja` まわり)を残す形で手動解消すること。本家で言語一覧を持つ箇所が増えた場合(例: `client/src/lib/format.ts`、`client/src/lib/paletteCommands.ts`)は `ja` を追加する。

## 既知の注意点

- `npm audit` で12件の脆弱性が出るが、全てDoS系(RCE・認証情報漏洩ではない)。このツールはlocalhost限定で使う前提のため、`npm audit fix` は未実施(依存バージョンが本家の動作確認済み構成からずれるリスクを避けるため)
- Windows環境では、Viteの開発サーバーが `[::1]:5173`(IPv6ループバック)のみにバインドされ `127.0.0.1:5173` へのアクセスが失敗することがある。`localhost:5173` でアクセスすること
