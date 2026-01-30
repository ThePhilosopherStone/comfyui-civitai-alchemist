#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=== ComfyUI Attention Backend Performance Test ==="
echo ""

# Activate virtual environment
source .venv/bin/activate

echo -e "${BLUE}Detecting available Attention backends:${NC}"
echo ""

# Check SageAttention
if python -c "import sageattention" 2>/dev/null; then
    echo -e "${GREEN}✓ SageAttention available${NC}"
    HAS_SAGE=1
else
    echo -e "${YELLOW}✗ SageAttention not available${NC}"
    HAS_SAGE=0
fi

# Check Flash Attention
if python -c "import flash_attn" 2>/dev/null; then
    echo -e "${GREEN}✓ Flash Attention available${NC}"
    HAS_FLASH=1
else
    echo -e "${YELLOW}✗ Flash Attention not available${NC}"
    HAS_FLASH=0
fi

# PyTorch SDPA always available (PyTorch 2.0+)
echo -e "${GREEN}✓ PyTorch SDPA available (baseline)${NC}"

echo ""
echo -e "${BLUE}ComfyUI will automatically select in this priority order:${NC}"
echo "  1. Flash Attention v3 (if available)"
echo "  2. Flash Attention v2 (if available)"
echo "  3. SageAttention (if available)"
echo "  4. PyTorch SDPA"
echo "  5. xFormers (if available)"
echo ""

# Show expected backend
if [ $HAS_FLASH -eq 1 ]; then
    echo -e "${GREEN}→ ComfyUI expected to use: Flash Attention${NC}"
elif [ $HAS_SAGE -eq 1 ]; then
    echo -e "${GREEN}→ ComfyUI expected to use: SageAttention${NC}"
else
    echo -e "${YELLOW}→ ComfyUI expected to use: PyTorch SDPA${NC}"
fi

echo ""
echo -e "${BLUE}Performance reference (relative to no optimization):${NC}"
echo "  • SageAttention: ${GREEN}1.5-2.0x speedup${NC}"
echo "  • Flash Attention: ${GREEN}1.5-2.0x speedup${NC}"
echo "  • PyTorch SDPA: ${GREEN}1.2-1.5x speedup${NC}"
echo ""

echo -e "${YELLOW}Tip: To see actual backend in use, start ComfyUI and check console output${NC}"
echo -e "${YELLOW}Run: bash scripts/run_comfyui.sh${NC}"
echo ""

# Simple GPU memory and compute test
echo -e "${BLUE}Running simple GPU test...${NC}"
python << 'EOF'
import torch
import time

if torch.cuda.is_available():
    device = torch.device("cuda")
    print(f"GPU: {torch.cuda.get_device_name(0)}")
    print(f"Memory: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB")

    # Simple matrix multiplication test
    size = 4096
    print(f"\nRunning {size}x{size} matrix multiplication test...")

    a = torch.randn(size, size, device=device)
    b = torch.randn(size, size, device=device)

    # Warm up
    for _ in range(3):
        c = torch.matmul(a, b)
    torch.cuda.synchronize()

    # Benchmark
    start = time.time()
    for _ in range(10):
        c = torch.matmul(a, b)
    torch.cuda.synchronize()
    elapsed = time.time() - start

    tflops = (2 * size**3 * 10) / elapsed / 1e12
    print(f"Performance: {tflops:.2f} TFLOPS")
    print(f"Average time: {elapsed/10*1000:.2f} ms")
else:
    print("CUDA not available")
EOF

echo ""
echo -e "${GREEN}=== Test Complete ===${NC}"
