---
name: create-supacode-tree
description: Create a new Supacode git worktree whose directory follows Git Tower's naming pattern (<repo>-<branch-with-slashes-as-dashes>). Use when the user says "/create-supacode-tree <branch>", or asks to create/make a Supacode worktree or work tree for a branch.
---

# Create Supacode Worktree

Creates a Supacode git worktree using the `supacode-wt` helper, which names the
worktree directory the way Git Tower does: `<repo-name>-<branch-with-slashes-as-dashes>`,
placed alongside the main repo.

Example: branch `hotfix/dashboard-activate-update` in repo `~/Sites/vistara-bi-ads-ui`
→ `~/Sites/vistara-bi-ads-ui-hotfix-dashboard-activate-update`.

## How to run

The user provides a branch name (and optionally a base ref) as arguments, e.g.
`/create-supacode-tree hotfix/new-branch-name` or
`/create-supacode-tree feature/x develop`.

Run the helper with those arguments, from inside any worktree of the target repo:

```sh
supacode-wt <branch> [base-ref]
```

- `<branch>` — the branch name the user gave (pass it through verbatim, slashes
  included; the script handles slash→dash conversion for the folder name).
- `[base-ref]` — only if the user supplied one; when present the script fetches
  the base before branching.

## Rules

- Pass the user's branch argument exactly as given — do NOT pre-convert slashes.
- If the user gave no branch argument, ask for one instead of guessing.
- `supacode-wt` is installed on PATH (symlinked from the nvim-config repo). If the
  command is not found, tell the user to run `./setup.sh --install` (or `--update`) in
  `~/Sites/nvim-config` and ensure `~/.local/bin` is on PATH — do not reimplement
  the worktree creation inline.
- The script refuses to overwrite an existing directory and requires being run
  inside a git repo / a Supacode terminal; surface its error message to the user
  rather than working around it.
