#!/usr/bin/env bash

# Shared AI CLI setup for macOS and Linux.
# RTK is enabled through global Codex guidance. Caveman is installed but its
# response skill, proxy, and automatic shrink hooks are intentionally left off.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="${HOME}/.local/bin:${PATH}"
RTK_INSTALL_URL="https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh"
CAVEMAN_VERSION="1.1.0"
START_MARKER="<!-- mac-setup:rtk-caveman:start -->"
END_MARKER="<!-- mac-setup:rtk-caveman:end -->"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}!${NC} $*"; }

install_rtk() {
  if command -v rtk >/dev/null 2>&1; then
    info "RTK já está instalado: $(rtk --version 2>/dev/null || echo versão desconhecida)"
    return 0
  fi

  if command -v brew >/dev/null 2>&1; then
    echo "➜ Instalando RTK via Homebrew..."
    brew install rtk || brew upgrade rtk || true
  elif command -v curl >/dev/null 2>&1; then
    echo "➜ Instalando RTK pelo instalador oficial..."
    curl -fsSL "$RTK_INSTALL_URL" | sh || true
  else
    warn "RTK não instalado: curl ou Homebrew não encontrado."
  fi

  if command -v rtk >/dev/null 2>&1; then
    info "RTK pronto: $(rtk --version 2>/dev/null || echo versão desconhecida)"
  else
    warn "RTK ainda não está no PATH; abra um novo shell e verifique ~/.local/bin."
  fi
}

install_caveman() {
  if ! command -v npm >/dev/null 2>&1; then
    warn "Caveman não instalado: npm não encontrado."
    return 0
  fi

  echo "➜ Instalando Caveman CLI ${CAVEMAN_VERSION}..."
  npm install --global "@caveman-ai/cli@${CAVEMAN_VERSION}" || {
    warn "Falha ao instalar o CLI do Caveman; continuando com RTK."
    return 0
  }

  if command -v caveman >/dev/null 2>&1; then
    echo "➜ Instalando os binários locais do Caveman..."
    DO_NOT_TRACK=1 caveman setup --install || warn "Binários do Caveman não foram instalados."
    info "Caveman instalado, mas proxy, skill e hooks automáticos permanecem desativados."
  else
    warn "Caveman foi instalado pelo npm, mas não está no PATH deste shell."
  fi
}

install_codex_guidance() {
  local codex_home_dir="${CODEX_HOME:-${HOME}/.codex}"
  local target="${codex_home_dir}/AGENTS.md"
  local temp_file

  mkdir -p "$codex_home_dir"
  temp_file="$(mktemp "${target}.tmp.XXXXXX")"

  if [ -f "$target" ]; then
    awk -v start="$START_MARKER" -v end="$END_MARKER" '
      $0 == start { skipping = 1; next }
      $0 == end { skipping = 0; next }
      !skipping { print }
    ' "$target" > "$temp_file"
  fi

  if [ -s "$temp_file" ]; then
    printf '\n' >> "$temp_file"
  fi
  cat "$SCRIPT_DIR/codex-agents.md" >> "$temp_file"
  mv "$temp_file" "$target"
  info "Instruções globais do Codex atualizadas em ${target}"
}

install_rtk
install_caveman
install_codex_guidance

echo ""
echo "RTK é o padrão para shell. Caveman está disponível para uso seletivo:"
echo "  caveman tools shrink -- <comando>"
echo "  caveman tools toon encode < arquivo.json"
echo "  caveman stats"
echo ""
echo "Não foram instalados automaticamente: skill /caveman, hooks de shrink ou proxy do Codex."
