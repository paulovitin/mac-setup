#!/usr/bin/env bash

# ==============================================================================
# setup.sh - Script Mestre de Configuração para um Novo macOS
# ==============================================================================
# Este script automatiza:
# 1. Instalação do Xcode Command Line Tools
# 2. Instalação e execução do Homebrew (Brewfile com 21 CLI + 13 Casks)
# 3. Instalação do Node.js LTS via NVM
# 4. Instalação do Oh My Zsh e restauração dos seus Dotfiles (.zshrc, .gitconfig, .git-aliases.zsh)
# 5. Instalação via CURL de Ferramentas e IAs (Claude Code, Codex, Bun, UV, OpenCode, Qoder, Cline, CMD)
# 6. Aplicação das Preferências de Sistema do macOS (Finder, Dock, Teclado, Trackpad)
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$(uname -s)" == "Linux" ]]; then
  exec bash "${SCRIPT_DIR}/setup-linux.sh" "$@"
fi

# Cores para o output do terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}    🚀 Iniciando Setup Automático do macOS          ${NC}"
echo -e "${BLUE}=====================================================${NC}"

# Pedir senha de administrador no início e manter a sessão ativa
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

DIR="$SCRIPT_DIR"
cd "$DIR"

# ------------------------------------------------------------------------------
# 🛠️ 1. Xcode Command Line Tools
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[1/6] Verificando Xcode Command Line Tools...${NC}"
if ! xcode-select -p &>/dev/null; then
  echo "➜ Instalando Xcode Command Line Tools..."
  xcode-select --install
  echo "Por favor, conclua a instalação da janela do Xcode antes de continuar."
  read -p "Pressione [ENTER] quando a instalação do Xcode terminar..."
else
  echo -e "${GREEN}✓ Xcode Command Line Tools já está instalado!${NC}"
fi

# ------------------------------------------------------------------------------
# 🍺 2. Homebrew & Brewfile
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[2/6] Verificando Homebrew...${NC}"
if ! command -v brew &>/dev/null; then
  echo "➜ Instalando Homebrew via CURL..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo -e "${GREEN}✓ Homebrew já está instalado!${NC}"
fi

echo "➜ Atualizando Homebrew e instalando pacotes do Brewfile..."
brew update
brew bundle --file="./Brewfile"
echo -e "${GREEN}✓ Todos os aplicativos e ferramentas CLI do Homebrew foram instalados!${NC}"

# ------------------------------------------------------------------------------
# 🟢 3. Node.js & NVM
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[3/6] Configurando Node.js e NVM...${NC}"
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  source "/opt/homebrew/opt/nvm/nvm.sh"
elif [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
  source "/usr/local/opt/nvm/nvm.sh"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi

if command -v nvm &>/dev/null; then
  echo "➜ Instalando Node.js LTS via NVM..."
  nvm install --lts || true
  nvm use --lts || true
elif ! command -v npm &>/dev/null; then
  echo "➜ Instalando Node.js..."
  brew install node || true
fi

# ------------------------------------------------------------------------------
# 🐚 4. Oh My Zsh & Dotfiles
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[4/6] Instalando Oh My Zsh via CURL e restaurando Dotfiles...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
fi

if [ -f "./zshrc" ]; then
  echo "➜ Aplicando ~/.zshrc..."
  cp ./zshrc ~/.zshrc
fi

if [ -f "./git-aliases.zsh" ]; then
  echo "➜ Aplicando ~/.git-aliases.zsh..."
  cp ./git-aliases.zsh ~/.git-aliases.zsh
fi

if [ -f "./gitconfig" ]; then
  echo "➜ Aplicando ~/.gitconfig..."
  cp ./gitconfig ~/.gitconfig
fi
echo -e "${GREEN}✓ Dotfiles aplicados!${NC}"

# ------------------------------------------------------------------------------
# 🤖 5. Instalação via CURL de Ferramentas & CLIs de IA
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[5/6] Instalando Ferramentas e CLIs de IA via CURL...${NC}"

# 1. Claude Code CLI via CURL / Installer oficial
echo "➜ Instalando Claude Code via script de instalação..."
curl -fsSL https://claude.ai/install.sh | bash 2>/dev/null || npm install -g @anthropic-ai/claude-code 2>/dev/null || true

# 2. Codex CLI via CURL / NPM fallback
echo "➜ Instalando Codex CLI..."
curl -fsSL https://codex.openai.com/install.sh | bash 2>/dev/null || npm install -g @openai/codex 2>/dev/null || true

# 3. Bun JavaScript Runtime via CURL
echo "➜ Instalando Bun via CURL..."
curl -fsSL https://bun.sh/install | bash 2>/dev/null || true

# 4. Astral UV Python Manager via CURL
echo "➜ Instalando Astral UV via CURL..."
curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null || true

# 5. OpenCode CLI via CURL
echo "➜ Instalando OpenCode CLI via CURL..."
curl -fsSL https://opencode.ai/install.sh | bash 2>/dev/null || true

# 6. Qoder CLI via CURL
echo "➜ Instalando Qoder CLI via CURL..."
curl -fsSL https://qoder.ai/install.sh | bash 2>/dev/null || true

# 7. Demais Pacotes NPM Globais (Cline, Command-Code, Pen, MCPorter, PNPM, Yarn)
if command -v npm &>/dev/null; then
  echo "➜ Instalando Cline, Command-Code, PNPM, Yarn, Pen CLI & MCPorter..."
  npm install -g cline command-code pnpm yarn @pen.dev/cli mcporter 2>/dev/null || true
fi

# 8. Ferramentas Pipx & UV
if command -v pipx &>/dev/null; then
  pipx install agent-reach 2>/dev/null || true
  pipx install bilibili-cli 2>/dev/null || true
  pipx install platformio 2>/dev/null || true
  pipx install antigravity-cli 2>/dev/null || true
fi

if command -v uv &>/dev/null; then
  uv tool install notebooklm-mcp-cli 2>/dev/null || true
  uv tool install browser-harness 2>/dev/null || true
fi

# 9. RTK default + Caveman optional context tools + Codex global guidance
bash "${DIR}/setup-ai-tools.sh"

echo -e "${GREEN}✓ Todas as ferramentas e CLIs de IA foram instaladas via CURL/Scripts!${NC}"

# ------------------------------------------------------------------------------
# ⚙️ 6. Preferências de Sistema do macOS (defaults write)
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[6/6] Aplicando preferências de sistema do macOS...${NC}"
if [ -f "./macos_defaults.sh" ]; then
  chmod +x ./macos_defaults.sh
  ./macos_defaults.sh
fi

echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}  🎉 Setup do macOS concluído com sucesso!           ${NC}"
echo -e "${GREEN}  Recomenda-se reiniciar o Mac para aplicar tudo.    ${NC}"
echo -e "${GREEN}=====================================================${NC}"
