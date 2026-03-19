# Dotfiles

Personal macOS terminal configuration managed from a single dotfiles repository.

## Repository layout

The installer infers link targets from the repository structure instead of using a fixed list.

- Hidden files map to `$HOME`
- Non-hidden config files map to `$HOME/.config`
- Nested directories are preserved

Current repo contents:

- `Brewfile` -> Homebrew package manifest used during install
- `Library/Application Support/Cursor/User/settings.json` -> `~/Library/Application Support/Cursor/User/settings.json`
- `Library/Application Support/Cursor/User/keybindings.json` -> `~/Library/Application Support/Cursor/User/keybindings.json`
- `bootstrap.sh` -> runs the full dotfiles setup
- `macos.sh` -> applies personal macOS defaults
- `zsh/.zshenv` -> `~/.zshenv`
- `zsh/.zprofile` -> `~/.zprofile`
- `zsh/.zshrc` -> `~/.zshrc`
- `zsh/.zsh_functions` -> `~/.zsh_functions`
- `bin/repofmt` -> `~/.local/bin/repofmt`
- `git/.gitconfig` -> `~/.gitconfig`
- `git/.gitignore_global` -> `~/.gitignore_global`
- `starship/starship.toml` -> `~/.config/starship.toml`
- `zellij/config.kdl` -> `~/.config/zellij/config.kdl`
- `ghostty/config` -> `~/.config/ghostty/config`

## Install

```bash
git clone git@github.com:aleixalonso/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

Then reload your shell:

```bash
source ~/.zshrc
```

## What `install.sh` does

- Installs Homebrew if it is missing
- Installs Homebrew packages declared in `Brewfile`
- Creates required directories automatically
- Creates symlinks for the config files found in the repo
- Installs executables from `bin/` into `~/.local/bin`
- Replaces incorrect symlinks safely
- Backs up existing real files using a `.backup` suffix
- Can be run multiple times safely

## Bootstrap

Run the full setup with:

```bash
./bootstrap.sh
```

To also apply macOS defaults during bootstrap:

```bash
./bootstrap.sh --macos
```

## Homebrew packages

The current `Brewfile` includes the packages already used by this repo:

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
./bootstrap.sh
```

## macOS defaults

Apply the tracked macOS preferences with:

```bash
./macos.sh
```

## Notes

- Edit the files in this repo directly and rerun `./install.sh`
- `bootstrap.sh` is the main entrypoint; it runs `install.sh` and can optionally run `macos.sh`
- Zsh is split by responsibility: `.zshenv` for environment, `.zprofile` for login shell setup, `.zshrc` for interactive shell behavior
- Git uses `~/.gitignore_global` for personal global ignores; the repo's own `.gitignore` is only for this repository
- You can run `repofmt` manually inside any git repo to detect Biome, Prettier, and ESLint from the repo and format changed files before staging
- `repofmt path/to/file.ts` also works if you want to target specific files instead of the repo's current modified and untracked files
- Existing backups are preserved; repeated runs create numbered backups when needed
- `install.sh` is tracked as executable, so `chmod +x install.sh` should not be needed after cloning
