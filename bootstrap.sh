#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Bootstrapping dotfiles from: $DOTFILES_DIR"

"$DOTFILES_DIR/install.sh"

if [[ "${1:-}" == "--macos" ]]; then
  "$DOTFILES_DIR/macos.sh"
fi

echo "Bootstrap complete."
echo "Reload your shell with: source ~/.zshrc"
