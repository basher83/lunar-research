# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Claude Code plugin that implements a multi-agent research pipeline. It orchestrates 4 parallel researcher agents (GitHub, Tavily, DeepWiki, Exa) and a synthesizer agent to research topics across multiple sources.

## Commands

```bash
# Validate research report against schema
uv run scripts/validate-research-report.py <report.json>

# Run the research pipeline (from Claude Code)
/lunar-research "your query"
```

## Architecture

### Orchestration Flow

1. **Command** (`/lunar-research`) receives query, checks knowledge base cache
2. **Phase 1**: Dispatches 4 researcher agents in parallel via Task tool
3. **Phase 2**: Synthesizer agent combines findings after all researchers complete
4. **Phase 3**: Orchestrator adds codebase context and updates knowledge base index

### Agent Authority Hierarchy (for conflict resolution)

deepwiki (official docs) > tavily (community) > github (code) > exa (semantic)

### MCP Tool Prefixes

Each researcher uses plugin-scoped MCP tools:
- `mcp__plugin_lunar-research_github__*`
- `mcp__plugin_lunar-research_tavily__*`
- `mcp__plugin_lunar-research_deepwiki__*`
- `mcp__plugin_lunar-research_exa__*`

### Cache Structure

```
${CLAUDE_PLUGIN_ROOT}/cache/
├── index.json                    # Knowledge base index (tracked)
└── [normalized-query]/           # Per-query cache (gitignored)
    ├── github-report.json
    ├── tavily-report.json
    ├── deepwiki-report.json
    ├── exa-report.json
    └── synthesis.md
```

### Schema Validation

All researcher reports must conform to `schemas/research-report.schema.json`. The orchestrator validates each report before synthesis. Key enum values:
- `source.type`: repository | article | documentation | discussion | paper
- `source.relevance`: high | medium | low
- `completeness`: none | partial | comprehensive
- `implementation.maturity`: experimental | beta | production

### SessionStart Hook

The hook in `hooks/setup-mcp-keys.sh` substitutes environment variables (`GITHUB_TOKEN`, `TAVILY_API_KEY`, `EXA_API_KEY`) into `.mcp.json` at session start. Run `/mcp` to reconnect if keys change mid-session.
