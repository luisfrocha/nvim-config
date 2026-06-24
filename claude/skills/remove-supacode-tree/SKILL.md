---
name: remove-supacode-tree
description: Remove the Supacode git worktree for a branch (Git Tower naming pattern <repo>-<branch-with-slashes-as-dashes>). Use when the user says "/remove-supacode-tree <branch>", or asks to remove/delete a Supacode worktree or work tree for a branch.
---

# Remove Supacode Worktree

Removes the Supacode git worktree whose directory matches the Git Tower pattern
produced by the create skill: `<repo-name>-<branch-with-slashes-as-dashes>`,
located alongside the main repo.

Example: branch `hotfix/dashboard-activate-update` in repo `~/Sites/vistara-bi-ads-ui`
→ removes the worktree at `~/Sites/vistara-bi-ads-ui-hotfix-dashboard-activate-update`.

## How to run

The user provides the branch name as an argument, e.g.
`/remove-supacode-tree hotfix/old-branch`.

IMPORTANT: the `supacode` CLI only works from a terminal Supacode itself spawned
(it needs `$SUPACODE_SOCKET_PATH`, which is empty in iTerm and in Claude). It
fails from Claude with "Operation not permitted" (sandbox on OR off). So do NOT
execute the helper yourself — give the user the exact command to paste into a
Supacode terminal tab:

```sh
supacode-wt-rm <branch>
```

The script computes the worktree directory from the branch, percent-encodes its
path into the Supacode worktree ID, and calls `supacode worktree delete`.

## Rules

- Pass the user's branch argument exactly as given — do NOT pre-convert slashes.
- If the user gave no branch argument, ask for one instead of guessing.
- Do NOT run `supacode-wt-rm` / `supacode` yourself — it fails from Claude/iTerm.
  Print the command for the user to run in a Supacode terminal.
- This is destructive. Verified behavior: `supacode worktree delete` fully tears
  down the worktree — it removes the on-disk directory, the git worktree
  registration, AND the local branch. So it will DELETE the branch; warn the user
  before presenting the command if the branch may have unmerged/unpushed work.
- The script refuses to act if no matching worktree directory exists, and refuses
  to remove the main worktree; if the user shares those errors, relay them rather
  than working around them.
- The helper lives at `scripts/supacode-wt-rm` in this skill and is also symlinked
  onto PATH by the nvim-config `setup.sh`. If the user reports `command not found`,
  tell them to run `./setup.sh --link` in `~/Sites/nvim-config`.
