# dotfiles

dotter を使用した dotfiles 管理リポジトリ。

## 含まれる設定

| カテゴリ | ファイル | 説明 |
|----------|----------|------|
| Shell | `.zshrc`, `.p10k.zsh` | Zsh + Oh My Zsh + Powerlevel10k |
| Git | `.gitconfig`, `config/git/ignore` | Git グローバル設定 |
| Terminal | `.tmux.conf` | tmux 設定 |
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

# 2. インストールスクリプト実行
./install.sh

# 3. API キーを設定
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

# 4. Claude Code MCP サーバー設定
./scripts/setup-mcp.sh

# 5. シェル再起動
exec zsh
```

## dotter の使い方

### 基本コマンド

```bash
# 設定をデプロイ（シンボリックリンク作成）
dotter deploy

# 強制デプロイ（既存ファイルを上書き）
dotter deploy --force

# ドライラン（実行内容を確認）
dotter deploy --dry-run

# デプロイを取り消し
dotter undeploy

# 変更を監視して自動デプロイ
dotter watch
```

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
dotter deploy
```

## インストールされるツール

install.sh で以下がセットアップされます：

### mise 経由

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
│   └── mise/          # mise
├── scripts/           # セットアップスクリプト
├── windows-terminal/  # Windows Terminal
├── .gitconfig
├── .p10k.zsh
├── .tmux.conf
├── .zshrc
└── install.sh
```
