# dotfiles

[mise](https://mise.jdx.dev/) でツール管理・タスク実行・環境変数を一元管理する dotfiles。mise は asdf の高速な代替ツールで、Node.js や Python などのランタイムバージョン管理に加え、タスクランナーや環境変数管理も提供します。

## 含まれる設定

| カテゴリ | ファイル | 説明 |
|----------|----------|------|
| Shell | `.zshrc`, `.p10k.zsh` | Zsh + Oh My Zsh + Powerlevel10k |
| Git | `.gitconfig`, `config/git/ignore` | Git グローバル設定 |
| Terminal | `.tmux.conf` | tmux 設定 |
| Terminal | `config/zellij/*` | Zellij 設定 + レイアウト |
| Editor | `config/nvim/*` | Neovim (LazyVim) |
| Tools | `config/mise/config.toml` | mise ツール・環境変数・エイリアス |
| GitHub | `config/gh/config.yml` | GitHub CLI 設定 |
| Claude | `.claude/*` | Claude Code 設定 |
| Codex | `.codex/*` | OpenAI Codex CLI 設定 |
| DevContainer | `.devcontainer/*` | DevPod/VS Code DevContainer |
| Windows | `windows-terminal/settings.json` | Windows Terminal 設定 |

## 新規マシンセットアップ

```bash
# 1. リポジトリをクローン
git clone https://github.com/ryoooo/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. mise をインストール
curl https://mise.run | sh
eval "$(~/.local/bin/mise activate bash)"  # 一時的に有効化

# 3. 完全セットアップ実行（ツールインストール + 設定デプロイ）
mise trust . && mise install && mise run setup

# 4. シェル再起動（Zsh + Oh My Zsh が有効になる）
exec zsh

# 5. API キーを設定（任意）
cp ~/dotfiles/config/mise/config.local.toml.example ~/.config/mise/config.local.toml
nvim ~/.config/mise/config.local.toml  # 必要なキーを設定

# 6. Claude Code MCP サーバー設定（任意）
mise run setup-mcp
```

## DevContainer（DevPod）

[DevPod](https://devpod.sh/) でローカル・クラウド問わず同一の開発環境を構築できます。Docker、AWS、GCP など複数のプロバイダーに対応。

### DevContainer のみ取得

既存プロジェクトに DevContainer 設定だけ追加したい場合：

```bash
mkdir -p .devcontainer && cd .devcontainer && \
curl -fsSLO https://raw.githubusercontent.com/ryoooo/dotfiles/main/.devcontainer/Dockerfile && \
curl -fsSLO https://raw.githubusercontent.com/ryoooo/dotfiles/main/.devcontainer/devcontainer.json && \
curl -fsSLO https://raw.githubusercontent.com/ryoooo/dotfiles/main/.devcontainer/init-firewall.sh && \
cd ..
```

### DevPod インストール（Ubuntu/Linux）

```bash
# CLI インストール
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" \
  && sudo install -c -m 0755 devpod /usr/local/bin \
  && rm -f devpod

# Docker プロバイダーを追加
devpod provider add docker
```

### ワークスペース操作

```bash
# 起動（VS Code）
devpod up . --ide vscode

# 起動（IDE なし、SSH接続用）
devpod up . --ide none

# SSH 接続（2つの方法）
ssh dotfiles.devpod           # SSH 直接接続
devpod ssh dotfiles           # devpod CLI 経由

# コンテナ内でコマンド実行
devpod ssh dotfiles --command "mise tasks"

# 一時停止（リソース節約）
devpod stop dotfiles

# 再開
devpod up dotfiles

# 完全削除
devpod delete dotfiles

# ワークスペース一覧
devpod list
```

### プロバイダー

```bash
# プロバイダー一覧
devpod provider list

# デフォルトプロバイダー切り替え（複数ある場合）
devpod provider use docker

# AWS プロバイダー追加
devpod provider add aws

# クラウドで起動
devpod up . --provider aws
```

### 構築の流れ

```
devpod up
↓
.devcontainer/Dockerfile: mise + 基本ツール
↓
postCreateCommand: dotfiles clone → mise install → mise run setup
  - mise install: CLI ツール（fd, rg, bat, fzf, zoxide...）
  - mise run setup: Claude Code, Zsh + Oh My Zsh + Powerlevel10k
↓
postStartCommand: ファイアウォール初期化
↓
環境変数: ~/.config/mise/config.local.toml で設定
```

### 環境変数の設定

```bash
# DevContainer 内で実行
cp ~/dotfiles/config/mise/config.local.toml.example ~/.config/mise/config.local.toml
nvim ~/.config/mise/config.local.toml  # API キーを設定
```

## mise run コマンド

```bash
# タスク一覧を表示
mise tasks

# 完全セットアップ（新規マシン用）
mise run setup

# dotfiles をデプロイ（シンボリックリンク作成）
mise run deploy

# Claude Code MCP サーバー設定
mise run setup-mcp

# 更新系
mise upgrade              # mise ツールを更新
mise run update-zsh-plugins  # Zsh プラグインを更新
mise run update-claude-code  # Claude Code を更新

# 個別インストール
mise run install-deps        # 基本パッケージ
mise run install-zsh         # Oh My Zsh + プラグイン
mise run install-claude-code # Claude Code
```

## 新しいファイルを追加

1. dotfiles リポジトリにファイルを追加
2. `config/mise/tasks/deploy` に ln コマンドを追記
3. デプロイ実行：`mise run deploy`

## インストールされるツール

`mise install && mise run setup` で以下がセットアップされます。

### mise 経由（config/mise/config.toml で管理）

| ツール | 用途 |
|--------|------|
| node (LTS) | JavaScript ランタイム |
| pnpm | Node.js パッケージマネージャ |
| python 3.12 | Python ランタイム |
| uv | Python パッケージマネージャ |
| rust (stable) | Rust ツールチェーン |
| bun | 高速 JavaScript ランタイム |
| lsd | モダンな ls |
| zoxide | スマートな cd |
| fzf | ファジーファインダー |
| bat | シンタックスハイライト付き cat |
| jq | JSON プロセッサ |
| fd | 高速な find |
| sd | 直感的な sed |
| ripgrep | 高速な grep |
| zellij | ターミナルマルチプレクサ |
| yazi | ターミナルファイルマネージャ |
| lazygit | Git TUI クライアント |
| lazydocker | Docker TUI クライアント |
| neovim | テキストエディタ |

### ネイティブインストール（自動更新付き）

| ツール | 用途 |
|--------|------|
| Claude Code | Claude Code CLI |

### Zsh プラグイン

- powerlevel10k（テーマ）
- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-bat
- zsh-aliases-lsd
- zsh_codex

## カスタマイズ

### マシン固有の設定

`~/.config/mise/config.local.toml` でマシン固有の API キーや環境変数を設定。`~/dotfiles/config/mise/config.local.toml.example` を参考に作成。このファイルは gitignore 対象。

### Powerlevel10k

```bash
p10k configure
```

## ディレクトリ構造

```
~/dotfiles/
├── .claude/           # Claude Code 設定
├── .codex/            # Codex CLI 設定
├── .devcontainer/     # DevPod/DevContainer 設定
│   ├── CLAUDE.md         # プロジェクトテンプレート
│   ├── Dockerfile        # mise + 基本ツール
│   ├── devcontainer.json # DevContainer 設定
│   └── init-firewall.sh  # ファイアウォール
├── config/
│   ├── gh/            # GitHub CLI
│   ├── git/           # Git
│   ├── mise/          # mise (config + tasks)
│   │   ├── config.toml           # ツール・環境変数・エイリアス
│   │   ├── config.local.toml.example  # 秘密情報のテンプレート
│   │   └── tasks/                # セットアップタスク
│   ├── nvim/          # Neovim
│   └── zellij/        # Zellij（config + layouts）
├── windows-terminal/  # Windows Terminal
├── .gitconfig
├── .p10k.zsh
├── .tmux.conf
└── .zshrc
```

## 開発環境の使い方

Zellij + yazi + lazygit + nvim + Claude Code を統合した開発環境。

### 起動

```bash
# プロジェクトディレクトリで起動
dev ~/project

# または
cd ~/project && zellij --layout dev_fixed_nvim_claude
```

### レイアウト

```
┌───────────┬───────────┬─────────────────┐
│   yazi    │           │                 │
├───────────┤   nvim    │   Claude Code   │
│  lazygit  ├───────────┤                 │
│           │ terminal  │                 │
└───────────┴───────────┴─────────────────┘
    30%         30%            40%
```

### Claude Code との差分連携

1. Claude Code ペインで `/config` を開く
2. `Diff tool` を `auto` に変更
3. Claude が変更を提案すると nvim に diff が表示される
4. 採用: `:w`、却下: `:q`

### フローティングペイン

```bash
tt   # ターミナルを開く
lzd  # lazydocker を開く
```

### nvim キーバインド（Claude 連携）

| キー | 説明 |
|------|------|
| `<leader>ad` | diff を採用 |
| `<leader>aD` | diff を却下 |
| `<leader>ab` | 現在のバッファを Claude に追加 |
| `<leader>as` | 選択範囲を Claude に追加（ビジュアルモード）|
