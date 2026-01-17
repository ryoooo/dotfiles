# dotfiles

dotter + go-task を使用した dotfiles 管理リポジトリ。

## 含まれる設定

| カテゴリ | ファイル | 説明 |
|----------|----------|------|
| Shell | `.zshrc`, `.p10k.zsh` | Zsh + Oh My Zsh + Powerlevel10k |
| Git | `.gitconfig`, `config/git/ignore` | Git グローバル設定 |
| Terminal | `.tmux.conf` | tmux 設定 |
| Terminal | `config/zellij/*` | Zellij 設定 + レイアウト |
| Editor | `config/nvim/*` | Neovim (LazyVim) |
| Tools | `config/mise/config.toml` | mise ツールバージョン管理 |
| GitHub | `config/gh/config.yml` | GitHub CLI 設定 |
| Claude | `.claude/*` | Claude Code 設定 |
| Codex | `.codex/*` | OpenAI Codex CLI 設定 |
| Windows | `windows-terminal/settings.json` | Windows Terminal 設定 |

## 新規マシンセットアップ

```bash
# 1. リポジトリをクローン
git clone https://github.com/ryoooo/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. mise と task をインストール（ブートストラップ）
curl https://mise.run | sh
~/.local/bin/mise use --global task
eval "$(~/.local/bin/mise activate bash)"

# 3. 完全セットアップ実行
task install

# 4. API キーを設定
cat > ~/.config/mise/config.local.toml << 'EOF'
[env]
OPENROUTER_API_KEY = "your-key"
GITHUB_MCP_TOKEN = "your-token"
REF_API_KEY = "your-key"
CONTEXT7_API_KEY = "your-key"
BRAVE_API_KEY = "your-key"
N8N_API_URL = "your-url"
N8N_API_KEY = "your-key"
EOF

# 5. Claude Code MCP サーバー設定
task setup:mcp

# 6. シェル再起動
exec zsh
```

## task コマンド

```bash
# タスク一覧を表示
task --list

# 完全セットアップ（新規マシン用）
task install

# dotfiles をデプロイ（シンボリックリンク作成）
task deploy

# デプロイを取り消し
task undeploy

# Claude Code MCP サーバー設定
task setup:mcp

# 更新系
task update:tools        # mise ツールを更新
task update:zsh-plugins  # Zsh プラグインを更新
task update:claude-code  # Claude Code を更新

# 個別インストール
task install:deps        # 基本パッケージ
task install:mise        # mise
task install:tools       # mise 経由でツール
task install:zsh         # Oh My Zsh + プラグイン
task install:claude-code # Claude Code
task install:dotter      # dotter + デプロイ
```

## dotter の使い方

### 設定ファイル

```
.dotter/
├── global.toml   # 全マシン共通設定（Git管理）
├── local.toml    # マシン固有設定（Git管理外）
└── cache.toml    # キャッシュ（Git管理外）
```

### 新しいファイルを追加

1. dotfiles リポジトリにファイルを追加
2. `.dotter/global.toml` に追記：

```toml
[default.files]
"新しいファイル" = "~/.config/新しいファイル"
```

3. デプロイ実行：

```bash
task deploy
```

## インストールされるツール

`task install` で以下がセットアップされます。

### mise 経由

| ツール | 用途 |
|--------|------|
| node (LTS) | Node.js |
| pnpm | パッケージマネージャ |
| python 3.12 | Python |
| uv | Python パッケージマネージャ |
| rust (stable) | Rust |
| bun | JavaScript ランタイム |
| task | タスクランナー |
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

### pnpm 経由

| ツール | 用途 |
|--------|------|
| @anthropic-ai/claude-code | Claude Code CLI |

### Zsh プラグイン

- powerlevel10k（テーマ）
- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-bat
- zsh-aliases-lsd
- zsh_codex

## カスタマイズ

### マシン固有の設定

`.dotter/local.toml` で個別設定：

```toml
includes = []
packages = ["default"]

[files]
# マシン固有のファイルマッピング

[variables]
# テンプレート変数
```

### Powerlevel10k

```bash
p10k configure
```

## ディレクトリ構造

```
~/dotfiles/
├── .claude/           # Claude Code 設定
├── .codex/            # Codex CLI 設定
├── .dotter/           # dotter 設定
├── config/
│   ├── gh/            # GitHub CLI
│   ├── git/           # Git
│   ├── mise/          # mise
│   ├── nvim/          # Neovim
│   └── zellij/        # Zellij（config + layouts）
├── windows-terminal/  # Windows Terminal
├── .gitconfig
├── .p10k.zsh
├── .tmux.conf
├── .zshrc
└── Taskfile.yml       # タスク定義
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
