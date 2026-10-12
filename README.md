# Claude Code、Cursor & Codex 向けエージェントダッシュボード

> このリポジトリは [hoangsonww/Claude-Code-Agent-Monitor](https://github.com/hoangsonww/Claude-Code-Agent-Monitor) に日本語ロケールを追加したフォークです。本ページは本家 v2.3.0 時点(2026-10-12)の README を和訳したものです(原文: [README-TOP-EN.md](./README-TOP-EN.md))。日本語版のセットアップは [JA-SETUP.md](./JA-SETUP.md) を参照してください。

### AI コーディングエージェントのためのローカルファーストな管制室

Claude Code、Cursor、Codex のセッションをリアルタイムで監視します。会話やツール呼び出しを追跡し、エージェントの階層構造を確認し、トークン使用量とコストを把握し、オーケストレーションを分析して、ローカルのエージェントを 1 つのレスポンシブなダッシュボードから操作できます。

> [!TIP]
> **詳細ガイド:** [日本語](./README-JA.md) · [English](./README-EN.md) · [中文](./README-CN.md) · [Tiếng Việt](./README-VN.md) · [한국어](./README-KO.md) · [Español](./README-ES.md)

![Claude Code](https://img.shields.io/badge/Claude_Code-orange?style=flat-square&logo=claude&logoColor=white)
![Cursor](https://img.shields.io/badge/Cursor-111827?style=flat-square&logo=cursor&logoColor=white)
![OpenAI Codex](https://img.shields.io/badge/OpenAI_Codex-blue?style=flat-square&logo=githubcopilot&logoColor=white)
![Claude Code Plugins](https://img.shields.io/badge/Claude_Code_&_Codex-Plugins_&_Skills-orange?style=flat-square&logo=anthropic&logoColor=white)
![Model Context Protocol](https://img.shields.io/badge/Model_Context_Protocol-1.0-0f766e?style=flat-square&logo=modelcontextprotocol&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-%3E%3D22.22-339933?style=flat-square&logo=node.js&logoColor=white)
![Python](https://img.shields.io/badge/Python-%3E%3D3.6-3776AB?style=flat-square&logo=python&logoColor=white)
![Express](https://img.shields.io/badge/Express-4.21-000000?style=flat-square&logo=express&logoColor=white)
![ws](https://img.shields.io/badge/ws-WebSocket_server-010101?style=flat-square&logo=socketdotio&logoColor=white)
![web-push](https://img.shields.io/badge/web--push-VAPID-3b82f6?style=flat-square&logo=javascript&logoColor=white)
![swagger-ui-express](https://img.shields.io/badge/swagger--ui--express-5.0-85EA2D?style=flat-square&logo=swagger&logoColor=white)
![multer](https://img.shields.io/badge/multer-multipart_upload-FF6B6B?style=flat-square&logo=express&logoColor=white)
![adm-zip](https://img.shields.io/badge/adm--zip-archive_extract-FBBF24?style=flat-square&logo=files&logoColor=white)
![tar](https://img.shields.io/badge/tar-tgz_extract-A78BFA?style=flat-square&logo=gnu&logoColor=white)
![Commander CLI](https://img.shields.io/badge/Commander_CLI-14-F05032?style=flat-square&logo=gnubash&logoColor=white)
![React](https://img.shields.io/badge/React-19.2-61DAFB?style=flat-square&logo=react&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-5.7-3178C6?style=flat-square&logo=typescript&logoColor=white)
![Javascript](https://img.shields.io/badge/JavaScript-ES6-F7DF1E?style=flat-square&logo=javascript&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-7.3-646CFF?style=flat-square&logo=vite&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-3.4-06B6D4?style=flat-square&logo=tailwindcss&logoColor=white)
![PostCSS](https://img.shields.io/badge/PostCSS-8.5-DD3A0A?style=flat-square&logo=postcss&logoColor=white)
![Autoprefixer](https://img.shields.io/badge/Autoprefixer-10.4-DD3735?style=flat-square&logo=autoprefixer&logoColor=white)
![React Router](https://img.shields.io/badge/React_Router-8.3-CA4245?style=flat-square&logo=reactrouter&logoColor=white)
![Lucide](https://img.shields.io/badge/Lucide_Icons-0.474-F56565?style=flat-square&logo=lucide&logoColor=white)
![D3.js](https://img.shields.io/badge/D3.js-7-F9A03C?style=flat-square&logo=d3&logoColor=white)
![Mermaid](https://img.shields.io/badge/Mermaid-10.2-ff3333?style=flat-square&logo=mermaid&logoColor=white)
![i18next](https://img.shields.io/badge/i18next-22.4-7A42FF?style=flat-square&logo=i18next&logoColor=white)
![i18next Language Detector](https://img.shields.io/badge/i18next_Language_Detector-6.1-7A42FF?style=flat-square&logo=i18next&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-3-003B57?style=flat-square&logo=sqlite&logoColor=white)
![better--sqlite3](https://img.shields.io/badge/better--sqlite3-11.7-003B57?style=flat-square&logo=sqlite&logoColor=white)
![better-sqlite3 WAL](https://img.shields.io/badge/better--sqlite3-WAL_mode-003B57?style=flat-square&logo=sqlite&logoColor=white)
![WebSocket](https://img.shields.io/badge/WebSocket-RFC_6455-010101?style=flat-square&logo=socketdotio&logoColor=white)
![SSE](https://img.shields.io/badge/SSE-Server_Sent_Events-FF6600?style=flat-square&logo=googlechrome&logoColor=white)
![OpenAPI](https://img.shields.io/badge/OpenAPI-3.0-000000?style=flat-square&logo=openapiinitiative&logoColor=white)
![Swagger](https://img.shields.io/badge/Swagger-3.0-85EA2D?style=flat-square&logo=swagger&logoColor=white)
![VS Code](https://img.shields.io/badge/VS_Code-Extension-007ACC?style=flat-square&logo=vscodium&logoColor=white)
![Electron](https://img.shields.io/badge/Electron-35-47848F?style=flat-square&logo=electron&logoColor=white)
![electron-builder](https://img.shields.io/badge/electron--builder-25.1-2c2e3b?style=flat-square&logo=electron&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-Desktop_App-000000?style=flat-square&logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-Desktop_App-0078D6?style=flat-square&logo=windows&logoColor=white)
![SMAppService](https://img.shields.io/badge/SMAppService-Login_Items-000000?style=flat-square&logo=apple&logoColor=white)
![macOS DMG](https://img.shields.io/badge/macOS_DMG-arm64_%2B_x64-7c3aed?style=flat-square&logo=apple&logoColor=white)
![NSIS Installer](https://img.shields.io/badge/Windows-NSIS_%2B_Portable-1f6feb?style=flat-square&logo=windows&logoColor=white)
![Vitest](https://img.shields.io/badge/Vitest-1.0-646CFF?style=flat-square&logo=vitest&logoColor=white)
![React Testing Library](https://img.shields.io/badge/React_Testing_Library-13.0-FF5733?style=flat-square&logo=testinglibrary&logoColor=white)
![ESLint](https://img.shields.io/badge/ESLint-8.44-4B32C3?style=flat-square&logo=eslint&logoColor=white)
![Prettier](https://img.shields.io/badge/Prettier-3.8-F7B93E?style=flat-square&logo=prettier&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-20.10-2496ED?style=flat-square&logo=docker&logoColor=white)
![Podman](https://img.shields.io/badge/Podman-4.0-CC342D?style=flat-square&logo=podman&logoColor=white)
![Open Container Initiative](https://img.shields.io/badge/Open_Container_Initiative-OCI-000000?style=flat-square&logo=opencontainersinitiative&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-3.13-E6522C?style=flat-square&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-13.1-F46800?style=flat-square&logo=grafana&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.7-844FBA?style=flat-square&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-%3E%3D1.29-326CE5?style=flat-square&logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-4-0F1689?style=flat-square&logo=helm&logoColor=white)
![Kustomize](https://img.shields.io/badge/Kustomize-5.0-326CE5?style=flat-square&logo=kubernetes&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-Ingress-009639?style=flat-square&logo=nginx&logoColor=white)
![Coralogix](https://img.shields.io/badge/Coralogix-Observability-1a1a2e?style=flat-square&logo=datadog&logoColor=white)
![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-Collector-4f46e5?style=flat-square&logo=opentelemetry&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-ECS%20%7C%20RDS-232F3E?style=flat-square&logo=task&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-GKE%20%7C%20SQL-4285F4?style=flat-square&logo=googlecloud&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-AKS%20%7C%20SQL-0078D4?style=flat-square&logo=cloudflare&logoColor=white)
![Oracle Cloud](https://img.shields.io/badge/Oracle_Cloud-OKE%20%7C%20DB-F80000?style=flat-square&logo=cloudways&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-pipelines-2088FF?style=flat-square&logo=githubactions&logoColor=white)
![Make](https://img.shields.io/badge/Make-4.3-000000?style=flat-square&logo=make&logoColor=white)
![Auto Release](https://img.shields.io/badge/CI-auto--release_to_GitHub-22c55e?style=flat-square&logo=githubactions&logoColor=white)
![MIT License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

<p align="center">
  <a href="images/analytics.png"><img src="images/readme/analytics.png" alt="CCAM dashboard with live agent and session activity" width="100%"></a>
  <br>
  <em>ライブのフリート状態、進行中の作業、最近のイベント、コスト、システムの健全性。</em>
</p>

## エージェントの動作を把握する

CCAM はネイティブフックとプロバイダー対応のトランスクリプト検出を組み合わせています。既定ではローカルにとどまり、エージェントの活動を検索可能で永続的な運用記録に変換します。

- **1 つのライブフリート:** Claude Code、Cursor、Codex のセッションが同じ Dashboard、Sessions、Activity Feed、Kanban ビューに表示されます。
- **会話の完全な再現:** レンダリング済みの Markdown、ハイライト付きコード、ツール呼び出し、コマンド出力、キュー待ちのプロンプト、添付ファイル、プロバイダー固有のタイトル。
- **エージェントのオーケストレーション:** 親子ツリー、バックグラウンドエージェント、動的なワークフロー実行、ツールフローのグラフ、並行実行数、委任、コンパクション分析。
- **コストと使用量:** モデルを考慮したトークン数、設定可能な料金、導入時の割引料金、サブエージェントのコスト、傾向、予算に優しい CLI/MCP アクセス。
- **エージェントの実行と再開:** Claude Code または Codex を起動し、出力をストリーミングし、追加の指示を送り、前回の作業を再開して、バックグラウンド実行に再接続できます。
- **設定の可視化:** Claude Code と Codex の設定、スキル、フック、MCP サーバー、ルール、プラグイン、メモリ、プロファイル、指示を確認できます。
- **運用上の安全性:** ループバックへのバインド、任意の認証、ガード付きの変更操作、バックアップ優先の編集、サイズ上限付きのアップロード、自動セルフアップデートなし。
- **チーム利用への対応:** デスクトップアプリ、コンテナ、Kubernetes、Terraform、監視、アラート、Webhook、リモートのデータソース。

## CCAM の動作を見る

<p align="center">
  <a href="images/session-conversation.png"><img src="images/readme/session-conversation.png" alt="Rendered agent conversation with code and tool activity" width="100%"></a>
  <br>
  <em>会話履歴、コード、ツール、推論、セッションの文脈。</em>
</p>

<p align="center">
  <a href="images/workflows.png"><img src="images/readme/workflows.png" alt="Workflow and orchestration analytics" width="100%"></a>
  <br>
  <em>オーケストレーション、委任、ツール、エラー、並行実行のためのワークフロー分析。</em>
</p>

<p align="center">
  <a href="images/config.png"><img src="images/readme/config.png" alt="Claude Code and Codex configuration explorers" width="100%"></a>
  <br>
  <em>プロバイダーを意識した設定、スキル、フック、プラグイン、MCP、ルール、メモリ。</em>
</p>

<p align="center">
  <a href="images/run.png"><img src="images/readme/run.png" alt="Run Agent provider selection" width="100%"></a>
  <br>
  <em>ダッシュボードを離れずに Claude Code や Codex を起動・管理できます。</em>
</p>

## クイックスタート

**要件:** Node.js 22.22 以降と npm 9 以降。

```bash
git clone https://github.com/hoangsonww/Claude-Code-Agent-Monitor.git
cd Claude-Code-Agent-Monitor
npm run setup
npm run dev
```

[http://localhost:5173](http://localhost:5173) を開きます。`npm run setup` は、ルート、クライアント、VS Code 拡張機能の依存関係をインストールし、MCP サーバーをビルドして `ccam` CLI をリンクします。初回起動時は、ダッシュボードの案内に従って、選択したプロバイダー向けのフックをインストールするか、`npm run install-hooks` を手動で実行してください。

本番環境では `npm run build && npm start` を実行し、[http://localhost:4820](http://localhost:4820) を開きます。

## CCAM の実行方法を選ぶ

| 選択肢 | 適した用途 | ガイド |
| --- | --- | --- |
| ソースチェックアウト | 開発とローカルでのカスタマイズ | [完全なセットアップガイド](./README-EN.md#quick-start) |
| デスクトップアプリ | トレイ操作を備えた常駐型の macOS / Windows アプリ | [デスクトップガイド](./DESKTOP.md) |
| Docker または Podman | 分離されたローカル環境またはサーバーへのデプロイ | [デプロイガイド](./DEPLOYMENT.md) |
| Kubernetes または Terraform | 本番インフラ | [デプロイリファレンス](./docs/DEPLOYMENT.md) |
| MCP サイドカー | エージェントからのダッシュボード照会とガード付きの操作 | [MCP ガイド](./mcp/README.md) |

## 拡張機能と自動化

CCAM には、Claude Code と Codex の両形式で **14 個のプラグイン**、**66 個のプラグインスキル**、**18 個の Claude サブエージェント**、**34 個の Claude コマンド**、そして合計 **77 個のリポジトリスキル**が含まれています。

```bash
claude plugin marketplace add hoangsonww/Claude-Code-Agent-Monitor
codex plugin marketplace add hoangsonww/Claude-Code-Agent-Monitor
npx skills add hoangsonww/Claude-Code-Agent-Monitor --list
```

`ccam` CLI とローカル MCP サーバーは、セッション、エージェント、イベント、トランスクリプト、分析、料金、ワークフロー、アラート、インポート、設定、リモートソース、保守操作を、人間と自動化の両方に向けて公開します。

## ドキュメント

- **製品・運用の完全リファレンス:** [README-JA.md](./README-JA.md)(英語版: [README-EN.md](./README-EN.md))
- **ドキュメント索引:** [docs/README.md](./docs/README.md)
- **タスク志向のハンドブック:** [GitHub Wiki](https://github.com/hoangsonww/Claude-Code-Agent-Monitor/wiki)
- **ローカライズ済みの製品ツアー:** [Static Wiki](https://hoangsonww.github.io/Claude-Code-Agent-Monitor/wiki/)
- **アーキテクチャ:** [ARCHITECTURE.md](./ARCHITECTURE.md)
- **CLI:** [docs/CLI.md](./docs/CLI.md)
- **REST と OpenAPI:** [docs/API.md](./docs/API.md)
- **フックとライフサイクル:** [docs/HOOKS.md](./docs/HOOKS.md)
- **データベース:** [docs/DATABASE.md](./docs/DATABASE.md)
- **プラグイン:** [docs/PLUGINS.md](./docs/PLUGINS.md)
- **MCP:** [docs/MCP.md](./docs/MCP.md) と [mcp/README.md](./mcp/README.md)
- **デスクトップアプリケーション:** [DESKTOP.md](./DESKTOP.md) と [desktop/README.md](./desktop/README.md)
- **デプロイ:** [DEPLOYMENT.md](./DEPLOYMENT.md) と [docs/DEPLOYMENT.md](./docs/DEPLOYMENT.md)
- **セキュリティ:** [.github/SECURITY.md](./.github/SECURITY.md)

## ローカルファーストかつ既定で安全

ダッシュボードは既定で `127.0.0.1` にバインドされます。クラウドの認証情報は不要で、トランスクリプトやエージェントのデータをホスト型サービスへ送信することもありません。ループバックの外へ意図的に公開する場合は、任意のトークンにより HTTP、WebSocket、フック、MCP、リモートプッシュの各経路が保護されます。

リモートアクセスを有効にする前に、[セキュリティポリシー](./.github/SECURITY.md) と [設定の完全リファレンス](./README-EN.md#configuration) を確認してください。

## コントリビューションとサポート

- [コントリビューションガイド](./.github/CONTRIBUTING.md) を読んでください。
- バグは [GitHub Issues](https://github.com/hoangsonww/Claude-Code-Agent-Monitor/issues) から報告してください。
- 質問やアイデアの共有は [GitHub Discussions](https://github.com/hoangsonww/Claude-Code-Agent-Monitor/discussions) で行ってください。
- [行動規範](./.github/CODE_OF_CONDUCT.md) に従ってください。

## ライセンス

MIT。詳細は [LICENSE](./LICENSE) を参照してください。
