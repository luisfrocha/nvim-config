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

IMPORTANT: the `supacode` CLI can only talk to its app socket from a terminal
that Supacode itself spawned. It does NOT work when run from Claude (the socket
is rejected with "Operation not permitted", whether or not Claude's sandbox is
disabled), nor from a non-Supacode terminal like iTerm. So do NOT try to execute
the helper yourself — instead, give the user the exact command to paste into a
Supacode terminal tab:

```sh
supacode-wt <branch> [base-ref]
```

Substitute the user's arguments and present it as a ready-to-run line (e.g.
`supacode-wt feature/x` or `supacode-wt feature/x develop`).

- `<branch>` — the branch name the user gave (pass it through verbatim, slashes
  included; the script handles slash→dash conversion for the folder name).
- `[base-ref]` — only if the user supplied one; when present the script fetches
  the base before branching.

You MAY note the resulting worktree path so the user knows what to expect:
`<parent-of-repo>/<repo-name>-<branch-with-slashes-as-dashes>`.

## Rules

- Pass the user's branch argument exactly as given — do NOT pre-convert slashes.
- If the user gave no branch argument, ask for one instead of guessing.
- Do NOT run `supacode-wt` / `supacode` yourself — it fails from Claude. Print the
  command for the user to run in a Supacode terminal.
- The helper lives at `scripts/supacode-wt` in this skill and is also symlinked
  onto PATH as `supacode-wt` by the nvim-config `setup.sh`. If the user reports
  `command not found`, tell them to run `./setup.sh --link` (or `--install`) in
  `~/Sites/nvim-config` — do not reimplement the worktree creation inline.
- The script refuses to overwrite an existing directory and requires being run
  inside a git repo / a Supacode terminal; if the user shares an error, relay it
  rather than working around it.
