# Dotfiles

My personal terminal setup using:

- Zsh
- Starship
- Zellij

## What's included

- `.zshrc` — shell configuration
- `zellij/config.kdl` — Zellij configuration
- `starship/starship.toml` — Starship prompt configuration
- `install.sh` — setup script

## Setup

### 1. Clone the repository

    git clone git@github.com:aleixalonso/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles

### 2. Run the install script

    chmod +x install.sh
    ./install.sh

### 3. Reload your shell

    source ~/.zshrc

## What the script does

- Creates required config directories
- Backs up existing config files if needed
- Creates symlinks to the files in this repo

## Symlinks created

- `~/.dotfiles/zsh/.zshrc` → `~/.zshrc`
- `~/.dotfiles/zellij/config.kdl` → `~/.config/zellij/config.kdl`
- `~/.dotfiles/starship/starship.toml` → `~/.config/starship.toml`

## Repository structure

    .dotfiles/
    ├── zsh/
    │   └── .zshrc
    ├── zellij/
    │   └── config.kdl
    ├── starship/
    │   └── starship.toml
    ├── install.sh
    └── README.md

## Notes

- Existing files are backed up with a `.backup` suffix
- You can edit files directly inside `~/.dotfiles`

## Optional dependencies

    brew install zellij starship zsh-autosuggestions zsh-syntax-highlighting nvm

## Update

    cd ~/.dotfiles
    git pull
    ./install.sh
    source ~/.zshrc

## Reset

    rm ~/.zshrc
    rm ~/.config/zellij/config.kdl
    rm ~/.config/starship.toml

    ./install.sh