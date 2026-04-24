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
# Claude Code status line — research-backed context meter
# Supports real-time mode (Claude Code 2.1.72+) and fallback JSONL parsing mode.

LOG_FILE="/tmp/claude-statusline-calls.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# ── Read stdin ──────────────────────────────────────────────────────────────
input=$(cat)

# ── Extract common fields ────────────────────────────────────────────────────
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
CWD=$(echo "$input" | jq -r '.workspace.current_dir // ""')
DIR="${CWD##*/}"
TRANSCRIPT=$(echo "$input" | jq -r '.transcript_path // ""')
EXCEEDS=$(echo "$input" | jq -r '.context_window.exceeds_200k_tokens // false')

# ── Version detection: does used_percentage exist? ───────────────────────────
USED_PCT_RAW=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

if [ -n "$USED_PCT_RAW" ]; then
  # ── REAL-TIME MODE ────────────────────────────────────────────────────────
  TOTAL_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')

  # Scale: treat 80% real usage as 100% on the display scale
  SCALED=$(echo "$USED_PCT_RAW 80" | awk '{v = ($1 / $2) * 100; if (v > 100) v = 100; printf "%.0f", v}')

  # Override to 100% if exceeds_200k flag is set
  [ "$EXCEEDS" = "true" ] && SCALED=100

  echo "[$TIMESTAMP] REALTIME: Tokens: ${TOTAL_TOKENS} | Raw: ${USED_PCT_RAW}% | Scaled: ${SCALED}%" >> "$LOG_FILE"
else
  # ── FALLBACK MODE — parse JSONL transcript ────────────────────────────────
  TOTAL_TOKENS=0

  if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
    LAST_USAGE=$(grep '"role":"assistant"' "$TRANSCRIPT" 2>/dev/null \
      | awk -F'"usage":' 'NF>1{print $2}' \
      | awk -F'}' '{print $1"}"}' \
      | while read -r obj; do
          input_t=$(echo "$obj" | jq -r '.input_tokens // 0' 2>/dev/null)
          cache_r=$(echo "$obj" | jq -r '.cache_read_input_tokens // 0' 2>/dev/null)
          total=$((input_t + cache_r))
          [ "$total" -gt 1000 ] && echo "$total"
        done \
      | tail -1)

    [ -n "$LAST_USAGE" ] && TOTAL_TOKENS="$LAST_USAGE"
  fi

  RAW_PCT=$(echo "$TOTAL_TOKENS" | awk '{printf "%.2f", ($1 / 200000) * 100}')
  SCALED=$(echo "$RAW_PCT 80" | awk '{v = ($1 / $2) * 100; if (v > 100) v = 100; printf "%.0f", v}')

  [ "$EXCEEDS" = "true" ] && SCALED=100

  echo "[$TIMESTAMP] FALLBACK: Tokens: ${TOTAL_TOKENS} | Raw: ${RAW_PCT}% | Scaled: ${SCALED}%" >> "$LOG_FILE"
fi

# ── Progress bar ──────────────────────────────────────────────────────────────
BAR_WIDTH=10
FILLED=$((SCALED / 10))
[ "$FILLED" -gt "$BAR_WIDTH" ] && FILLED=$BAR_WIDTH
EMPTY=$((BAR_WIDTH - FILLED))

BAR=""
i=0
while [ "$i" -lt "$FILLED" ]; do BAR="${BAR}█"; i=$((i+1)); done
i=0
while [ "$i" -lt "$EMPTY" ]; do BAR="${BAR}░"; i=$((i+1)); done

# ── Colors ────────────────────────────────────────────────────────────────────
RESET='\033[0m'
DIM='\033[2m'

if [ "$SCALED" -ge 80 ]; then
  COLOR='\033[5;31m'       # blinking red — critical
elif [ "$SCALED" -ge 70 ]; then
  COLOR='\033[38;5;208m'   # orange — warning
elif [ "$SCALED" -ge 60 ]; then
  COLOR='\033[33m'         # yellow — caution
else
  COLOR='\033[32m'         # bright green — safe
fi

# ── Warning message ───────────────────────────────────────────────────────────
WARN=""
if [ "$SCALED" -ge 80 ]; then
  WARN=" 🚨 /handoff-prompt NOW - dontsleeponai.com"
elif [ "$SCALED" -ge 70 ]; then
  WARN=" ⚠️  /handoff-prompt dontsleeponai.com/handoff-prompt"
elif [ "$SCALED" -ge 60 ]; then
  WARN=" 👉 /handoff-prompt dontsleeponai.com/handoff-prompt"
fi

# ── Render ────────────────────────────────────────────────────────────────────
printf "${DIM}%s${RESET} │ ${DIM}%s${RESET} ${COLOR}%s %s%%${RESET}%s\n" \
  "$MODEL" "$DIR" "$BAR" "$SCALED" "$WARN"
STATUSLINE

chmod +x "$SCRIPT_DEST"
echo "✓ Wrote $SCRIPT_DEST"

# ── 2. Patch settings.json ───────────────────────────────────────────────────
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
  echo "✓ Created $SETTINGS"
fi

# Only add statusLine if not already present
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
