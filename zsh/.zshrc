autoload -U add-zsh-hook

[[ -f "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"

export NVM_DIR="$HOME/.nvm"
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# =========================
# Starship
# =========================
eval "$(starship init zsh)"

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

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

add-zsh-hook precmd set-terminal-title
add-zsh-hook chpwd set-terminal-title
