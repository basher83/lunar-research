# Changelog

## [1.0.0] - 2025-12-11

### 🚀 Features

- Migrate research-pipeline plugin from lunar-claude
- Add name field to plugin command for registration
- Add MCP server configuration with environment variables
- *(hooks)* Add SessionStart hook for automatic MCP API key setup
- *(scripts)* Add manual setup script for MCP API keys

### 🐛 Bug Fixes

- *(plugin)* Add agents directory path to plugin configuration
- *(agents)* Add required model and color fields to agent definitions
- *(command)* Update subagent references to use namespaced names
- *(plugin)* Use array of agent file paths instead of directory
- *(agents)* Use correct plugin-prefixed MCP tool names
- *(agents)* Add explicit enum constraints to prevent schema validation errors
- *(validation)* Collect all schema errors instead of failing fast
- *(docs)* Correct slash command in usage example

### 🚜 Refactor

- Rename validate_research_report.py to kebab-case
- Rename plugin from research-pipeline to lunar-research

### 📚 Documentation

- Enhance README with setup guide and MCP server documentation
- *(command)* Add error diagnosis section for common failures
- Document SessionStart hook and update MCP tool prefixes
- Apply Strunk's writing principles to README
- Add CLAUDE.md for Claude Code context

### ⚙️ Miscellaneous Tasks

- Add `mise` for project tooling, `pre-commit` hooks for code quality, and `git-cliff` for changelog generation.
- Add *.local.md pattern to gitignore
