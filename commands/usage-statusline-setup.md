---
description: Print the exact /statusline invocation to install claude-usage-statusline
allowed-tools: Bash(cp:*), Bash(chmod:*), Bash(mkdir:*)
---

The user wants to (re-)enable `claude-usage-statusline`. The plugin's SessionStart hook normally mirrors the script to `~/.claude/claude-usage-statusline.sh`, but this command is the manual fallback.

Do exactly this, nothing more:

1. Ensure the short, stable script path exists by running:
   ```
   mkdir -p "$HOME/.claude" && cp -f "$CLAUDE_PLUGIN_ROOT/statusline-command.sh" "$HOME/.claude/claude-usage-statusline.sh" && chmod +x "$HOME/.claude/claude-usage-statusline.sh"
   ```

2. Print — as a single fenced code block, nothing else around it — the line the user should paste next:

   ```
   /statusline please install and use this statusline: ~/.claude/claude-usage-statusline.sh
   ```

3. Below the code block, add one short sentence: "Paste that line into Claude Code and it will wire up your settings.json for you."

No other commentary.
