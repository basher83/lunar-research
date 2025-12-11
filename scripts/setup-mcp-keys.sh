#!/usr/bin/env bash
# Setup script to substitute environment variables into the cached .mcp.json
#
# Usage:
#   ./scripts/setup-mcp-keys.sh
#
# Required environment variables:
#   TAVILY_API_KEY  - Your Tavily API key
#   EXA_API_KEY     - Your Exa API key
#   GITHUB_TOKEN    - Your GitHub token (optional, uses gh auth if available)
#
# Run this after installing/updating the lunar-research plugin.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
CACHE_DIR="$HOME/.claude/plugins/cache/lunar-claude/lunar-research/0.1.0"
SOURCE_MCP="$PLUGIN_ROOT/.mcp.json"
TARGET_MCP="$CACHE_DIR/.mcp.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Setting up MCP API keys for lunar-research plugin..."
echo ""

# Check for required env vars
missing=()

if [[ -z "${TAVILY_API_KEY:-}" ]]; then
    missing+=("TAVILY_API_KEY")
else
    echo -e "${GREEN}✓${NC} TAVILY_API_KEY is set"
fi

if [[ -z "${EXA_API_KEY:-}" ]]; then
    missing+=("EXA_API_KEY")
else
    echo -e "${GREEN}✓${NC} EXA_API_KEY is set"
fi

# GitHub token - try gh auth as fallback
if [[ -z "${GITHUB_TOKEN:-}" ]]; then
    if command -v gh &> /dev/null && gh auth status &> /dev/null; then
        export GITHUB_TOKEN="$(gh auth token)"
        echo -e "${GREEN}✓${NC} GITHUB_TOKEN obtained from gh auth"
    else
        missing+=("GITHUB_TOKEN")
    fi
else
    echo -e "${GREEN}✓${NC} GITHUB_TOKEN is set"
fi

echo ""

if [[ ${#missing[@]} -gt 0 ]]; then
    echo -e "${YELLOW}Warning:${NC} Missing environment variables:"
    for var in "${missing[@]}"; do
        echo -e "  ${RED}✗${NC} $var"
    done
    echo ""
    echo "Set them with:"
    for var in "${missing[@]}"; do
        echo "  export $var=your_key_here"
    done
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check source file exists
if [[ ! -f "$SOURCE_MCP" ]]; then
    echo -e "${RED}Error:${NC} Source .mcp.json not found at $SOURCE_MCP"
    exit 1
fi

# Create cache directory if needed
mkdir -p "$CACHE_DIR"

# Substitute environment variables and write to cache
echo "Substituting environment variables..."
envsubst < "$SOURCE_MCP" > "$TARGET_MCP"

echo ""
echo -e "${GREEN}Done!${NC} Updated $TARGET_MCP"
echo ""
echo "Restart Claude Code or run /mcp to reconnect MCP servers."
