#!/usr/bin/env bash

# ==============================================================================
# macos_defaults.sh - Configurações de Sistema do macOS
# Mapeado diretamente a partir das preferências do seu macOS atual
# ==============================================================================

echo "⚙️ Configurando preferências do macOS..."

# Fechar o aplicativo de Preferências para evitar sobreposição de escrita
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null
osascript -e 'tell application "System Settings" to quit' 2>/dev/null

# ------------------------------------------------------------------------------
# 📁 1. Finder & Mesa (Desktop)
# ------------------------------------------------------------------------------
echo "➜ Configurando Finder & Mesa..."

# Mostrar arquivos e pastas ocultos (.dotfiles, etc.)
defaults write com.apple.finder AppleShowAllFiles -bool true

# Mostrar barra de status e barra de caminho na janela do Finder
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Definir modo de exibição em Lista ("Nlsv") por padrão
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Mostrar todas as extensões de arquivo (.png, .txt, etc.)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Desabilitar o aviso ao alterar a extensão de um arquivo
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Pesquisar na pasta atual por padrão ao usar a busca do Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Manter pastas no topo ao ordenar por nome
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Exibir discos externos e mídias removíveis na Mesa, mas ocultar o HD principal
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# ------------------------------------------------------------------------------
# 🚀 2. Dock & Mission Control
# ------------------------------------------------------------------------------
echo "➜ Configurando Dock..."

# Ocultar a Dock automaticamente
defaults write com.apple.dock autohide -bool true

# Definir tamanho dos ícones na Dock para 40px
defaults write com.apple.dock tilesize -int 40

# Desativar efeito de magnificação ao passar o mouse
defaults write com.apple.dock magnification -bool false

# Minimizar janelas diretamente dentro do ícone do próprio aplicativo na Dock
defaults write com.apple.dock minimize-to-application -bool true

# Remover a seção de aplicativos recentes na Dock
defaults write com.apple.dock show-recents -bool false

# Efeito Genie ao minimizar janelas
defaults write com.apple.dock mineffect -string "genie"

# Não reorganizar Spaces automaticamente com base no uso recente
defaults write com.apple.dock mru-spaces -bool false

# ------------------------------------------------------------------------------
# ⌨️ 3. Teclado & Digitação
# ------------------------------------------------------------------------------
echo "➜ Configurando Teclado..."

# Taxa de repetição de tecla ultra-rápida (KeyRepeat: 1)
defaults write NSGlobalDomain KeyRepeat -int 1

# Atraso inicial curto antes de começar a repetir a tecla (InitialKeyRepeat: 10)
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Desabilitar o menu pop-up de acentos ao segurar uma tecla (permite repetição contínua no VS Code/Terminal)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# ------------------------------------------------------------------------------
# 🖱️ 4. Trackpad
# ------------------------------------------------------------------------------
echo "➜ Configurando Trackpad..."

# Habilitar "Toque para clicar" (Tap to click) para o Trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ------------------------------------------------------------------------------
# 🛠️ 5. Sistema, Janelas de Diálogo & Monitor de Atividades
# ------------------------------------------------------------------------------
echo "➜ Configurando Janelas, Sistema & Monitor de Atividades..."

# Expandir caixas de diálogo "Salvar Como" por padrão
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expandir caixas de diálogo de Impressão por padrão
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Desabilitar o aviso de "Crash Reporter" ao fechar um app inesperadamente
defaults write com.apple.CrashReporter DialogType -string "none"

# Mostrar todos os processos no Monitor de Atividades (categoria 100)
defaults write com.apple.ActivityMonitor ShowCategory -int 100

# Evitar a criação de arquivos .DS_Store em compartilhamentos de rede
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Evitar a criação de arquivos .DS_Store em volumes USB externos
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ------------------------------------------------------------------------------
# 🔄 Reiniciar processos afetados para aplicar as mudanças
# ------------------------------------------------------------------------------
echo "➜ Reiniciando Finder, Dock e Activity Monitor..."
for app in "Finder" "Dock" "Activity Monitor"; do
    killall "${app}" &>/dev/null || true
done

echo "✅ Configurações de preferências do macOS concluídas!"
