#!/bin/bash
set -e

echo "=== ComfyUI Civitai Alchemist Development Environment Setup ==="
echo ""

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Check required tools
echo -e "${YELLOW}[1/10] Checking required tools...${NC}"
command -v python3 >/dev/null 2>&1 || { echo -e "${RED}Error: Python 3.10+ required${NC}"; exit 1; }
command -v uv >/dev/null 2>&1 || { echo -e "${RED}Error: uv package manager required${NC}"; exit 1; }
command -v git >/dev/null 2>&1 || { echo -e "${RED}Error: git required${NC}"; exit 1; }
command -v nvidia-smi >/dev/null 2>&1 || { echo -e "${RED}Error: nvidia-smi unavailable, please verify GPU driver installation${NC}"; exit 1; }
echo -e "${GREEN}✓ Tools check completed${NC}"

# 2. Verify GPU (RTX 5090)
echo -e "${YELLOW}[2/10] Verifying GPU environment...${NC}"
GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
if [[ $GPU_NAME == *"5090"* ]]; then
    echo -e "${GREEN}✓ Detected GPU: $GPU_NAME${NC}"
else
    echo -e "${YELLOW}! Warning: Detected GPU is not RTX 5090: $GPU_NAME${NC}"
    echo -e "${YELLOW}  Performance optimizations may not fully apply${NC}"
fi

# 3. Create virtual environment
echo -e "${YELLOW}[3/10] Creating virtual environment...${NC}"
if [ ! -d ".venv" ]; then
    uv venv .venv --python 3.12
    echo -e "${GREEN}✓ Virtual environment created${NC}"
else
    echo -e "${GREEN}✓ Virtual environment already exists${NC}"
fi

# 4. Activate virtual environment
echo -e "${YELLOW}[4/10] Activating virtual environment...${NC}"
source .venv/bin/activate
echo -e "${GREEN}✓ Virtual environment activated${NC}"

# 5. Clone ComfyUI repository
echo -e "${YELLOW}[5/10] Downloading ComfyUI repository...${NC}"
COMFYUI_DIR="../ComfyUI"
if [ ! -d "$COMFYUI_DIR" ]; then
    cd ..
    git clone https://github.com/comfyanonymous/ComfyUI.git
    cd comfyui-civitai-alchemist
    echo -e "${GREEN}✓ ComfyUI downloaded${NC}"
else
    echo -e "${GREEN}✓ ComfyUI already exists${NC}"
fi

# 6. Create symlink: ComfyUI uses our virtual environment
echo -e "${YELLOW}[6/10] Setting up ComfyUI virtual environment link...${NC}"
if [ -L "$COMFYUI_DIR/.venv" ]; then
    rm "$COMFYUI_DIR/.venv"
fi
if [ -e "$COMFYUI_DIR/.venv" ] && [ ! -L "$COMFYUI_DIR/.venv" ]; then
    echo -e "${YELLOW}! ComfyUI has existing virtual environment, renaming to .venv.backup${NC}"
    mv "$COMFYUI_DIR/.venv" "$COMFYUI_DIR/.venv.backup"
fi
ln -s "$(pwd)/.venv" "$COMFYUI_DIR/.venv"
echo -e "${GREEN}✓ Virtual environment link created${NC}"

# 7. Install ComfyUI dependencies with PyTorch CUDA 13.0
echo -e "${YELLOW}[7/10] Installing ComfyUI dependencies and PyTorch with CUDA 13.0...${NC}"
echo -e "${BLUE}Using CUDA 13.0 index to install PyTorch...${NC}"
if [ -f "$COMFYUI_DIR/requirements.txt" ]; then
    UV_TORCH_BACKEND=cu130 uv pip install -r "$COMFYUI_DIR/requirements.txt"
    echo -e "${GREEN}✓ ComfyUI dependencies and PyTorch (cu130) installed${NC}"
else
    echo -e "${YELLOW}! ComfyUI requirements.txt not found, skipping${NC}"
fi

# 8. Install project dependencies
echo -e "${YELLOW}[8/10] Installing project dependencies...${NC}"
uv pip install -e .
echo -e "${GREEN}✓ Project dependencies installed${NC}"

# 9. Create custom_nodes directory and link
echo -e "${YELLOW}[9/10] Setting up custom node link...${NC}"
mkdir -p "$COMFYUI_DIR/custom_nodes"
bash scripts/link.sh
echo -e "${GREEN}✓ Custom node link created${NC}"

# 10. Verify installation
echo -e "${YELLOW}[10/10] Verifying installation...${NC}"
bash scripts/check_env.sh

echo ""
echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Start ComfyUI: ${YELLOW}bash scripts/run_comfyui.sh${NC}"
echo "  2. Open from Windows browser: ${YELLOW}http://localhost:8188${NC}"
echo "  3. Modify files in nodes/ directory during development"
echo "  4. Restart ComfyUI to see changes"
echo "  5. (Optional) Run performance test: ${YELLOW}bash scripts/benchmark.sh${NC}"
echo ""
echo -e "${BLUE}Environment variables configured in .env file, run_comfyui.sh will load automatically${NC}"
echo ""
