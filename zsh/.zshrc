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

# In Zellij, ESC[9001z repaints the prompt after Cmd+K clears the pane.
# Normal Ctrl+L behavior remains unchanged.
if [[ -n "${ZELLIJ:-}" ]]; then
  redraw-prompt() {
    zle reset-prompt
  }
  zle -N redraw-prompt
  bindkey $'\e[9001z' redraw-prompt
fi

# =========================
# Word navigation (Option keys)
# =========================
autoload -U select-word-style
select-word-style bash
