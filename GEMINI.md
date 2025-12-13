# lunar-research

**lunar-research** is a multi-agent research pipeline designed for Claude Code and compatible with Gemini via the Model Context Protocol (MCP). It orchestrates four specialized researcher agents and synthesizes their findings into a comprehensive report.

## Project Overview

*   **Goal:** Automate comprehensive technical research using specialized agents.
*   **Agents:**
    1.  **GitHub:** Searches for code repositories and patterns.
    2.  **Tavily:** Searches for tutorials and community content.
    3.  **DeepWiki:** Searches for official documentation.
    4.  **Exa:** Performs semantic searches for related content.
    5.  **Synthesizer:** Aggregates findings based on an authority hierarchy.
*   **Key Tech:** Python 3.13, `uv`, `mise`, MCP (Model Context Protocol).

## Environment Setup

This project uses `mise` for tool management and `uv` for Python dependency management.

1.  **Tools:** Ensure `mise` is installed. The configuration is in `mise.toml`.
2.  **Python:** Python 3.13 is managed by `mise` and `uv`. Do not manually create virtual environments; `mise` handles `.venv`.
3.  **API Keys:** The following environment variables are required for the agents:
    *   `GITHUB_TOKEN`
    *   `TAVILY_API_KEY`
    *   `EXA_API_KEY`
    *   `JINA_API_KEY`

    These are injected into the MCP configuration (`.mcp.json`) via session hooks.

## Key Commands

### Research Operations

*   **Run Research:**
    ```bash
    /lunar-research:run "your detailed query"
    ```
*   **View Cache:**
    ```bash
    /lunar-research:cache
    # Or for detailed status:
    /lunar-research:cache --detailed
    ```

### Development & Validation

*   **Validate a Report:**
    Use the provided script to check if a generated report matches the JSON schema.
    ```bash
    uv run scripts/validate-research-report.py path/to/report.json
    ```
*   **Lint Markdown:**
    ```bash
    mise run markdown-lint
    ```
*   **Fix Markdown:**
    ```bash
    mise run markdown-fix
    ```

## Architecture & Structure

*   **`agents/`**: Contains the definitions and prompts for each agent (e.g., `synthesizer-agent.md`).
*   **`cache/`**: Stores research results.
    *   `index.json`: Tracks cached queries.
    *   `[normalized-query]/`: Subdirectories containing individual agent reports (`*-report.json`) and the final `synthesis.md`.
*   **`schemas/`**: JSON schemas for data validation (`research-report.schema.json`).
*   **`scripts/`**: Utility scripts (e.g., validation, setup).
*   **`commands/`**: Documentation for available plugin commands.

### Authority Hierarchy

When synthesizing findings, the synthesizer agent resolves conflicts using this hierarchy:
1.  **DeepWiki** (Official Docs) - *Highest Authority*
2.  **Tavily** (Community/Tutorials)
3.  **GitHub** (Code Implementation)
4.  **Exa** (Semantic Search) - *Lowest Authority*

## Development Workflow

1.  **Modify Agents:** Edit the markdown files in `agents/` to change prompts or behaviors.
2.  **Update Schemas:** If data structures change, update `schemas/research-report.schema.json`.
3.  **Validate:** Always run `uv run scripts/validate-research-report.py` on sample outputs to ensure schema compliance.
