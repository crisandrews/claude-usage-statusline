---
description: Print the exact /statusline invocation to install claude-usage-statusline
allowed-tools: Bash(echo:*)
---

The user just installed the `claude-usage-statusline` plugin. Help them enable it by delegating to Claude Code's built-in `/statusline` flow.

Do exactly this, nothing more:

1. Run `echo "$CLAUDE_PLUGIN_ROOT"` to resolve this plugin's install path.

2. Print — as a single fenced code block, nothing else around it — the line the user should paste next:

   ```
   /statusline please install and use this statusline: <RESOLVED_PATH>/statusline-command.sh
   ```

   Replace `<RESOLVED_PATH>` with the path from step 1. If the path contains spaces, wrap the full path in double quotes inside the line.

3. Below the code block, add one short sentence: "Paste that line into Claude Code and it will wire up your settings.json for you."

No other commentary.
