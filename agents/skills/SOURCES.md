# Agent Skill Sources

These skills are vendored into this repository. `install.sh` links them but does not update them.

## Sources

| Local skill | Upstream repository | Upstream path |
| --- | --- | --- |
| `codebase-design` | `mattpocock/skills` | `skills/engineering/codebase-design` |
| `domain-modeling` | `mattpocock/skills` | `skills/engineering/domain-modeling` |
| `find-skills` | `vercel-labs/skills` | `skills/find-skills` |
| `grill-me` | `mattpocock/skills` | `skills/productivity/grill-me` |
| `grill-with-docs` | `mattpocock/skills` | `skills/engineering/grill-with-docs` |
| `grilling` | `mattpocock/skills` | `skills/productivity/grilling` |
| `improve-codebase-architecture` | `mattpocock/skills` | `skills/engineering/improve-codebase-architecture` |
| `resolving-merge-conflicts` | local only | originally from `mattpocock/skills`, removed upstream in v1.3.0 |
| `code-review` | `mattpocock/skills` | `skills/engineering/code-review` |
| `implement` | `mattpocock/skills` | `skills/engineering/implement` |
| `tdd` | `mattpocock/skills` | `skills/engineering/tdd` |
| `writing-clearly-and-concisely` | `obra/the-elements-of-style` | `skills/writing-clearly-and-concisely` |
| `espanol-natural` | `santiagocardonao/espanol-natural` | repository root (`SKILL.md` and `LICENSE`) |
| `oma-translation` | `first-fluke/oh-my-agent` | `.agents/skills/oma-translation` and selected files from `.agents/skills/_shared` |

Last synced revisions:

- `mattpocock/skills` at `6f7f7831a625f040a8e06a0e7954826b87ce775a` (2026-11-25, package v1.3.2)
- `vercel-labs/skills` at `13e4063a1cf913f5606d57d42ab83a86f5001e04` (2026-10-09)
- `obra/the-elements-of-style` at `05fc4f0d2b97b7c042dd9949ad658568e4a1324e` (2026-08-12)
- `santiagocardonao/espanol-natural` at `043d7cf10c93f21350cf650f36b0aa5614cfa480` (2026-11-26)
- `first-fluke/oh-my-agent` at `1e4e1d71a2871d665f4e5876cff476fe372c8584` (2026-11-26)

`mattpocock/skills` and `vercel-labs/skills` are MIT licensed. `obra/the-elements-of-style` identifies the Strunk reference as public domain.

## Updating

Run from the repository root:

```bash
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

git clone --depth 1 https://github.com/mattpocock/skills.git "$tmp/mattpocock"
git clone --depth 1 https://github.com/vercel-labs/skills.git "$tmp/vercel-labs"
git clone --depth 1 https://github.com/obra/the-elements-of-style.git "$tmp/the-elements-of-style"

rsync -a --delete "$tmp/mattpocock/skills/engineering/codebase-design/" agents/skills/codebase-design/
rsync -a --delete "$tmp/mattpocock/skills/engineering/domain-modeling/" agents/skills/domain-modeling/
rsync -a --delete "$tmp/mattpocock/skills/productivity/grill-me/" agents/skills/grill-me/
rsync -a --delete "$tmp/mattpocock/skills/engineering/grill-with-docs/" agents/skills/grill-with-docs/
rsync -a --delete "$tmp/mattpocock/skills/productivity/grilling/" agents/skills/grilling/
rsync -a --delete "$tmp/mattpocock/skills/engineering/improve-codebase-architecture/" agents/skills/improve-codebase-architecture/
rsync -a --delete "$tmp/mattpocock/skills/engineering/code-review/" agents/skills/code-review/
rsync -a --delete "$tmp/mattpocock/skills/engineering/implement/" agents/skills/implement/
rsync -a --delete "$tmp/mattpocock/skills/engineering/tdd/" agents/skills/tdd/
rsync -a --delete "$tmp/vercel-labs/skills/find-skills/" agents/skills/find-skills/
rsync -a --delete "$tmp/the-elements-of-style/skills/writing-clearly-and-concisely/" agents/skills/writing-clearly-and-concisely/

git diff -- agents/skills
```

Then update the synced revisions above if the upstream commits changed.

The vendored skills use each client's default invocation settings. After syncing, check that upstream metadata still allows automatic invocation.

To update `espanol-natural`, copy `SKILL.md` and `LICENSE` from the upstream revision. To update `oma-translation`, refresh the skill directory and copy the upstream `LICENSE` and the shared references listed below from the same revision.

- `core/anti-ai-prose.md`
- `core/context-loading.md`
- `core/quality-principles.md`
- `runtime/route-selection.md`

Copy the shared files from `.agents/skills/_shared` into `oma-translation/resources/oma-shared`, preserving their subdirectories. Update references to `_shared` in the skill files to point to that local directory, relative to each file.

`resolving-merge-conflicts` is intentionally not synced. Upstream removed it and nothing replaces it; the local copy is maintained here.
