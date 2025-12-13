#!/usr/bin/env bash
# SessionStart hook: Auto-substitute API keys in .mcp.json and migrate cache
#
# This hook runs at session start and ensures MCP API keys are properly
# configured by substituting environment variables into the cached .mcp.json
#
# Required environment variables:
#   TAVILY_API_KEY  - Tavily API key
#   EXA_API_KEY     - Exa API key
#   JINA_API_KEY    - Jina API key
#   GITHUB_TOKEN    - GitHub token (optional, uses gh auth if available)

set -euo pipefail

# --- Cache Migration ---
# Migrate cache from versioned plugin directory to persistent location
CACHE_DIR="${HOME}/.claude/research-cache/lunar-research"
OLD_CACHE="${CLAUDE_PLUGIN_ROOT}/cache"

if [[ ! -d "$CACHE_DIR" ]]; then
    mkdir -p "$CACHE_DIR"
    # Check for cache in old versioned location
    if [[ -d "$OLD_CACHE" && -f "$OLD_CACHE/index.json" ]]; then
        cp -r "$OLD_CACHE"/* "$CACHE_DIR/" 2>/dev/null || true
        echo "lunar-research: Migrated cache to persistent location"
    fi
fi

# --- MCP Key Substitution ---
MCP_FILE="${CLAUDE_PLUGIN_ROOT}/.mcp.json"

# Exit silently if no .mcp.json
[[ -f "$MCP_FILE" ]] || exit 0

# Check if substitution is needed (file contains ${VAR} patterns)
if ! grep -q '\${[A-Z_]*}' "$MCP_FILE" 2>/dev/null; then
    # Already substituted, nothing to do
    exit 0
fi

# Try to get GITHUB_TOKEN from gh auth if not set
if [[ -z "${GITHUB_TOKEN:-}" ]]; then
    if command -v gh &> /dev/null && gh auth status &> /dev/null 2>&1; then
        export GITHUB_TOKEN="$(gh auth token 2>/dev/null || true)"
    fi
fi

# Check which keys are missing
missing=()
[[ -z "${TAVILY_API_KEY:-}" ]] && missing+=("TAVILY_API_KEY")
[[ -z "${EXA_API_KEY:-}" ]] && missing+=("EXA_API_KEY")
[[ -z "${JINA_API_KEY:-}" ]] && missing+=("JINA_API_KEY")
[[ -z "${GITHUB_TOKEN:-}" ]] && missing+=("GITHUB_TOKEN")

# Substitute environment variables
envsubst < "$MCP_FILE" > "${MCP_FILE}.tmp"
mv "${MCP_FILE}.tmp" "$MCP_FILE"

# Output message for Claude (only if there were missing keys or we made changes)
if [[ ${#missing[@]} -gt 0 ]]; then
    echo "lunar-research: MCP keys configured. Missing: ${missing[*]}. Run /mcp to reconnect."
else
    echo "lunar-research: MCP API keys configured. Run /mcp to reconnect servers."
fi
