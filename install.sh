#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"

echo "🔧 Setting up dotfiles..."

# =========================
# Homebrew
# =========================
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# =========================
# Install packages
# =========================
echo "📦 Installing dependencies..."

brew install \
  zellij \
  starship \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  nvm

# =========================
# Create config dirs
# =========================
echo "📁 Creating directories..."
mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.config/zellij"
mkdir -p "${HOME}/.config/ghostty"

# =========================
# Symlink helper
# =========================
link_file() {
  local source_path="$1"
  local target_path="$2"

  if [ ! -e "$source_path" ]; then
    echo "⚠️  Skipping missing source: $source_path"
    return
  fi

  if [ -L "$target_path" ]; then
    echo "🔁 Replacing symlink: $target_path"
    rm "$target_path"
  elif [ -e "$target_path" ]; then
    echo "💾 Backing up: $target_path → ${target_path}.backup"
    mv "$target_path" "${target_path}.backup"
  fi

  echo "🔗 Linking $target_path → $source_path"
  ln -s "$source_path" "$target_path"
}

# =========================
# Create symlinks
# =========================
echo "🔗 Linking dotfiles..."

link_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
link_file "${DOTFILES_DIR}/zellij/config.kdl" "${HOME}/.config/zellij/config.kdl"
link_file "${DOTFILES_DIR}/starship/starship.toml" "${HOME}/.config/starship.toml"
link_file "${DOTFILES_DIR}/ghostty/config" "${HOME}/.config/ghostty/config"

# =========================
# Done
# =========================
echo
echo "✅ Done!"
echo "👉 Restart your terminal or run:"
echo "   source ~/.zshrc"