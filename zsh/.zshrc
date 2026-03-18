# =========================
# Clean PATH (no duplicates)
# =========================
typeset -U path PATH

# =========================
# Homebrew prefix
# =========================
if command -v brew >/dev/null 2>&1; then
  HOMEBREW_PREFIX="$(brew --prefix)"
elif [[ -d /opt/homebrew ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local ]]; then
  HOMEBREW_PREFIX="/usr/local"
else
  HOMEBREW_PREFIX=""
fi

# =========================
# NVM (Node Version Manager)
# =========================
export NVM_DIR="$HOME/.nvm"
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi


# =========================
# Automatic Node version switcher (place after nvm initialization)
# =========================
autoload -U add-zsh-hook
load-nvmrc() {
  local nvm_default_version

  command -v nvm >/dev/null 2>&1 || return
  nvm_default_version="$(nvm version default)"

  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  elif [[ "$nvm_default_version" != "N/A" && "$(nvm version)" != "$nvm_default_version" ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


# =========================
# Homebrew (AFTER nvm)
# =========================
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  export PATH="$PATH:$HOMEBREW_PREFIX/bin"
fi

# =========================
# Extra PATHs
# =========================
for dir in \
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/libpq/bin}" \
  "$HOME/.codeium/windsurf/bin" \
  "$HOME/.local/bin" \
  "$HOME/.antigravity/antigravity/bin" \
  "$HOME/.opencode/bin"
do
  [[ -d "$dir" ]] && path+=("$dir")
done

# =========================
# Conda
# =========================
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$PATH:/opt/anaconda3/bin"
    fi
fi
unset __conda_setup

# =========================
# Starship
# =========================
eval "$(starship init zsh)"

# =========================
# Plugins
# =========================
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# =========================
# History search
# =========================
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# =========================
# Word navigation (Option keys)
# =========================
autoload -U select-word-style
select-word-style bash

# =========================
# Editor
# =========================
export EDITOR="cursor -w"

# =========================
# Terminal title
# =========================
set-terminal-title() {
  print -Pn "\e]0;$(basename "$PWD")\a"
}
add-zsh-hook precmd set-terminal-title
add-zsh-hook chpwd set-terminal-title
