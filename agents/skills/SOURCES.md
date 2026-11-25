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
| `writing-clearly-and-concisely` | `obra/the-elements-of-style` | `skills/writing-clearly-and-concisely` |

Last synced revisions:

- `mattpocock/skills` at `49dd158d1076134a641b33efb035946536778336` (2026-10-09, package v1.3.1)
- `vercel-labs/skills` at `13e4063a1cf913f5606d57d42ab83a86f5001e04` (2026-10-09)
- `obra/the-elements-of-style` at `05fc4f0d2b97b7c042dd9949ad658568e4a1324e` (2026-08-12)

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
rsync -a --delete "$tmp/vercel-labs/skills/find-skills/" agents/skills/find-skills/
rsync -a --delete "$tmp/the-elements-of-style/skills/writing-clearly-and-concisely/" agents/skills/writing-clearly-and-concisely/

git diff -- agents/skills
```

Then update the synced revisions above if the upstream commits changed.

The vendored skills use each client's default invocation settings. After syncing, check that upstream metadata still allows automatic invocation.

`resolving-merge-conflicts` is intentionally not synced. Upstream removed it and nothing replaces it; the local copy is maintained here.
