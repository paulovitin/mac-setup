# 🍏 macOS/Linux Setup & Bootstrap

Script automatizado de configuração e restauração para um novo Mac ou Linux home server, contendo preferências de sistema (macOS), pacotes, dotfiles (Zsh, Git) e ferramentas de desenvolvimento/IA.

## 🚀 Como Executar em um Mac Novo

Abra o Terminal e execute o comando de linha única abaixo:

```bash
git clone https://github.com/paulovitin/mac-setup.git ~/.mac-setup && cd ~/.mac-setup && ./setup.sh
```

No Linux, o mesmo comando seleciona automaticamente `setup-linux.sh` e ignora
defaults do macOS e aplicativos GUI.

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

### 5. 🪨 Otimização de contexto no Codex

- **RTK** é o padrão para saída de shell e é instalado via Homebrew no macOS ou
  pelo instalador oficial no Linux.
- **Caveman CLI 1.1.0** é instalado com seus binários locais, mas permanece
  opcional: não ativa a skill `/caveman`, hooks automáticos de `shrink` nem o
  proxy do Codex.
- O Codex recebe instruções globais em `${CODEX_HOME:-~/.codex}/AGENTS.md`.
  O instalador preserva o arquivo existente e atualiza apenas o bloco gerenciado
  por este repositório.

Configuração escolhida:

```text
Codex + RTK por padrão
Caveman seletivo para JSON, logs, HTML, TOON e memória
sem dupla compressão automática
```

Para instalar somente essa camada sem repetir o restante do setup:

```bash
bash setup-ai-tools.sh
```

Comandos opcionais do Caveman:

```bash
caveman tools shrink -- <comando>
caveman tools toon encode < arquivo.json
caveman stats
```
