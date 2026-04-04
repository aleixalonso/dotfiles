#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS defaults..."

# Use Column View in Finder windows by default.
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show the Finder status bar.
defaults write com.apple.finder ShowStatusBar -bool true

# Set the Dock icon size.
defaults write com.apple.dock tilesize -int 30

# Remove recent applications from the Dock.
defaults write com.apple.dock show-recents -bool false

# Enable tap to click on the trackpad.
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Set bottom-left hot corner to Quick Note.
defaults write com.apple.dock wvous-bl-corner -int 14
defaults write com.apple.dock wvous-bl-modifier -int 0

# Restart Finder and Dock so the new settings take effect immediately.
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true

echo "macOS defaults applied."
