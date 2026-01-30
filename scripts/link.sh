#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CUSTOM_NODE_DIR="../ComfyUI/custom_nodes/comfyui-civitai-alchemist"

echo -e "${YELLOW}Creating symlink to ComfyUI...${NC}"

# Remove old link
if [ -L "$CUSTOM_NODE_DIR" ]; then
    rm "$CUSTOM_NODE_DIR"
    echo "Removed old link"
fi

# Create new link
ln -s "$(pwd)" "$CUSTOM_NODE_DIR"

echo -e "${GREEN}✓ Symlink created:${NC}"
echo "  $(pwd)"
echo "  → $CUSTOM_NODE_DIR"
