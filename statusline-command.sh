#!/usr/bin/env bash
input=$(cat)

GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
DIM="\033[2m"
RESET="\033[0m"

date_fmt() {
  epoch=$1
  fmt=$2
  if date -r 0 "+%s" >/dev/null 2>&1; then
    date -r "$epoch" "$fmt"
  else
    date -d "@$epoch" "$fmt"
  fi
}

# Color based on consumption rate vs time elapsed in the window.
# If you are 50% used at 10% elapsed, that is red — even though 50% alone
# would normally be yellow. Falls back to absolute thresholds if time data
# is unavailable.
colorize_rate() {
  used_pct=$1
  window_secs=$2
  resets_at=$3

  color=""
  if [ -n "$resets_at" ] && [ -n "$window_secs" ] && [ "$window_secs" -gt 0 ] 2>/dev/null; then
    now=$(date +%s)
    remaining_secs=$((resets_at - now))
    if [ "$remaining_secs" -lt 0 ]; then remaining_secs=0; fi
    elapsed_secs=$((window_secs - remaining_secs))
    if [ "$elapsed_secs" -lt 60 ]; then elapsed_secs=60; fi

    ratio=$(( used_pct * window_secs / elapsed_secs ))

    if [ "$ratio" -ge 150 ] 2>/dev/null; then
      color="$RED"
    elif [ "$ratio" -ge 115 ] 2>/dev/null; then
      color="$YELLOW"
    else
      color="$GREEN"
    fi
  else
    if [ "$used_pct" -ge 80 ] 2>/dev/null; then
      color="$RED"
    elif [ "$used_pct" -ge 50 ] 2>/dev/null; then
      color="$YELLOW"
    else
      color="$GREEN"
    fi
  fi

  printf "${color}${used_pct}%%${RESET}"
}

colorize() {
  val=$1
  if [ "$val" -ge 80 ] 2>/dev/null; then
    printf "${RED}${val}%%${RESET}"
  elif [ "$val" -ge 50 ] 2>/dev/null; then
    printf "${YELLOW}${val}%%${RESET}"
  else
    printf "${GREEN}${val}%%${RESET}"
  fi
}

time_left() {
  resets_at=$1
  now=$(date +%s)
  diff=$((resets_at - now))
  if [ "$diff" -le 0 ]; then
    printf "(resetting)"
    return
  fi
  mins=$(( diff / 60 ))
  if [ "$mins" -ge 60 ]; then
    hrs=$(( mins / 60 ))
    rem=$(( mins % 60 ))
    if [ "$rem" -gt 0 ]; then
      printf "${DIM}(%dh %dmin left)${RESET}" "$hrs" "$rem"
    else
      printf "${DIM}(%dh left)${RESET}" "$hrs"
    fi
  else
    printf "${DIM}(%dmin left)${RESET}" "$mins"
  fi
}

resets_day() {
  resets_at=$1
  now=$(date +%s)
  diff=$((resets_at - now))
  if [ "$diff" -le 0 ]; then
    printf "(resetting)"
    return
  fi
  day=$(date_fmt "$resets_at" "+%a")
  time=$(date_fmt "$resets_at" "+%-I:%M%p")
  printf "${DIM}(Resets %s, %s)${RESET}" "$day" "$time"
}

model_full=$(echo "$input" | jq -r '.model.display_name // empty')
model_short=$(echo "$model_full" | sed 's/^Claude //')

five_int=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty | if . == "" then "" else (. + 0.5 | floor | tostring) end')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_int=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty | if . == "" then "" else (. + 0.5 | floor | tostring) end')
week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

ctx_int=$(echo "$input" | jq -r '.context_window.used_percentage // empty | if . == "" then "" else (. + 0.5 | floor | tostring) end')

effort="$CLAUDE_CODE_EFFORT_LEVEL"
if [ -z "$effort" ] && [ -f "$HOME/.claude/settings.json" ]; then
  effort=$(jq -r '.effortLevel // empty' "$HOME/.claude/settings.json" 2>/dev/null)
fi

parts=""

if [ -n "$model_short" ]; then
  if [ -n "$effort" ]; then
    parts="${DIM}${model_short} · ${effort}${RESET}"
  else
    parts="${DIM}${model_short}${RESET}"
  fi
fi

if [ -n "$five_int" ]; then
  colored=$(colorize_rate "$five_int" 18000 "$five_resets")
  label="Session: ${colored}"
  if [ -n "$five_resets" ]; then
    label="${label} $(time_left "$five_resets")"
  fi
  [ -n "$parts" ] && parts="$parts | "
  parts="${parts}${label}"
fi

if [ -n "$week_int" ]; then
  colored=$(colorize_rate "$week_int" 604800 "$week_resets")
  label="Week: ${colored}"
  if [ -n "$week_resets" ]; then
    label="${label} $(resets_day "$week_resets")"
  fi
  [ -n "$parts" ] && parts="$parts | "
  parts="${parts}${label}"
fi

if [ -n "$ctx_int" ]; then
  colored=$(colorize "$ctx_int")
  [ -n "$parts" ] && parts="$parts | "
  parts="${parts}Ctx: ${colored}"
fi

printf "%b" "$parts"
