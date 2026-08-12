# ==============================================================================
# .zshrc - Configuração Completa do Zsh do Paulo (Otimizada e Portável)
# ==============================================================================

# Compinit com cache de 24h (Startup ultra-rápido ~10ms)
autoload -Uz compinit
if [[ -e ${ZDOTDIR:-$HOME}/.zcompdump && -z ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit -C
else
  compinit
fi

# Homebrew Shell Environment
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Local Binaries
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------------------
# 📦 Ambientes, Linguagens & SDKs
# ------------------------------------------------------------------------------

# NVM Configuration — Lazy-Load (economiza ~750ms por shell novo)
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  _nvm_bin=""
  if [ -r "$NVM_DIR/alias/default" ]; then
    _nvm_def=$(<"$NVM_DIR/alias/default")
    _nvm_best=-1
    for _nvm_p in "$NVM_DIR/versions/node/v${_nvm_def#v}"*(/N); do
      _nvm_parts=(${(s:.:)${${_nvm_p:t}#v}})
      _nvm_num=$(( ${_nvm_parts[1]:-0} * 1000000 + ${_nvm_parts[2]:-0} * 1000 + ${_nvm_parts[3]:-0} ))
      if (( _nvm_num > _nvm_best )); then _nvm_best=$_nvm_num; _nvm_bin=$_nvm_p; fi
    done
    unset _nvm_def _nvm_best _nvm_p _nvm_parts _nvm_num
  fi
  if [ -n "$_nvm_bin" ]; then
    export PATH="$_nvm_bin/bin:$PATH"
    nvm() {
      unset -f nvm
      \. "/opt/homebrew/opt/nvm/nvm.sh"
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
      nvm "$@"
    }
  else
    _nvm_load() {
      unset -f nvm node npm npx _nvm_load
      \. "/opt/homebrew/opt/nvm/nvm.sh"
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    }
    nvm()  { _nvm_load; nvm "$@"; }
    node() { _nvm_load; node "$@"; }
    npm()  { _nvm_load; npm "$@"; }
    npx()  { _nvm_load; npx "$@"; }
  fi
  unset _nvm_bin
fi

# Android SDK & NDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export NDK_HOME="$ANDROID_SDK_ROOT/ndk/26.1.10909125"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$PATH"

# Java OpenJDK 17
if [ -d "/opt/homebrew/opt/openjdk@17/bin" ]; then
  export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
fi

# Bun JavaScript Runtime
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# PNPM Package Manager
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Flyctl
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# OpenCode
export PATH="$HOME/.opencode/bin:$PATH"

# Antigravity CLI & IDE
export PATH="$HOME/.antigravity/antigravity/bin:$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# ------------------------------------------------------------------------------
# ⚡ Integrações CLI (FZF & Zoxide)
# ------------------------------------------------------------------------------

# fzf configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide (substituto inteligente do cd)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# Windmill completions
[ -f ~/.wmill-completions.zsh ] && source ~/.wmill-completions.zsh

# ------------------------------------------------------------------------------
# 🏷️ Git Aliases
# ------------------------------------------------------------------------------
[ -f ~/.git-aliases.zsh ] && source ~/.git-aliases.zsh

# ------------------------------------------------------------------------------
# ⚡ Aliases Personalizados
# ------------------------------------------------------------------------------

# Bat (substituto do cat com sintaxe colorida)
if command -v bat &> /dev/null; then
  alias cat="bat --style=plain --paging=never"
fi

# Eza (substituto moderno do ls)
if command -v eza &> /dev/null; then
  alias ls="eza --icons"
  alias ll="eza -l --icons --git"
  alias la="eza -la --icons --git"
  alias lt="eza --tree --icons"
  alias l="eza --icons -la"
fi

# Atalhos de AI e CLI
alias ccd="claude --dangerously-skip-permissions"
alias ccdc="ccd --continue"
alias ccdr="ccd --resume"
alias agyd="agy --dangerously-skip-permissions"

# ------------------------------------------------------------------------------
# 🛠️ Funções Personalizadas
# ------------------------------------------------------------------------------

# Bambu Studio - Slice PETG Elegoo visual (low filament)
slice-petg() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: slice-petg <input.3mf> <output.3mf>"
    return 1
  fi
  /Applications/BambuStudio.app/Contents/MacOS/BambuStudio \
    --load-settings "$HOME/bambu-profiles/petg_elegoo_visual_process.json" \
    --load-filaments "$HOME/bambu-profiles/petg_elegoo_filament.json" \
    --slice 0 \
    --export-3mf "$2" \
    "$1"
}
