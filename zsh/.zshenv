typeset -U path PATH

if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local/bin || -d /usr/local/Homebrew ]]; then
  export HOMEBREW_PREFIX="/usr/local"
else
  export HOMEBREW_PREFIX=""
fi

path=(
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin}"
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/sbin}"
  "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/fnm/bin}"
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
  $path
)
