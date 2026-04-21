#!/usr/bin/env bash
# Nudge the user to finish wiring up the statusline if they have not
# configured one yet. Silent if any statusLine is already set.

SETTINGS="$HOME/.claude/settings.json"
SCRIPT="$CLAUDE_PLUGIN_ROOT/statusline-command.sh"

if [ -f "$SETTINGS" ] && jq -e '.statusLine' "$SETTINGS" >/dev/null 2>&1; then
  exit 0
fi

MSG="claude-usage-statusline is installed but the statusline is not yet enabled.

To enable it, paste this line into Claude Code:

/statusline please install and use this statusline: \"$SCRIPT\""

if command -v jq >/dev/null 2>&1; then
  jq -n --arg msg "$MSG" '{systemMessage: $msg}'
else
  # jq missing — fall back to plain stdout so the user still sees something
  printf "%s\n" "$MSG"
fi
exit 0
