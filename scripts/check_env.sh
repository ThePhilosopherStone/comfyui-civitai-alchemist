#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=== Environment Check ==="
echo ""

EXIT_CODE=0

# Check virtual environment
if [ -d ".venv" ]; then
    echo -e "${GREEN}✓ Virtual environment exists${NC}"
else
    echo -e "${RED}✗ Virtual environment not found${NC}"
    EXIT_CODE=1
fi

# Activate virtual environment
source .venv/bin/activate 2>/dev/null || true

# Check Python version
PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
echo -e "${GREEN}✓ Python version: $PYTHON_VERSION${NC}"

# Check PyTorch
if python -c "import torch" 2>/dev/null; then
    TORCH_VERSION=$(python -c "import torch; print(torch.__version__)")
    echo -e "${GREEN}✓ PyTorch: $TORCH_VERSION${NC}"

    # Check CUDA
    if python -c "import torch; exit(0 if torch.cuda.is_available() else 1)" 2>/dev/null; then
        CUDA_VERSION=$(python -c "import torch; print(torch.version.cuda)")
        GPU_NAME=$(python -c "import torch; print(torch.cuda.get_device_name(0))")
        COMPUTE_CAP=$(python -c "import torch; cap=torch.cuda.get_device_capability(0); print(f'{cap[0]}.{cap[1]}')")
        echo -e "${GREEN}✓ CUDA: $CUDA_VERSION${NC}"
        echo -e "${GREEN}✓ GPU: $GPU_NAME${NC}"
        echo -e "${GREEN}✓ Compute Capability: $COMPUTE_CAP${NC}"

        if [[ $COMPUTE_CAP == "12.0" ]]; then
            echo -e "${BLUE}  → Blackwell architecture (sm_120) support OK${NC}"
        fi
    else
        echo -e "${YELLOW}! CUDA not available (CPU only mode)${NC}"
        echo -e "${YELLOW}  This may be a GPU passthrough issue in WSL2${NC}"
        EXIT_CODE=1
    fi
else
    echo -e "${RED}✗ PyTorch not installed${NC}"
    EXIT_CODE=1
fi

# Check Triton
if python -c "import triton" 2>/dev/null; then
    TRITON_VERSION=$(python -c "import triton; print(triton.__version__)")
    echo -e "${GREEN}✓ Triton: $TRITON_VERSION${NC}"

    if python -c "import triton; v=triton.__version__.split('.'); exit(0 if (int(v[0])>3 or (int(v[0])==3 and int(v[1])>=3)) else 1)" 2>/dev/null; then
        echo -e "${BLUE}  → Triton 3.3+ supports Blackwell architecture${NC}"
    else
        echo -e "${YELLOW}  ! Triton version < 3.3, may lack Blackwell optimizations${NC}"
    fi
else
    echo -e "${YELLOW}! Triton not installed${NC}"
fi

# Check ComfyUI
if [ -d "../ComfyUI" ]; then
    echo -e "${GREEN}✓ ComfyUI directory exists${NC}"
else
    echo -e "${RED}✗ ComfyUI directory not found${NC}"
    EXIT_CODE=1
fi

# Check symlink
if [ -L "../ComfyUI/custom_nodes/comfyui-civitai-alchemist" ]; then
    echo -e "${GREEN}✓ Custom node symlink created${NC}"
else
    echo -e "${YELLOW}! Custom node symlink not created${NC}"
fi

# Check environment variables
echo ""
echo "Environment variables check:"
if [ -n "$CUDA_MODULE_LOADING" ]; then
    echo -e "${GREEN}✓ CUDA_MODULE_LOADING=$CUDA_MODULE_LOADING${NC}"
else
    echo -e "${YELLOW}  CUDA_MODULE_LOADING not set (will be loaded automatically in run_comfyui.sh)${NC}"
fi

if [ -n "$TORCH_CUDA_ARCH_LIST" ]; then
    echo -e "${GREEN}✓ TORCH_CUDA_ARCH_LIST=$TORCH_CUDA_ARCH_LIST${NC}"
else
    echo -e "${YELLOW}  TORCH_CUDA_ARCH_LIST not set (will be loaded automatically in run_comfyui.sh)${NC}"
fi

# WSL2 specific check
echo ""
echo "WSL2 check:"
if command -v nvidia-smi >/dev/null 2>&1; then
    echo -e "${GREEN}✓ nvidia-smi available (GPU passthrough OK)${NC}"
else
    echo -e "${RED}✗ nvidia-smi not available (GPU passthrough issue)${NC}"
    EXIT_CODE=1
fi

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}=== Environment Check Complete - All OK! ===${NC}"
else
    echo -e "${YELLOW}=== Environment Check Complete - Some issues found ===${NC}"
    echo -e "${YELLOW}Please check items marked with ✗ or ! above${NC}"
fi

exit $EXIT_CODE
