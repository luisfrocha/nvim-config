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

Run the bundled helper from inside any worktree of the target repo:

```sh
supacode-wt-rm <branch>                # if ~/.local/bin is on PATH
scripts/supacode-wt-rm <branch>        # relative to this skill dir
```

The script computes the worktree directory from the branch, percent-encodes its
path into the Supacode worktree ID, and calls `supacode worktree delete`.

## Rules

- Pass the user's branch argument exactly as given — do NOT pre-convert slashes.
- If the user gave no branch argument, ask for one instead of guessing.
- This is destructive — it removes a worktree. Confirm the branch with the user
  before running if there's any ambiguity, and surface the script's output.
- The script refuses to act if no matching worktree directory exists, and refuses
  to remove the main worktree; relay those errors rather than working around them.
- IMPORTANT / unverified: it is not confirmed whether `supacode worktree delete`
  also removes the on-disk directory, runs `git worktree remove`, and/or deletes
  the local branch, versus only removing Supacode's entry. After running, check
  whether the directory and branch still exist and tell the user what remains, so
  they can clean up manually (`git worktree remove` / delete branch) if needed.
- The helper lives at `scripts/supacode-wt-rm` in this skill and is also symlinked
  onto PATH by the nvim-config `setup.sh`. If neither resolves, tell the user to
  run `./setup.sh --link` in `~/Sites/nvim-config`.
