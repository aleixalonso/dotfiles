autoload -U add-zsh-hook
autoload -Uz compinit

ZSH_COMPDUMP="$HOME/.zcompdump-${ZSH_VERSION}"
if [[ -f "$ZSH_COMPDUMP" ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
fi

[[ -f "$HOME/.zsh_functions" ]] && source "$HOME/.zsh_functions"

if [[ -n "${HOMEBREW_PREFIX:-}" && -x "$HOMEBREW_PREFIX/opt/fnm/bin/fnm" ]]; then
  export FNM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fnm"
  eval "$("$HOMEBREW_PREFIX/opt/fnm/bin/fnm" env --use-on-cd --shell zsh)"
  fnm use --silent-if-unchanged >/dev/null 2>&1 || \
    fnm use default --silent-if-unchanged >/dev/null 2>&1 || true
  rehash
fi

# =========================
# Starship
# =========================
eval "$(starship init zsh)"

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# =========================
# History
# =========================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

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
