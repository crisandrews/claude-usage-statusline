---
description: Show the exact settings.json snippet to enable claude-usage-statusline
allowed-tools: Bash(echo:*), Bash(cat:*), Read, Edit
---

The user just installed the `claude-usage-statusline` plugin and wants to wire it up.

Do the following, in order:

1. Run `echo "$CLAUDE_PLUGIN_ROOT"` to resolve the absolute path to this plugin on the user's machine.

2. Print a clear, copy-pasteable block showing exactly what they must add to `~/.claude/settings.json`, using the **resolved absolute path** (not the variable). Example format:

   ```
   Add this to ~/.claude/settings.json:

   {
     "statusLine": {
       "type": "command",
       "command": "bash <RESOLVED_PATH>/statusline-command.sh"
     }
   }
   ```

   Replace `<RESOLVED_PATH>` with the actual path from step 1.

3. Tell them: after saving, restart Claude Code for the statusline to appear.

4. Offer — as a single follow-up question — whether you should edit `~/.claude/settings.json` for them automatically. If they say yes:
   - Read `~/.claude/settings.json`
   - Merge the `statusLine` key (overwriting if present)
   - Preserve all other keys and formatting as best you can
   - Confirm what was changed

Keep the response short. No extra commentary beyond what's needed for the user to finish setup.
