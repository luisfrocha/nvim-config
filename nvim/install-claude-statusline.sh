#!/bin/bash
# Installs the Claude Code statusline script and wires it into ~/.claude/settings.json.
# Safe to re-run — overwrites the script, patches settings only if the key is missing.

set -euo pipefail

SCRIPT_DEST="$HOME/.claude/statusline.sh"
SETTINGS="$HOME/.claude/settings.json"

# ── 1. Write statusline script ───────────────────────────────────────────────
mkdir -p "$HOME/.claude"

cat > "$SCRIPT_DEST" << 'STATUSLINE'
#!/bin/bash
# Claude Code statusline — research-backed context tracking
# Supports real-time mode (Claude Code 2.1.72+) and fallback transcript-parse mode.

input=$(cat)

# ── Fields from JSON ──────────────────────────────────────────────────────────
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // ""')
TRANSCRIPT=$(echo "$input" | jq -r '.transcript_path // ""')
TOTAL_INPUT=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
USED_PCT_RAW=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
EXCEEDS=$(echo "$input" | jq -r 'if (.context_window.total_input_tokens // 0) > 200000 then "true" else "false" end')

LOG=/tmp/claude-statusline-calls.log
TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S')

# ── Version detection & percentage calculation ────────────────────────────────
if [ -n "$USED_PCT_RAW" ]; then
  # REAL-TIME MODE (Claude Code 2.1.72+)
  RAW_INT=$(echo "$USED_PCT_RAW" | cut -d. -f1)
  SCALED=$(( (RAW_INT * 100) / 80 ))
  [ "$SCALED" -gt 100 ] && SCALED=100
  [ "$EXCEEDS" = "true" ] && SCALED=100
  printf '%s REALTIME: Tokens: %s | Raw: %s%% | Scaled: %s%%\n' \
    "$TIMESTAMP" "$TOTAL_INPUT" "$RAW_INT" "$SCALED" >> "$LOG"
else
  # FALLBACK MODE — parse transcript JSONL
  RAW_INT=0
  if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
    LAST=$(grep '"type":"assistant"' "$TRANSCRIPT" 2>/dev/null \
      | awk -F'"input_tokens":' 'NF>1{
          split($2,a,","); split($3,b,",");
          cache=0; gsub(/[^0-9]/,"",a[1]);
          if (length($3)) {gsub(/[^0-9]/,"",b[1]); cache=b[1]+0}
          total=a[1]+cache;
          if (total>1000) last=total
        } END{print last+0}')
    if [ "$LAST" -gt 0 ]; then
      RAW_INT=$(( (LAST * 100) / 200000 ))
    fi
  fi
  SCALED=$(( (RAW_INT * 100) / 80 ))
  [ "$SCALED" -gt 100 ] && SCALED=100
  [ "$EXCEEDS" = "true" ] && SCALED=100
  printf '%s FALLBACK: Tokens: %s | Raw: %s%% | Scaled: %s%%\n' \
    "$TIMESTAMP" "$TOTAL_INPUT" "$RAW_INT" "$SCALED" >> "$LOG"
fi

# ── ANSI colors (must be defined before bar/git use them) ─────────────────────
RESET=$'\033[0m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
GREEN_B=$'\033[32m'
YELLOW_C=$'\033[33m'
ORANGE_W=$'\033[38;5;208m'
RED_CRIT=$'\033[5;31m'

if   [ "$SCALED" -ge 80 ]; then BAR_COLOR="$RED_CRIT"
elif [ "$SCALED" -ge 70 ]; then BAR_COLOR="$ORANGE_W"
elif [ "$SCALED" -ge 60 ]; then BAR_COLOR="$YELLOW_C"
else                             BAR_COLOR="$GREEN_B"
fi

# ── Progress bar ─────────────────────────────────────────────────────────────
BAR_WIDTH=10
FILLED=$(( SCALED * BAR_WIDTH / 100 ))
EMPTY=$(( BAR_WIDTH - FILLED ))
BAR=""
i=0
while [ $i -lt "$FILLED" ]; do BAR="${BAR}${BAR_COLOR}${BOLD}▰${RESET}"; i=$(( i+1 )); done
i=0
while [ $i -lt "$EMPTY" ];  do BAR="${BAR}${DIM}▱${RESET}"; i=$(( i+1 )); done

# ── Warning message ───────────────────────────────────────────────────────────
WARN=""
if   [ "$SCALED" -ge 80 ]; then WARN=" 🚨 /handoff-prompt NOW - dontsleeponai.com"
elif [ "$SCALED" -ge 70 ]; then WARN=" ⚠️  /handoff-prompt dontsleeponai.com/handoff-prompt"
elif [ "$SCALED" -ge 60 ]; then WARN=" 👉 /handoff-prompt dontsleeponai.com/handoff-prompt"
fi

# ── Git info ──────────────────────────────────────────────────────────────────
GIT_LINE=""
GIT_STATUS_STR=""
if git -c core.fsync=none rev-parse --git-dir >/dev/null 2>&1; then
  BRANCH=$(git -c core.fsync=none branch --show-current 2>/dev/null)
  STAGED=$(git -c core.fsync=none diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  MODIFIED=$(git -c core.fsync=none diff --numstat 2>/dev/null | wc -l | tr -d ' ')
  [ "$STAGED" -gt 0 ]   && GIT_STATUS_STR="${GREEN_B}+${STAGED}${RESET}"
  [ "$MODIFIED" -gt 0 ] && GIT_STATUS_STR="${GIT_STATUS_STR}${YELLOW_C}~${MODIFIED}${RESET}"
  GIT_LINE="🌿 ${BRANCH}${GIT_STATUS_STR:+ $GIT_STATUS_STR}"
fi

# ── Two output lines ──────────────────────────────────────────────────────────
DIRNAME="${DIR##*/}"
if [ -n "$GIT_LINE" ]; then
  printf "${DIM}📁 %s${RESET} │ %s\n" "$DIRNAME" "$GIT_LINE"
else
  printf "${DIM}📁 %s${RESET}\n" "$DIRNAME"
fi

printf "${DIM}%s${RESET} │ %s${BAR_COLOR} %s%%%s${RESET}\n" \
  "$MODEL" "$BAR" "$SCALED" "$WARN"
STATUSLINE

chmod +x "$SCRIPT_DEST"
echo "✓ Wrote $SCRIPT_DEST"

# ── 2. Patch settings.json ───────────────────────────────────────────────────
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
  echo "✓ Created $SETTINGS"
fi

if ! jq -e '.statusLine' "$SETTINGS" > /dev/null 2>&1; then
  tmp=$(mktemp)
  jq '. + {"statusLine": {"type": "command", "command": "~/.claude/statusline.sh"}}' \
    "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
  echo "✓ Added statusLine to $SETTINGS"
else
  echo "  statusLine already present in $SETTINGS — skipped"
fi

echo ""
echo "Done. Reload Claude Code to activate the statusline."
