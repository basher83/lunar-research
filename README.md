# lunar-research

Multi-agent research pipeline for Claude Code. Orchestrates 4 specialized researcher agents
(GitHub, Tavily, DeepWiki, Exa) to gather information from multiple sources, then synthesizes
findings with source authority hierarchy.

## Installation

```bash
/plugin install research-pipeline@lunar-research
```

Or add the marketplace:

```bash
/plugin marketplace add basher83/lunar-research
```

## Setup

After installation, configure your API keys. The plugin uses environment variables for authentication.

### Option 1: Shell Profile (Recommended)

Add to `~/.bashrc`, `~/.zshrc`, or your shell's config:

```bash
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"
export TAVILY_API_KEY="tvly-xxxxxxxxxxxx"
export EXA_API_KEY="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

Restart your terminal or run `source ~/.bashrc`.

### Option 2: mise (Project-scoped)

Create `.mise.local.toml` in your project directory:

```toml
[env]
GITHUB_TOKEN = "ghp_xxxxxxxxxxxx"
TAVILY_API_KEY = "tvly-xxxxxxxxxxxx"
EXA_API_KEY = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

Run `mise trust` to activate. The `.local.toml` suffix is gitignored by default.

### Getting API Keys

- **GitHub**: [Create a personal access token](https://github.com/settings/tokens)
- **Tavily**: [Get API key](https://tavily.com/)
- **Exa**: [Get API key](https://exa.ai/)

## Usage

```bash
/research-pipeline:lunar-research "your research query"
```

## Features

- **4 Parallel Researchers**: GitHub (code/repos), Tavily (web/tutorials), DeepWiki (official docs),
  Exa (semantic search)
- **Synthesizer Agent**: Combines findings using authority hierarchy (official docs > community > code > semantic)
- **Knowledge Base Caching**: 30-day TTL cache shared across projects
- **Schema Validation**: JSON Schema for standardized report format

## Components

### Command

- `lunar-research` - Main orchestrator command

### Agents

| Agent | Purpose | MCP Tools |
|-------|---------|-----------|
| `github-researcher` | Find repositories and code patterns | GitHub MCP |
| `tavily-researcher` | Find tutorials and community content | Tavily MCP |
| `deepwiki-researcher` | Find official documentation | DeepWiki MCP |
| `exa-researcher` | Semantic search for related content | Exa MCP |
| `synthesizer-agent` | Combine findings into synthesis | None |

### Schemas

- `research-report.schema.json` - JSON Schema for researcher output format

### Scripts

- `validate-research-report.py` - Validate reports against schema

## Cache Structure

Research results are cached at plugin level, shared across all projects:

```text
${CLAUDE_PLUGIN_ROOT}/cache/
├── index.json                    # Knowledge base index (tracked in git)
└── [normalized-query]/           # Per-query cache (gitignored)
    ├── github-report.json
    ├── tavily-report.json
    ├── deepwiki-report.json
    ├── exa-report.json
    └── synthesis.md
```

## MCP Servers

The plugin bundles `.mcp.json` with preconfigured MCP servers:

| Server | Tools Prefix | Auth |
|--------|--------------|------|
| GitHub | `mcp__github__*` | `GITHUB_TOKEN` |
| Tavily | `mcp__tavily__*` | `TAVILY_API_KEY` |
| DeepWiki | `mcp__deepwiki__*` | None |
| Exa | `mcp__exa__*` | `EXA_API_KEY` |

## License

See [MIT](LICENSE)
