---
name: worktree-remove
description: Remove the git worktree for a branch (Supacode or herdr; Git Tower naming pattern <repo>-<branch-with-slashes-as-dashes>), guarded against losing work, and report what every worktree/branch would lose. Use when the user says "/worktree-remove <branch>", asks to remove/delete a worktree or work tree, or asks which worktrees/branches are safe to delete or would be orphaned.
---

# Remove Worktree

Removes the git worktree whose directory matches the Git Tower pattern
produced by the create skill: `<repo-name>-<branch-with-slashes-as-dashes>`,
located alongside the main repo.

Example: branch `hotfix/dashboard-activate-update` in repo `~/Sites/vistara-bi-ads-ui`
→ removes the worktree at `~/Sites/vistara-bi-ads-ui-hotfix-dashboard-activate-update`.

## What deleting actually does (verified 2026-10-12, Supacode 0.10.8)

- Removes the folder and the git worktree registration. **Uncommitted and untracked files are
  gone for good** — `/private/tmp/supacode-worktree-trash/` is transient, not a recycle bin.
- **Keeps the local branch** (Supacode's own delete; `wt-rm` now offers to delete it afterwards, see below): `~/.supacode/settings.json` has
  `global.deleteBranchOnDeleteWorktree = false`. Deleting the branch is a separate step (log
  its tip SHA in `~/.claude/deleted-refs.log` first).
- Runs the repository's **Delete Script** first; a **non-zero exit cancels the delete** (both
  the sidebar entry and the folder survive).

## The scripts (all in `scripts/`, on PATH via nvim-config `setup.sh --link`)

| Script | What it does |
|---|---|
| `wt-rm [--force] <branch>` | Runs `wt-guard --check`, refuses if anything would be lost, otherwise asks the detected app to delete (`supacode worktree delete`, `herdr worktree remove --force`, or plain `git worktree remove --force`; the `--force` is only reached after the guard has passed or the user forced, and is needed because herdr and git refuse worktrees holding untracked files such as the copies `wt-new` makes). `--force` deletes anyway and the override is logged. |
| `wt-guard [path]` | The Delete Script hook. Exit 1 with a list of what would be lost; exit 0 and append to `~/.claude/deleted-refs.log`. `--check` audits without logging. |
| `wt-report [--all] [--no-gh] [repo]` | Read-only: every worktree's branch, PR, push state, mainline status and guard verdict; orphaned `<repo>-*` folders; separate clones; local branches whose commits are on no remote. |
| `wt-report --orphan <folder> <branch>` | What a folder whose worktree registration was pruned holds that the branch lacks (throwaway index; the repo's index is untouched). |

### Prompts and branch cleanup in `wt-rm`

- If wt-guard finds work that exists nowhere else, or herdr/git would refuse a worktree holding
  modified or untracked files, `wt-rm` lists the files and asks `Force the deletion? [y/N]`. Without a
  terminal it refuses and says to re-run with `--force`. `--force` skips the questions.
- After a successful removal it offers to delete the branch: `[l]ocal / [r]emote / [b]oth / [N]o`, each
  offered only when safe. **Local**: the tip is on some remote branch and no worktree has it checked
  out. **Remote** (`git push origin --delete`): `origin/<branch>` is fully merged into the mainline, and
  a second `[y/N]` names the remote ref. Never the mainline. Each deletion is logged to
  `~/.claude/deleted-refs.log` first, with a restore command. Remote info comes from a fresh `git fetch`;
  if that fails the script says it may be stale.
- Tested 2026-10-27 in a throwaway repo with the plain-git path only (merged branch → both; pushed but
  unmerged → remote refused, local ok; unpushed + forced → both refused). The herdr and Supacode paths
  share this code but were not exercised.

What the guard treats as "would be lost" (shared logic in `claude/common/worktree-audit.sh`):
tracked changes (except a CLAUDE.md whose added lines all exist in the mainline's CLAUDE.md);
untracked non-ignored files with no byte-identical copy at the same path in another worktree;
top-level ignored `.env*` files with no identical copy elsewhere; commits on no remote branch.
Mainline is `origin/main`, else `origin/master`, else `origin/HEAD`. The "N of M added lines not
in mainline" hint is a line-matching heuristic for deciding, never a reason to allow the delete.

## Setting up the hook (Supacode only; once per repository, in the Supacode UI)

Settings → *<repository>* → Scripts → **Delete Script**: `"$HOME/.local/bin/wt-guard"`.
`wt-report` prints `Supacode Delete Script: NOT SET` for any repo still missing it. Until it is
set, deleting from the sidebar is unguarded; `wt-rm` still guards and logs.

**herdr has no such hook that I know of** (its `worktree remove` help lists only `--workspace`, `--force`, `--trust-repository`), so removing a worktree from the herdr UI is unguarded. `wt-rm` guards and logs it itself. It finds herdr's workspace ID by matching the target path against `herdr worktree list` (`result.worktrees[].path` → `open_workspace_id`, shape verified 2026-10-27) and refuses if herdr has no open workspace there. What `herdr worktree remove` does to a dirty checkout, I have not verified — the guard runs first so it should not matter.

## How to run

The user provides the branch name, e.g. `/worktree-remove hotfix/old-branch`.

IMPORTANT: the `supacode` and `herdr` CLIs only work from a terminal the app itself spawned. Their
sockets refuse connections from Claude's Bash tool with "Operation not permitted" — with the sandbox
on AND off (Supacode re-verified 2026-10-12, herdr 2026-10-27). Do NOT execute `wt-rm` yourself; give the user:

```sh
wt-rm <branch>
```

`wt-guard --check <path>` and `wt-report` are read-only and DO run from Claude — use them to
show the user what a deletion would lose before handing over the command. `wt-report` fetches
first; when a fetch fails it says so at the top of that repo, and its "on no remote" findings
then rest on stale remote refs.

## Rules

- Pass the user's branch argument exactly as given — do NOT pre-convert slashes.
- If the user gave no branch argument, ask for one instead of guessing.
- Before presenting the command, run `wt-guard --check` on the target and show the findings. If
  it would refuse, say what is at risk; suggest `--force` only after the user has seen the list.
- Do NOT run `wt-rm` / `supacode` / `herdr` yourself.
- The local branch remains afterwards. Offer to delete it only if it is contained in the mainline
  or a remote branch, and log its tip SHA first (global CLAUDE.md, destructive-actions rule 6).
- The script refuses if no matching worktree directory exists, and refuses to remove the main
  worktree; relay those errors rather than working around them.
- If the user reports `command not found`, tell them to run `./setup.sh --link` in
  `~/Sites/nvim-config`.
