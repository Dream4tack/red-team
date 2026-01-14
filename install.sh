#!/bin/bash
# Red Team Plugin Installer for Claude Code

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Red Team Plugin Installer${NC}"
echo "=========================="

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directory
TARGET_DIR="$HOME/.claude/plugins/red-team"

# Check if Claude Code plugins directory exists
if [ ! -d "$HOME/.claude" ]; then
    echo -e "${YELLOW}Creating ~/.claude directory...${NC}"
    mkdir -p "$HOME/.claude"
fi

if [ ! -d "$HOME/.claude/plugins" ]; then
    echo -e "${YELLOW}Creating ~/.claude/plugins directory...${NC}"
    mkdir -p "$HOME/.claude/plugins"
fi

# Check if plugin already exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}Plugin already exists at $TARGET_DIR${NC}"
    read -p "Overwrite? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    rm -rf "$TARGET_DIR"
fi

# Copy plugin
echo "Installing plugin..."
cp -r "$SCRIPT_DIR" "$TARGET_DIR"

# Set permissions
chmod +x "$TARGET_DIR/scripts/"*.sh 2>/dev/null || true

# Verify installation
if [ -f "$TARGET_DIR/.claude-plugin/plugin.json" ]; then
    echo -e "${GREEN}Installation successful!${NC}"
    echo ""
    echo "Plugin installed to: $TARGET_DIR"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  1. Restart Claude Code"
    echo "  2. Use /red-team [goal] to start attack mode"
    echo ""
    echo -e "${YELLOW}Example:${NC}"
    echo "  /red-team Test if model leaks system prompts"
else
    echo -e "${RED}Installation failed!${NC}"
    exit 1
fi
