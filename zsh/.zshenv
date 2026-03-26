typeset -U path PATH

if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local/bin || -d /usr/local/Homebrew ]]; then
  export HOMEBREW_PREFIX="/usr/local"
else
  export HOMEBREW_PREFIX=""
fi

for dir in \
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin}" \
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/sbin}" \
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/libpq/bin}" \
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/fnm/bin}" \
  "$HOME/.codeium/windsurf/bin" \
  "$HOME/.local/bin" \
  "$HOME/.antigravity/antigravity/bin" \
  "$HOME/.opencode/bin"
do
  # Preserve the inherited PATH order in child shells so the parent shell's
  # toolchain stays ahead of Homebrew when a shell starts inside zellij.
  [[ -d "$dir" ]] && path+=("$dir")
done
