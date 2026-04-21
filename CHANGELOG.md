# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2026-04-21

### Added
- `SessionStart` hook (`hooks/first-run-hint.sh`) that checks if the user has a `statusLine` configured in `~/.claude/settings.json`. If not, prints a `systemMessage` with the exact `/statusline please install and use this statusline: <resolved path>` line to paste. Silent once the user has any statusline configured, so it respects users who already picked a different one.

### Changed
- README install flow is now two commands (marketplace add + install). The hint appears automatically on next session; `/usage-statusline-setup` is still available as a manual trigger.

## [1.2.0] - 2026-04-21

### Changed
- `/usage-statusline-setup` now prints a ready-to-paste `/statusline please install and use this statusline: <path>` line, delegating the actual `settings.json` edit to Claude Code's built-in `/statusline` flow. Avoids reimplementing settings.json merging, handles quoting of paths with spaces, and aligns with Claude Code's native UX.

## [1.1.0] - 2026-04-21

### Added
- `/usage-statusline-setup` slash command that resolves `$CLAUDE_PLUGIN_ROOT` and prints the exact `settings.json` snippet to paste, with an offer to edit `~/.claude/settings.json` automatically.

### Changed
- README install flow now points to `/usage-statusline-setup` instead of instructing users to copy `${CLAUDE_PLUGIN_ROOT}` literally (which is not expanded inside user `settings.json`).

## [1.0.0] - 2026-04-21

### Added
- Initial release of `claude-usage-statusline`.
- Pace-aware coloring for 5-hour session rate limit (compares consumption rate vs time elapsed in the window).
- Pace-aware coloring for 7-day weekly rate limit.
- Absolute-threshold coloring for context window usage.
- Model + effort-level display, read from input JSON and `~/.claude/settings.json` (or `CLAUDE_CODE_EFFORT_LEVEL` env var).
- Relative time-left display for the 5-hour window (e.g. `2h 3min left`).
- Absolute day+time display for the weekly reset (e.g. `Resets Thu, 3:00PM`).
- POSIX-compatible script with GNU/BSD `date` detection for cross-platform use.
