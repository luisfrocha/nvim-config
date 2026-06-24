#!/usr/bin/env bash
#
# Shared helpers for the Supacode worktree scripts (create/remove).
# Source this; do not execute it directly.
#
# Naming follows Git Tower's pattern: <repo-name>-<branch-with-slashes-as-dashes>,
# placed alongside the main repo. Example: branch hotfix/x in ~/Sites/foo
#   -> ~/Sites/foo-hotfix-x

# Abort unless the Supacode CLI is available (only present in Supacode terminals).
wt_require_supacode() {
  command -v supacode >/dev/null 2>&1 || {
    echo "${0##*/}: the 'supacode' CLI is not on PATH (run inside a Supacode terminal)." >&2
    return 1
  }
}

# Resolve the MAIN repo root (not the current worktree) from the current dir, so
# paths are stable no matter which worktree we're invoked from.
# Sets: WT_MAIN_ROOT, WT_REPO_NAME, WT_PARENT_DIR
wt_resolve_repo() {
  local git_common_dir
  git_common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
    echo "${0##*/}: not inside a git repository." >&2
    return 1
  }
  WT_MAIN_ROOT=$(dirname "$git_common_dir")
  WT_REPO_NAME=$(basename "$WT_MAIN_ROOT")
  WT_PARENT_DIR=$(dirname "$WT_MAIN_ROOT")
}

# wt_folder_name <branch> -> "<repo>-<branch with every / turned into ->"
wt_folder_name() {
  local branch=$1
  printf '%s-%s' "$WT_REPO_NAME" "${branch//\//-}"
}

# wt_target_path <branch> -> absolute worktree directory path
wt_target_path() {
  printf '%s/%s' "$WT_PARENT_DIR" "$(wt_folder_name "$1")"
}

# Decode a percent-encoded string (e.g. a Supacode worktree ID -> filesystem path).
wt_percent_decode() {
  printf '%b' "${1//%/\\x}"
}

# Percent-encode a string into a Supacode worktree ID (e.g. /tmp/repo -> %2Ftmp%2Frepo).
# Encodes every byte except unreserved chars (A-Z a-z 0-9 - _ . ~).
wt_percent_encode() {
  local s=$1 out='' c i
  for ((i = 0; i < ${#s}; i++)); do
    c=${s:i:1}
    case $c in
    [a-zA-Z0-9._~-]) out+=$c ;;
    *) out+=$(printf '%%%02X' "'$c") ;;
    esac
  done
  printf '%s' "$out"
}
