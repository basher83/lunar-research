## [1.1.0] - 2025-12-13

### 🚀 Features

- *(commands)* Add cache listing and namespace commands
- *(agents)* Add Jina researcher agent
- *(schema)* Add jina to researcher enum
- *(orchestration)* Integrate Jina researcher
- *(config)* Add Jina SSE configuration and update plugin version
- *(validation)* Add JINA_API_KEY validation to setup scripts

### 🐛 Bug Fixes

- *(commands)* Move commands to root for proper plugin namespacing
- *(mcp)* Update Jina SSE URL to include additional query parameters

### 📚 Documentation

- Add architecture infographics to README
- Add Gemini-specific documentation
- Update README and CLAUDE for 5 researchers
- Add JINA_API_KEY to all documentation

### 🎨 Styling

- Add trailing newlines to JSON files

### ⚙️ Miscellaneous Tasks

- *(plugin)* Bump version to 1.0.2 in plugin.json
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
- *(release)* Prepare v1.0.0
