#!/usr/bin/env bash

# ==============================================================================
# setup.sh - Script Mestre de Configuração para um Novo macOS
# ==============================================================================
# Este script automatiza:
# 1. Instalação do Xcode Command Line Tools
# 2. Instalação e execução do Homebrew (Brewfile com 21 CLI + 13 Casks + 2 MAS Apps)
# 3. Instalação do Oh My Zsh e restauração dos seus Dotfiles (.zshrc, .gitconfig, .git-aliases.zsh)
# 4. Aplicação das Preferências de Sistema do macOS (Finder, Dock, Teclado, Trackpad)
# 5. Instalação de Runtimes e IAs (Bun, UV, PNPM, Pipx, Claude Code, Codex, Cline, Command-Code, etc.)
# ==============================================================================

set -e

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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
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
  echo "➜ Instalando Homebrew..."
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
echo -e "${YELLOW}Dica: Para os apps da App Store (ColorSlurp, GIPHY Capture), certifique-se de estar logado na App Store com seu Apple ID.${NC}"
brew update
brew bundle --file="./Brewfile" || true
echo -e "${GREEN}✓ Pacotes e aplicativos do Brewfile processados!${NC}"

# ------------------------------------------------------------------------------
# 🐚 3. Oh My Zsh
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[3/6] Verificando Oh My Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "➜ Instalando Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo -e "${GREEN}✓ Oh My Zsh já está instalado!${NC}"
fi

# ------------------------------------------------------------------------------
# 📄 4. Restaurando Dotfiles (.zshrc, .gitconfig, .git-aliases.zsh)
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[4/6] Aplicando arquivos de configuração (Dotfiles)...${NC}"

if [ -f "./zshrc" ]; then
  echo "➜ Atualizando ~/.zshrc..."
  cp ./zshrc ~/.zshrc
fi

if [ -f "./git-aliases.zsh" ]; then
  echo "➜ Atualizando ~/.git-aliases.zsh..."
  cp ./git-aliases.zsh ~/.git-aliases.zsh
fi

if [ -f "./gitconfig" ]; then
  echo "➜ Atualizando ~/.gitconfig..."
  cp ./gitconfig ~/.gitconfig
fi
echo -e "${GREEN}✓ Dotfiles aplicados com sucesso!${NC}"

# ------------------------------------------------------------------------------
# 🤖 5. Runtimes, Pacotes NPM, Pipx & Ferramentas de IA
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[5/6] Instalando Runtimes, Pacotes NPM, Pipx & CLIs de IA...${NC}"

# Bun JavaScript Runtime
if ! command -v bun &>/dev/null; then
  echo "➜ Instalando Bun..."
  curl -fsSL https://bun.sh/install | bash || true
fi

# Astral UV (Python manager)
if ! command -v uv &>/dev/null; then
  echo "➜ Instalando Astral UV..."
  curl -LsSf https://astral.sh/uv/install.sh | sh || true
fi

# Pacotes Globais NPM selecionados (Claude, Codex, Cline, Command-Code, Pen CLI, MCPorter, PNPM, Yarn)
if command -v npm &>/dev/null; then
  echo "➜ Instalando pacotes NPM globais..."
  npm install -g \
    pnpm \
    yarn \
    cline \
    command-code \
    @openai/codex \
    @anthropic-ai/claude-code \
    @pen.dev/cli \
    mcporter || true
fi

# Ferramentas Python via Pipx selecionadas (Agent Reach, Bilibili, PlatformIO, Antigravity)
if command -v pipx &>/dev/null; then
  echo "➜ Instalando ferramentas Python via Pipx..."
  pipx install agent-reach 2>/dev/null || true
  pipx install bilibili-cli 2>/dev/null || true
  pipx install platformio 2>/dev/null || true
  pipx install antigravity-cli 2>/dev/null || true
fi

# Ferramentas via UV
if command -v uv &>/dev/null; then
  echo "➜ Instalando ferramentas via UV..."
  uv tool install notebooklm-mcp-cli 2>/dev/null || true
  uv tool install browser-harness 2>/dev/null || true
fi

# OpenCode CLI
if ! command -v opencode &>/dev/null; then
  echo "➜ Instalando OpenCode CLI..."
  curl -fsSL https://opencode.ai/install.sh | bash 2>/dev/null || true
fi

echo -e "${GREEN}✓ Runtimes e ferramentas de IA instalados!${NC}"

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
