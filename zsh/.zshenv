typeset -U path PATH

if command -v brew >/dev/null 2>&1; then
  export HOMEBREW_PREFIX="$(brew --prefix)"
elif [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local ]]; then
  export HOMEBREW_PREFIX="/usr/local"
else
  export HOMEBREW_PREFIX=""
fi

for dir in \
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin}" \
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/libpq/bin}" \
  "$HOME/.codeium/windsurf/bin" \
  "$HOME/.local/bin" \
  "$HOME/.antigravity/antigravity/bin" \
  "$HOME/.opencode/bin"
do
  # Preserve the inherited PATH order in child shells so nvm-managed Node
  # binaries stay ahead of Homebrew when a shell starts inside zellij.
  [[ -d "$dir" ]] && path+=("$dir")
done
