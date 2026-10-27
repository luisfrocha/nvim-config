#!/usr/bin/env bash
#
# Shared audit helpers for the Supacode worktree scripts (wt-guard, wt-report, wt-rm).
# Source this; do not execute it directly. Written for macOS's bash 3.2: no associative arrays,
# no mapfile.
#
# The question every helper answers is "what would be lost if this worktree folder disappeared?".
# Deleting a Supacode worktree removes the folder (uncommitted and untracked files are gone for
# good) but keeps the local branch (deleteBranchOnDeleteWorktree = false), so committed work is
# only at risk when no remote branch has it.

WTA_ALLOW_MARKER=.supacode-allow-delete

# The branch that "merged" means for this repo: origin/main when it exists, else origin/master,
# else origin/HEAD. origin/HEAD alone is wrong for repos whose default branch is a development
# branch (ireporter-applepay-ui's is branch-development, but releases end in main).
# Usage: wta_mainline <git-dir-or-worktree>
wta_mainline() {
  local repo=$1 ref
  for ref in origin/main origin/master; do
    if git -C "$repo" rev-parse -q --verify "$ref" >/dev/null; then
      printf '%s' "$ref"
      return
    fi
  done
  git -C "$repo" symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || printf 'origin/HEAD'
}

# Paths of every registered worktree of the repo containing $1, one per line (main checkout first).
wta_worktrees() {
  git -C "$1" worktree list --porcelain | awk '/^worktree /{sub(/^worktree /, ""); print}'
}

# True when some OTHER worktree of the repo has a byte-identical file at the same relative path.
# Paths are compared physically (pwd -P): `git worktree list` reports resolved paths, so a worktree
# reached through a symlink (macOS /tmp is /private/tmp) would otherwise fail to skip itself and
# "find" its own file as the copy.
# Usage: wta_has_copy_elsewhere <worktree> <relative-path>
wta_has_copy_elsewhere() {
  local wt rel=$2 mine other
  wt=$(cd "$1" && pwd -P) || return 1
  mine=$(git hash-object "$wt/$rel" 2>/dev/null) || return 1
  while IFS= read -r other; do
    other=$(cd "$other" 2>/dev/null && pwd -P) || continue
    [ "$other" = "$wt" ] && continue
    [ -f "$other/$rel" ] || continue
    [ "$(git hash-object "$other/$rel" 2>/dev/null)" = "$mine" ] && return 0
  done <<EOF
$(wta_worktrees "$wt")
EOF
  return 1
}

# True when every line CLAUDE.md gains over HEAD already exists in the mainline's CLAUDE.md. Those
# edits are the rule-propagation copies, so losing them loses nothing.
# Usage: wta_claude_md_disposable <worktree> <mainline>
wta_claude_md_disposable() {
  local wt=$1 mainline=$2 reference line
  reference=$(mktemp)
  if ! git -C "$wt" show "$mainline:CLAUDE.md" >"$reference" 2>/dev/null; then
    rm -f "$reference"
    return 1
  fi
  while IFS= read -r line; do
    [ -z "${line// /}" ] && continue
    if ! grep -qxF -- "$line" "$reference"; then
      rm -f "$reference"
      return 1
    fi
  done <<EOF
$(git -C "$wt" diff HEAD -- CLAUDE.md | sed -n 's/^+\([^+].*\)$/\1/p; s/^+$//p')
EOF
  rm -f "$reference"
  return 0
}

# A decision aid for a blocked file, never a reason to allow the delete: how many of the lines it
# adds over HEAD are absent from the mainline's version of the same file. Line matching is a
# heuristic (a line can exist elsewhere in the file for an unrelated reason), hence wording it as
# "lines", not "changes".
# Usage: wta_lines_missing_hint <worktree> <mainline> <path>
wta_lines_missing_hint() {
  local wt=$1 mainline=$2 path=$3 reference added=0 missing=0 line
  [ -f "$wt/$path" ] || {
    printf ' (deleted)'
    return
  }
  reference=$(mktemp)
  git -C "$wt" show "$mainline:$path" >"$reference" 2>/dev/null || : >"$reference"
  while IFS= read -r line; do
    [ -z "${line// /}" ] && continue
    added=$((added + 1))
    grep -qxF -- "$line" "$reference" || missing=$((missing + 1))
  done <<EOF
$(git -C "$wt" diff HEAD -- "$path" | sed -n 's/^+\([^+].*\)$/\1/p')
EOF
  rm -f "$reference"
  if [ "$added" -eq 0 ]; then
    printf ' (removals only)'
  else
    printf ' (%s of %s added lines not in %s)' "$missing" "$added" "$mainline"
  fi
}

# Audit one worktree. Prints one finding per line, each prefixed with BLOCK: (would be lost) or
# INFO: (worth knowing, nothing lost). Returns 0 when there is no BLOCK finding.
# Usage: wta_audit <worktree>
wta_audit() {
  local wt=$1 mainline line path code unpushed branch blocks=0 tmp
  mainline=$(wta_mainline "$wt")
  tmp=$(mktemp)

  # 1. Tracked changes, staged or not. CLAUDE.md is exempt only when its additions are all on the
  #    mainline already.
  git -C "$wt" status --porcelain=v1 --untracked-files=no >"$tmp"
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    code=${line:0:2}
    path=${line:3}
    if [ "$path" = "CLAUDE.md" ] && wta_claude_md_disposable "$wt" "$mainline"; then
      printf 'INFO: CLAUDE.md modified, but every added line is already in %s:CLAUDE.md\n' "$mainline"
      continue
    fi
    printf 'BLOCK: uncommitted change [%s] %s%s\n' "$code" "$path" "$(wta_lines_missing_hint "$wt" "$mainline" "$path")"
    blocks=$((blocks + 1))
  done <"$tmp"

  # 2. Untracked, non-ignored files with no identical copy in another worktree.
  git -C "$wt" ls-files --others --exclude-standard >"$tmp"
  while IFS= read -r path; do
    [ -z "$path" ] && continue
    [ "$path" = "$WTA_ALLOW_MARKER" ] && continue
    if wta_has_copy_elsewhere "$wt" "$path"; then
      printf 'INFO: untracked %s (identical copy in another worktree)\n' "$path"
    else
      printf 'BLOCK: untracked file found nowhere else: %s\n' "$path"
      blocks=$((blocks + 1))
    fi
  done <"$tmp"

  # 3. Ignored local config at the top level (.env and friends): ignored by git, but it carries
  #    local settings and secrets, so a unique one is worth keeping.
  for path in "$wt"/.env*; do
    [ -f "$path" ] || continue
    path=${path#"$wt"/}
    git -C "$wt" check-ignore -q -- "$path" || continue
    if ! wta_has_copy_elsewhere "$wt" "$path"; then
      printf 'BLOCK: ignored %s differs from every other worktree'"'"'s copy\n' "$path"
      blocks=$((blocks + 1))
    fi
  done

  # 4. Commits no remote branch has. The branch survives the delete, but these would be lost with
  #    the clone, and nothing else records them.
  unpushed=$(git -C "$wt" rev-list --count HEAD --not --remotes 2>/dev/null || echo 0)
  branch=$(git -C "$wt" branch --show-current)
  if [ "$unpushed" -gt 0 ]; then
    printf 'BLOCK: %s commit(s) on %s exist on no remote branch\n' "$unpushed" "${branch:-detached HEAD}"
    blocks=$((blocks + 1))
  fi

  # 5. Informational: whether the work reached the mainline.
  if git -C "$wt" merge-base --is-ancestor HEAD "$mainline" 2>/dev/null; then
    printf 'INFO: HEAD is contained in %s\n' "$mainline"
  else
    printf 'INFO: %s commit(s) not in %s (%s with no equivalent patch there)\n' \
      "$(git -C "$wt" rev-list --count "$mainline..HEAD")" "$mainline" \
      "$(git -C "$wt" cherry "$mainline" HEAD | grep -c '^+')"
  fi

  rm -f "$tmp"
  [ "$blocks" -eq 0 ]
}

# Remote branches (other than the branch's own) that contain a commit, comma-separated, max 3.
# Usage: wta_contained_in <worktree> <commit> [own-branch]
wta_contained_in() {
  git -C "$1" branch -r --contains "$2" 2>/dev/null |
    sed 's/^ *//' | grep -v -e ' -> ' -e "^origin/${3:-//none//}\$" | head -3 | paste -sd, -
}

# Append one line to the cross-repo deletion log, in the format ~/.claude/deleted-refs.log already
# uses: date | repo | ref | tip SHA | contained in | restore command
# Usage: wta_log_deletion <worktree> <note>
wta_log_deletion() {
  local wt=$1 note=$2 log=${WTA_DELETION_LOG:-$HOME/.claude/deleted-refs.log} repo branch sha contained
  repo=$(basename "$(dirname "$(git -C "$wt" rev-parse --path-format=absolute --git-common-dir)")")
  branch=$(git -C "$wt" branch --show-current)
  sha=$(git -C "$wt" rev-parse HEAD)
  contained=$(wta_contained_in "$wt" "$sha" || true)
  [ -f "$log" ] || printf '%s\n%s\n' \
    '# Deleted git refs (branches, worktrees). Append-only: one line per deletion, written BEFORE deleting.' \
    '# Format: date | repo | ref | tip SHA | contained in | restore command' >"$log"
  printf '%s | %s | worktree %s (branch %s kept; %s) | %s | %s | git worktree add %s %s\n' \
    "$(date +%F)" "$repo" "$wt" "${branch:-detached}" "$note" "$sha" "${contained:-no remote branch}" \
    "$wt" "${branch:-$sha}" >>"$log"
}

# Log a branch deletion (local or remote) in the same format, BEFORE deleting it.
# Usage: wta_log_branch <local|remote> <main-repo-root> <branch> <tip-sha> <contained-in>
wta_log_branch() {
  local kind=$1 root=$2 branch=$3 sha=$4 contained=$5 log=${WTA_DELETION_LOG:-$HOME/.claude/deleted-refs.log} ref restore
  if [ "$kind" = remote ]; then
    ref="branch origin/$branch (remote)"
    restore="git push origin $sha:refs/heads/$branch"
  else
    ref="branch $branch (local)"
    restore="git branch $branch $sha"
  fi
  [ -f "$log" ] || printf '%s\n%s\n' \
    '# Deleted git refs (branches, worktrees). Append-only: one line per deletion, written BEFORE deleting.' \
    '# Format: date | repo | ref | tip SHA | contained in | restore command' >"$log"
  printf '%s | %s | %s | %s | %s | %s\n' \
    "$(date +%F)" "$(basename "$root")" "$ref" "$sha" "${contained:-no remote branch}" "$restore" >>"$log"
}
