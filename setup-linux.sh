#!/usr/bin/env bash

# Linux entrypoint for the shared setup. It deliberately does not run any
# macOS defaults, casks, or GUI setup from setup.sh.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_prerequisites() {
  if command -v curl >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
    return 0
  fi

  if command -v apt-get >/dev/null 2>&1; then
    if [ "$(id -u)" -eq 0 ]; then
      apt-get update
      apt-get install -y curl git zsh
    elif command -v sudo >/dev/null 2>&1; then
      sudo apt-get update
      sudo apt-get install -y curl git zsh
    else
      echo "curl/git ausentes e sudo não está disponível." >&2
      exit 1
    fi
  elif command -v dnf >/dev/null 2>&1; then
    if [ "$(id -u)" -eq 0 ]; then
      dnf install -y curl git zsh
    elif command -v sudo >/dev/null 2>&1; then
      sudo dnf install -y curl git zsh
    else
      echo "curl/git ausentes e sudo não está disponível." >&2
      exit 1
    fi
  elif command -v pacman >/dev/null 2>&1; then
    if [ "$(id -u)" -eq 0 ]; then
      pacman -Sy --noconfirm curl git zsh
    elif command -v sudo >/dev/null 2>&1; then
      sudo pacman -Sy --noconfirm curl git zsh
    else
      echo "curl/git ausentes e sudo não está disponível." >&2
      exit 1
    fi
  else
    echo "Não encontrei apt-get, dnf ou pacman para instalar pré-requisitos." >&2
    exit 1
  fi
}

install_node() {
  if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
    node_major="$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)"
    if [ "${node_major}" -ge 22 ]; then
      return 0
    fi
    echo "➜ Node encontrado, mas a versão é antiga; usando NVM para Node 22+."
  fi

  export NVM_DIR="${NVM_DIR:-${HOME}/.nvm}"
  if [ ! -s "${NVM_DIR}/nvm.sh" ]; then
    echo "➜ Instalando NVM para fornecer Node/npm ao Caveman..."
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  fi
  # shellcheck disable=SC1091
  . "${NVM_DIR}/nvm.sh"
  nvm install --lts
  nvm alias default 'lts/*'
  nvm use --lts
}

install_prerequisites
install_node
bash "${SCRIPT_DIR}/setup-ai-tools.sh"

echo "Linux setup concluído. Nenhum default de macOS ou aplicativo GUI foi aplicado."
