#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}Starting ComfyUI...${NC}"

# Load environment variables
if [ -f ".env" ]; then
    source .env
    echo -e "${GREEN}✓ Loaded .env environment variables${NC}"
fi

# Switch to ComfyUI directory
cd ../ComfyUI

# Activate virtual environment
source .venv/bin/activate

# Display information
echo -e "${BLUE}ComfyUI will start at:${NC}"
echo -e "  Local: ${GREEN}http://127.0.0.1:8188${NC}"
echo -e "  Windows: ${GREEN}http://localhost:8188${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
echo ""

# Start ComfyUI (WSL2: use --listen 0.0.0.0 to allow Windows access)
python main.py --listen 0.0.0.0

# Return to original directory
cd - > /dev/null
