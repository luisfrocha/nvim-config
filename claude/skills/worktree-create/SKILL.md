---
name: worktree-create
description: Create a new git worktree (in Supacode or herdr) whose directory follows Git Tower's naming pattern (<repo>-<branch-with-slashes-as-dashes>). Use when the user says "/worktree-create <branch>", or asks to create/make a worktree or work tree for a branch.
---

# Create Worktree

Creates a git worktree using the `wt-new` helper, which names the
worktree directory the way Git Tower does: `<repo-name>-<branch-with-slashes-as-dashes>`,
placed alongside the main repo. It detects the app it runs in: in Supacode it adds the
Supacode ownership lock; in herdr it registers the checkout with `herdr worktree open --focus` (you land in the new workspace);
in a plain terminal it only creates the worktree.

Example: branch `hotfix/dashboard-activate-update` in repo `~/Sites/vistara-bi-ads-ui`
→ `~/Sites/vistara-bi-ads-ui-hotfix-dashboard-activate-update`.

## How to run

The user provides a branch name (and optionally a base ref) as arguments, e.g.
`/worktree-create hotfix/new-branch-name` or
`/worktree-create feature/x develop`.

IMPORTANT: the `supacode` and `herdr` CLIs only talk to their app socket from a process that is
allowed out of Apple Claude Code's sandbox. By default that fails from Claude's Bash tool with
"Operation not permitted" (Supacode re-verified 2026-10-12; herdr 2026-10-27, sandbox override on
and off). Adding `wt-new` to the tool allowlist (Dashboard → Tools → Add, `contains_match`) lifts
that for herdr: verified 2026-10-27, `wt-new` ran from Claude's Bash tool and registered the
worktree. Supacode has not been re-tested with the allowlist entry.

So decide by checking the allowlist, read-only, before doing anything:

```sh
grep -E '^wt-new,contains_match' ~/.claude/apple/tool_allowlist.csv
```

- **Match found** (permanent entry): run `wt-new <branch> [base-ref]` yourself and relay its
  output. Use the user's arguments verbatim.
- **No match**: do NOT run it — a sandboxed run can create the git worktree and then fail to
  register it with the app. Give the user the command to paste into a Supacode or herdr terminal,
  and mention they can add `wt-new` in the Dashboard (Tools tab) to let Claude run it. Never edit
  `tool_allowlist.csv` yourself.
- A session-only Dashboard entry is not written to the file, so this check misses it. If the user
  says they added one for this session, run it.

The command to present when not running it:

```sh
wt-new <branch> [base-ref]
```

Substitute the user's arguments and present it as a ready-to-run line (e.g.
`wt-new feature/x` or `wt-new feature/x develop`).

- `<branch>` — the branch name the user gave (pass it through verbatim, slashes
  included; the script handles slash→dash conversion for the folder name).
- `[base-ref]` — only if the user supplied one; when present the script fetches
  the base before branching.

You MAY note the resulting worktree path so the user knows what to expect:
`<parent-of-repo>/<repo-name>-<branch-with-slashes-as-dashes>`.

## Rules

- Pass the user's branch argument exactly as given — do NOT pre-convert slashes.
- If the user gave no branch argument, ask for one instead of guessing.
- Run `wt-new` only when the allowlist check above finds its entry. Never run `supacode` / `herdr`
  directly, and never change the sandbox, the allowlist or any permission setting.
- After a run, name the worktree path and the app it registered with, and remind the user that
  `wt-rm` is not allowlisted: removal is still theirs to run.
- The helper lives at `scripts/wt-new` in this skill and is also symlinked
  onto PATH as `wt-new` by the nvim-config `setup.sh`. If the user reports
  `command not found`, tell them to run `./setup.sh --link` (or `--install`) in
  `~/Sites/nvim-config` — do not reimplement the worktree creation inline.
- The script refuses to overwrite an existing directory and requires being run
  inside a git repo; if the user shares an error, relay it
  rather than working around it.
