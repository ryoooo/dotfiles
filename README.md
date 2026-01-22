# dotfiles

mise を使用した dotfiles 管理リポジトリ。

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
eval "$(~/.local/bin/mise activate bash)"

# 3. 完全セットアップ実行
mise run install

# 4. API キーを設定（config.local.toml.example を参考に）
cp ~/.config/mise/config.local.toml.example ~/.config/mise/config.local.toml
# エディタで編集して実際の値を設定

# 5. Claude Code MCP サーバー設定
mise run setup-mcp

# 6. シェル再起動
exec zsh
```

## DevContainer（DevPod）

[DevPod](https://devpod.sh/) を使って、どこでも同じ開発環境を構築できます。クライアントのみで動作し、ベンダーロックインなし。

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
postCreateCommand: dotfiles clone → mise run install
  - CLI ツール（fd, rg, bat, uv, bun...）
  - Claude Code（ネイティブインストール）
  - Zsh + Oh My Zsh + Powerlevel10k
↓
postStartCommand: ファイアウォール初期化
↓
環境変数: ~/.config/mise/config.local.toml で設定
```

### 環境変数の設定

```bash
# DevContainer 内で実行
cp ~/.config/mise/config.local.toml.example ~/.config/mise/config.local.toml
nvim ~/.config/mise/config.local.toml  # APIキーを設定
```

## mise run コマンド

```bash
# タスク一覧を表示
mise tasks

# 完全セットアップ（新規マシン用）
mise run install

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

`mise run install` で以下がセットアップされます。

### mise 経由（config/mise/config.toml で管理）

| ツール | 用途 |
|--------|------|
| node (LTS) | Node.js |
| pnpm | パッケージマネージャ |
| python 3.12 | Python |
| uv | Python パッケージマネージャ |
| rust (stable) | Rust |
| bun | JavaScript ランタイム |
| lsd | ls の代替 |
| zoxide | cd の代替 |
| fzf | ファジーファインダー |
| bat | cat の代替 |
| jq | JSON 処理 |
| fd | find の代替 |
| sd | sed の代替 |
| ripgrep | grep の代替 |
| zellij | ターミナルマルチプレクサ |
| yazi | ファイルマネージャ |
| lazygit | Git TUI |
| lazydocker | Docker TUI |
| neovim | エディタ |

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

`~/.config/mise/config.local.toml` で個別設定（gitignore済み）。`config.local.toml.example` を参考に作成。

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
