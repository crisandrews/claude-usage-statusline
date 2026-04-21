# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
