#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS defaults..."

# Use Column View in Finder windows by default.
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show the Finder status bar.
defaults write com.apple.finder ShowStatusBar -bool true

# Remove recent applications from the Dock.
defaults write com.apple.dock show-recents -bool false

# Restart Finder and Dock so the new settings take effect immediately.
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true

echo "macOS defaults applied."
