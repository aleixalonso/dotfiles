#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"
BREW_BIN=""

if [[ -t 1 ]]; then
  RED=$'\033[0;31m'
  GREEN=$'\033[0;32m'
  YELLOW=$'\033[1;33m'
  BLUE=$'\033[0;34m'
  BOLD=$'\033[1m'
  RESET=$'\033[0m'
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  RESET=""
fi

log() {
  printf '%b\n' "${BLUE}==>${RESET} $*"
}

success() {
  printf '%b\n' "${GREEN}==>${RESET} $*"
}

warn() {
  printf '%b\n' "${YELLOW}==>${RESET} $*"
}

error() {
  printf '%b\n' "${RED}==>${RESET} $*" >&2
}

ensure_dir() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    log "Directory exists: $dir"
    return
  fi

  mkdir -p "$dir"
  success "Created directory: $dir"
}

backup_path_for() {
  local target="$1"
  local backup="${target}.backup"
  local index=1

  while [[ -e "$backup" || -L "$backup" ]]; do
    backup="${target}.backup.${index}"
    index=$((index + 1))
  done

  printf '%s\n' "$backup"
}

link_file() {
  local source="$1"
  local target="$2"
  local target_dir
  local current_target
  local backup

  if [[ ! -e "$source" ]]; then
    warn "Skipping missing source: $source"
    return
  fi

  target_dir="$(dirname "$target")"
  ensure_dir "$target_dir"

  if [[ -L "$target" ]]; then
    current_target="$(readlink "$target")"

    if [[ "$current_target" == "$source" ]]; then
      log "Link already correct: $target"
      return
    fi

    rm -f "$target"
    success "Replaced symlink: $target"
  elif [[ -e "$target" ]]; then
    backup="$(backup_path_for "$target")"
    mv "$target" "$backup"
    success "Backed up existing file: $target -> $backup"
  fi

  ln -s "$source" "$target"
  success "Linked: $target -> $source"
}

setup_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    BREW_BIN="$(command -v brew)"
    return
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_BIN="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    BREW_BIN="/usr/local/bin/brew"
  else
    log "Homebrew not found. Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ -x /opt/homebrew/bin/brew ]]; then
      BREW_BIN="/opt/homebrew/bin/brew"
    elif [[ -x /usr/local/bin/brew ]]; then
      BREW_BIN="/usr/local/bin/brew"
    else
      error "Homebrew installation completed but brew was not found in a standard location."
      exit 1
    fi
  fi

  eval "$("$BREW_BIN" shellenv)"
}

install_formula_if_missing() {
  local formula="$1"

  if "$BREW_BIN" list --formula "$formula" >/dev/null 2>&1; then
    log "Formula already installed: $formula"
    return
  fi

  log "Installing formula: $formula"
  "$BREW_BIN" install "$formula"
  success "Installed formula: $formula"
}

install_cask_if_missing() {
  local cask="$1"

  if "$BREW_BIN" list --cask "$cask" >/dev/null 2>&1; then
    log "Cask already installed: $cask"
    return
  fi

  log "Installing cask: $cask"
  "$BREW_BIN" install --cask "$cask"
  success "Installed cask: $cask"
}

should_skip_top_level() {
  local name="$1"

  case "$name" in
    .git|.github)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

infer_target_path() {
  local source="$1"
  local rel_path="${source#"$DOTFILES_DIR"/}"
  local top_level="${rel_path%%/*}"
  local rest="${rel_path#*/}"
  local base_name
  local stem

  base_name="$(basename "$source")"
  stem="${base_name%.*}"

  if [[ "$base_name" == .* ]]; then
    printf '%s\n' "${HOME}/${base_name}"
    return
  fi

  if [[ "$rest" == "$base_name" && "$stem" == "$top_level" ]]; then
    printf '%s\n' "${CONFIG_DIR}/${base_name}"
    return
  fi

  printf '%s\n' "${CONFIG_DIR}/${rel_path}"
}

discover_sources() {
  local path
  local top_level

  while IFS= read -r path; do
    top_level="${path#"$DOTFILES_DIR"/}"
    top_level="${top_level%%/*}"

    if should_skip_top_level "$top_level"; then
      continue
    fi

    printf '%s\n' "$path"
  done < <(find "$DOTFILES_DIR" -mindepth 2 -type f | sort)
}

install_inferred_dependencies() {
  local zshrc_path="${DOTFILES_DIR}/zsh/.zshrc"
  local starship_path="${DOTFILES_DIR}/starship/starship.toml"

  if [[ -d "${DOTFILES_DIR}/zellij" ]]; then
    install_formula_if_missing "zellij"
  fi

  if [[ -f "$starship_path" ]]; then
    install_formula_if_missing "starship"

    if grep -q '[^[:ascii:]]' "$starship_path"; then
      install_cask_if_missing "font-jetbrains-mono-nerd-font"
    fi
  fi

  if [[ -d "${DOTFILES_DIR}/ghostty" ]]; then
    install_cask_if_missing "ghostty"
  fi

  if [[ -f "$zshrc_path" ]]; then
    if grep -q 'zsh-autosuggestions' "$zshrc_path"; then
      install_formula_if_missing "zsh-autosuggestions"
    fi

    if grep -q 'zsh-syntax-highlighting' "$zshrc_path"; then
      install_formula_if_missing "zsh-syntax-highlighting"
    fi

    if grep -q '\bnvm\b' "$zshrc_path"; then
      install_formula_if_missing "nvm"
      ensure_dir "${HOME}/.nvm"
    fi
  fi
}

main() {
  local source
  local target

  log "Using dotfiles repository: $DOTFILES_DIR"

  setup_homebrew
  ensure_dir "$CONFIG_DIR"
  install_inferred_dependencies

  while IFS= read -r source; do
    target="$(infer_target_path "$source")"
    link_file "$source" "$target"
  done < <(discover_sources)

  success "Install complete."
  log "Reload your shell with: source ~/.zshrc"
}

main "$@"
