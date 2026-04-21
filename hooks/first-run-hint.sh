#!/usr/bin/env bash
# Sync the statusline script to a short, stable path in ~/.claude/ so the
# user's settings.json doesn't embed the versioned plugin cache path
# (which changes on every plugin update). Then, if no statusLine is
# configured yet, nudge the user with the /statusline line to paste.

SRC="$CLAUDE_PLUGIN_ROOT/statusline-command.sh"
DEST="$HOME/.claude/claude-usage-statusline.sh"
SETTINGS="$HOME/.claude/settings.json"

if [ -f "$SRC" ]; then
  mkdir -p "$HOME/.claude"
  cp -f "$SRC" "$DEST"
  chmod +x "$DEST" 2>/dev/null
fi

if [ -f "$SETTINGS" ] && jq -e '.statusLine' "$SETTINGS" >/dev/null 2>&1; then
  exit 0
fi

MSG="claude-usage-statusline is installed but the statusline is not yet enabled.

To enable it, paste this line into Claude Code:

/statusline please install and use this statusline: $DEST"

if command -v jq >/dev/null 2>&1; then
  jq -n --arg msg "$MSG" '{systemMessage: $msg}'
else
  printf "%s\n" "$MSG"
fi
exit 0
