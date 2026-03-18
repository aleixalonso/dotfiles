# Dotfiles

Personal macOS terminal configuration managed from a single dotfiles repository.

## Repository layout

The installer infers link targets from the repository structure instead of using a fixed list.

- Hidden files map to `$HOME`
- Non-hidden config files map to `$HOME/.config`
- Nested directories are preserved

Current repo contents:

- `zsh/.zshrc` -> `~/.zshrc`
- `git/.gitconfig` -> `~/.gitconfig`
- `git/.gitignore_global` -> `~/.gitignore_global`
- `starship/starship.toml` -> `~/.config/starship.toml`
- `zellij/config.kdl` -> `~/.config/zellij/config.kdl`
- `ghostty/config` -> `~/.config/ghostty/config`

## Install

```bash
git clone git@github.com:aleixalonso/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Then reload your shell:

```bash
source ~/.zshrc
```

## What `install.sh` does

- Installs Homebrew if it is missing
- Installs required dependencies only when the repo/configs imply they are needed
- Creates required directories automatically
- Creates symlinks for the config files found in the repo
- Replaces incorrect symlinks safely
- Backs up existing real files using a `.backup` suffix
- Can be run multiple times safely

## Dependency inference

The installer currently detects and installs these packages only when relevant:

- `zellij`
- `starship`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `nvm`
- `ghostty`
- `font-jetbrains-mono-nerd-font`

## Updating

```bash
cd ~/.dotfiles
git pull
./install.sh
```

## Notes

- Edit the files in this repo directly and rerun `./install.sh`
- Git uses `~/.gitignore_global` for personal global ignores; the repo's own `.gitignore` is only for this repository
- Existing backups are preserved; repeated runs create numbered backups when needed
- `install.sh` is tracked as executable, so `chmod +x install.sh` should not be needed after cloning
