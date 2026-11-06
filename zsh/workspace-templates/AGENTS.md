# Workspace: {{WORKSPACE_NAME}}

## Required context

Before changing code, read `WORKSPACE.md`, `DECISIONS.md`, `STATUS.md`, and the applicable repository `AGENTS.md` files.

Repositories under this directory are separate Git worktrees. Run Git commands from the applicable repository.

## Context ownership

- `WORKSPACE.md` defines the epic goal, scope, non-goals, and acceptance criteria. Do not invent or silently change them.
- `DECISIONS.md` records material technical or product decisions and their rationale.
- `STATUS.md` records verified progress, blockers, and the next concrete step.

## Context maintenance

Before finishing a task, update the applicable context files if the work produced a material decision, scope change, interface constraint, blocker, or verified progress.

Record only facts supported by the user or observed work. Do not log routine commands, file reads, speculation, or details recoverable from Git history. If nothing material changed, leave the context files untouched.
