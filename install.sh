#!/bin/bash
# Dotfiles installation script
set -e

echo "=== Dotfiles Installation ==="
echo ""

# Check if running from dotfiles directory
if [[ ! -f ".dotter/global.toml" ]]; then
    echo "Error: Run this script from the dotfiles directory"
    echo "  cd ~/dotfiles && ./install.sh"
    exit 1
fi

# 0. Install build essentials (required for compiling)
echo "[0/7] Checking build essentials..."
if command -v apt &> /dev/null; then
    if ! dpkg -s build-essential &> /dev/null 2>&1; then
        echo "Installing build-essential..."
        sudo apt update && sudo apt install -y build-essential curl git zsh
    else
        echo "build-essential already installed"
    fi
elif command -v dnf &> /dev/null; then
    echo "Installing Development Tools..."
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y curl git zsh
fi

# 1. Install mise
echo ""
echo "[1/7] Checking mise..."
if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.run | sh
fi
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"

# 2. Install all tools via mise
echo ""
echo "[2/7] Installing tools via mise..."

# Languages & package managers
mise use --global node@lts
mise use --global pnpm
mise use --global python@3.12
mise use --global uv
mise use --global rust@stable
mise use --global bun

# CLI tools
mise use --global lsd
mise use --global zoxide
mise use --global fzf
mise use --global bat
mise use --global jq
mise use --global fd
mise use --global sd
mise use --global ripgrep

# Reload to get cargo in PATH
eval "$(mise activate bash)"

# 3. Install dotter (not available in mise)
echo ""
echo "[3/7] Checking dotter..."
if ! command -v dotter &> /dev/null; then
    echo "Installing dotter via cargo..."
    cargo install dotter
else
    echo "dotter already installed"
fi

# 4. Create local.toml if not exists
echo ""
echo "[4/7] Checking local.toml..."
if [[ ! -f ".dotter/local.toml" ]]; then
    cat > .dotter/local.toml << 'EOF'
includes = []
packages = ["default"]

[files]

[variables]
EOF
    echo "Created .dotter/local.toml"
else
    echo ".dotter/local.toml already exists"
fi

# 5. Deploy dotfiles
echo ""
echo "[5/7] Deploying dotfiles..."
dotter deploy --force

# 6. Install Oh My Zsh and plugins
echo ""
echo "[6/7] Setting up Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Powerlevel10k theme
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "Powerlevel10k already installed"
fi

# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed"
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting already installed"
fi

# zsh-bat
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-bat" ]]; then
    echo "Installing zsh-bat..."
    git clone https://github.com/fdellwing/zsh-bat.git "$ZSH_CUSTOM/plugins/zsh-bat"
else
    echo "zsh-bat already installed"
fi

# zsh-aliases-lsd
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-aliases-lsd" ]]; then
    echo "Installing zsh-aliases-lsd..."
    git clone https://github.com/yuhonas/zsh-aliases-lsd.git "$ZSH_CUSTOM/plugins/zsh-aliases-lsd"
else
    echo "zsh-aliases-lsd already installed"
fi

# zsh_codex
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh_codex" ]]; then
    echo "Installing zsh_codex..."
    git clone https://github.com/tom-doerr/zsh_codex.git "$ZSH_CUSTOM/plugins/zsh_codex"
else
    echo "zsh_codex already installed"
fi

# 7. Change default shell
echo ""
echo "[7/7] Checking default shell..."
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
else
    echo "zsh is already the default shell"
fi

# Post-install setup
echo ""
echo "=== Next Steps ==="
echo ""
echo "1. Create ~/.config/mise/config.local.toml with your API keys:"
cat << 'EOF'
   [env]
   OPENROUTER_API_KEY = "your-key"
   GITHUB_MCP_TOKEN = "your-token"
   REF_API_KEY = "your-key"
   CONTEXT7_API_KEY = "your-key"
   BRAVE_API_KEY = "your-key"
   N8N_API_URL = "your-url"
   N8N_API_KEY = "your-key"
EOF
echo ""
echo "2. Setup Claude Code MCP servers:"
echo "   ./scripts/setup-mcp.sh"
echo ""
echo "3. Reload shell:"
echo "   exec zsh"
echo ""
echo "=== Installation Complete ==="
