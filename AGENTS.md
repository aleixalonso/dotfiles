# AGENTS.md

Guidance for coding agents working in this dotfiles repository.

## Project Shape

This is a personal macOS dotfiles repo. Most files are linked into `$HOME`, `$HOME/.config`, or app-specific support directories by `install.sh`.

Key entry points:

- `bootstrap.sh` runs `install.sh`, and optionally `macos.sh` with `--macos`.
- `install.sh` installs Homebrew dependencies, configures `fnm`, and symlinks tracked files.
- `macos.sh` applies macOS defaults and restarts Finder/Dock.
- `bin/repofmt` is a standalone repo-formatting utility installed to `~/.local/bin/repofmt`.
- `zsh/.zsh_functions` contains interactive shell helpers.

## Install Mapping Rules

The installer infers targets from repository paths. Preserve this convention when adding files:

- Hidden files map to `$HOME`, such as `zsh/.zshrc` to `$HOME/.zshrc`.
- Other non-hidden nested files map under `$HOME/.config`, such as `ghostty/config` to `$HOME/.config/ghostty/config`.
- Files named like `<dir>/<dir>.<ext>`, such as `starship/starship.toml`, map to `$HOME/.config/<dir>.<ext>`.
- `bin/*` maps to `$HOME/.local/bin/*`.
- `Library/*` maps to `$HOME/Library/*`.
- `ssh/*`, `claude/*`, and `codex/*` map to hidden home directories: `$HOME/.ssh/*`, `$HOME/.claude/*`, and `$HOME/.codex/*`.
- `agents/skills` is linked as a directory to both `$HOME/.agents/skills` and `$HOME/.claude/skills`.
- `vscode/settings.json` is special-cased and linked to both VS Code and Cursor settings.

For a new top-level directory, use the generic `$HOME/.config/<dir>/...` mapping unless the target is a conventional home-level location such as `$HOME/Library`, `$HOME/.ssh`, or `$HOME/.local/bin`. In that case, add an explicit rule to `infer_target_path` and document it here.

Do not add one-off symlink code unless the inferred mapping cannot express the target.

If a top-level directory needs special handling, update `should_skip_top_level` in `install.sh` so the generic linker does not also process it. `agents/` and `vscode/` are skipped for this reason because dedicated functions link them to multiple targets.

## Shell Conventions

- Keep `.zshenv` minimal. It runs for every zsh invocation and should mostly set environment and `PATH`.
- Keep `.zprofile` for login-shell setup.
- Keep `.zshrc` for interactive shell setup, completions, prompt, plugins, keybindings, and local overrides.
- Put interactive shell helpers in `zsh/.zsh_functions`.
- Put standalone utilities in `bin/` when they should be callable from any shell, script, editor task, or git hook.
- Keep functions that need to affect the current shell, especially ones that call `cd`, in `zsh/.zsh_functions`.
- `~/.zshrc.local` is intentionally left for machine-local or company-specific setup. Do not track private local configuration here.

## Script Style

- Bash scripts in this repo use `#!/usr/bin/env bash` and `set -euo pipefail`.
- Prefer small functions, explicit errors, and idempotent behavior.
- Keep scripts safe to rerun. Existing real files should be backed up, not overwritten.
- Keep paths and configuration generic. Prefer `$HOME`, `$USER`, `$(id -gn)`, inferred repository paths, and XDG-style variables over hardcoded usernames, personal home roots, or machine-specific absolute paths.
- Avoid adding network work outside `install.sh` or explicit setup commands.
- Be careful with commands that change host state: `brew`, `defaults`, `pmset`, `sudo`, `killall`, and git history commands.
- Do not introduce non-ASCII text unless the surrounding file already uses it for a clear reason.

## Utilities

When adding a new utility, make it executable and document it in `README.md`.

## Verification

There is no project-wide test suite. Use focused checks:

- For shell syntax, run `bash -n <script>` for bash scripts.
- For zsh files, run `zsh -n zsh/.zshrc zsh/.zsh_functions zsh/.zshenv zsh/.zprofile` when zsh is available.
- For installer changes, inspect `install.sh` target inference carefully before running it.
- Avoid running `bootstrap.sh`, `install.sh`, or `macos.sh` without explicit user intent because they modify the local machine.

## Git And Commits

- Follow Conventional Commits: `type(scope): description`.
- Use a single-line commit message with `git commit -m`.
- Do not include a commit body.
- The repo may already be ahead of `origin/main`; check status before committing and include only intended files.

## Documentation

Update `README.md` when behavior, install mapping, commands, or user-facing shortcuts change. Keep documentation direct and operational; this repo is for personal setup, not a marketing site.
