# 🍏 macOS Setup & Bootstrap

Script automatizado de configuração e restauração para um novo Mac, contendo preferências de sistema, pacotes Homebrew, dotfiles (Zsh, Git) e ferramentas de desenvolvimento/IA.

## 🚀 Como Executar em um Mac Novo

Abra o Terminal e execute o comando de linha única abaixo:

```bash
git clone https://github.com/paulovitin/mac-setup.git ~/.mac-setup && cd ~/.mac-setup && ./setup.sh
```

---

## 📦 O que este repositorio instala/configura:

### 1. 🍺 Softwares & Aplicativos (`Brewfile`)
- **21 Ferramentas CLI**: `git`, `gh`, `go`, `python@3.12`, `pyenv`, `nvm`, `ruby`, `openjdk@17`, `cocoapods`, `cloudflared`, `tmux`, `fzf`, `bat`, `zoxide`, `eza`, `fd`, `tree`, `yq`, `wget`, `ffmpeg`, `gnupg`.
- **15 Aplicativos GUI (Casks)**: Telegram, Slack, Zed, Rio, Android Studio, Docker, Flutter, GCloud CLI, Rectangle, Spotify, VLC, The Unarchiver, Mounty, ColorSlurp, GIPHY Capture.

### 2. ⚙️ Preferências de Sistema (`macos_defaults.sh`)
- **Dock**: Ícones em 40px, auto-hide, minimização direto no ícone do app, sem seção de recentes.
- **Finder**: Arquivos ocultos ativados, modo lista por padrão, barra de caminho e status ativadas, busca na pasta atual.
- **Teclado & Trackpad**: Repetição de tecla ultra-rápida (`KeyRepeat 1`, `InitialKeyRepeat 10`), menu de acentos ao segurar tecla desativado (modo dev), toque leve para clicar no trackpad.
- **Sistema**: Bloqueio de arquivos `.DS_Store` em redes/USBs, caixas de diálogo sempre expandidas.

### 3. 📄 Dotfiles & Shell (`zshrc`, `gitconfig`, `git-aliases.zsh`)
- **Zsh**: Startup com cache de compinit (~10ms), NVM lazy load, SDKs (Android, Java 17, Bun, PNPM, Flyctl, OpenCode, Antigravity).
- **Aliases**: `ls` via `eza`, `cat` via `bat`, atalhos de AI (`ccd`, `agyd`), atalhos de git (`g`, `gst`, `gp`, `gc`, `gco`, `ga`, `grhh`, etc.).
- **Git**: Credenciais e configurações pessoais do Git.

### 4. 🤖 Runtimes & CLIs de IA
- **CLIs Globais (NPM)**: `cline`, `command-code`, `@openai/codex`, `@anthropic-ai/claude-code`, `@pen.dev/cli`, `mcporter`, `pnpm`, `yarn`.
- **Pipx & UV Tools**: `agent-reach`, `bilibili-cli`, `platformio`, `antigravity-cli`, `notebooklm-mcp-cli`, `browser-harness`.
- **Runtimes**: Bun, Astral UV, OpenCode CLI.
