# ComfyUI Civitai Alchemist

Paste a Civitai image URL, automatically fetch generation parameters, download required models, and generate a ComfyUI workflow to reproduce the image.

## Features

1. **Fetch Metadata** — Extract prompt, model, LoRA, sampler, and other generation parameters from a Civitai image page
2. **Resolve Models** — Look up model download URLs via hash/name
3. **Download Models** — Automatically download checkpoint, LoRA, VAE, embeddings, and upscaler models to the appropriate ComfyUI directories
4. **Generate Workflow** — Produce a ComfyUI API-format workflow JSON, ready to submit

## Supported Workflows

- **txt2img** — Standard single-pass generation with optional LoRA(s)
- **txt2img-hires** — Two-pass generation with upscaler model (hires fix)
- CLIP skip, custom VAE, embeddings (textual inversion), multi-LoRA chains

## Requirements

- Python 3.10–3.12
- A working [ComfyUI](https://github.com/comfyanonymous/ComfyUI) installation
- [uv](https://docs.astral.sh/uv/) package manager (recommended) or pip
- A [Civitai API key](https://civitai.com/user/account) (free, required for downloading models)

## Installation

```bash
# Clone the repository
git clone https://github.com/user/comfyui-civitai-alchemist.git
cd comfyui-civitai-alchemist

# Create virtual environment and install dependencies
uv venv .venv
uv pip install -e .

# Set up environment variables
cp .env.example .env
# Edit .env — fill in your Civitai API key and models directory path
```

## Usage

### One-shot (recommended)

```bash
# Full pipeline: fetch → resolve → download → generate workflow
# (models-dir is read from MODELS_DIR in .env, or pass --models-dir)
.venv/bin/python -m pipeline.reproduce https://civitai.com/images/116872916

# Generate workflow and submit to running ComfyUI
.venv/bin/python -m pipeline.reproduce https://civitai.com/images/116872916 --submit

# Skip download (models already exist)
.venv/bin/python -m pipeline.reproduce https://civitai.com/images/116872916 --skip-download
```

### Step by step (for debugging)

Each step produces a JSON file you can inspect:

```bash
# Step 1: Fetch image metadata
.venv/bin/python -m pipeline.fetch_metadata https://civitai.com/images/116872916
# → output/metadata.json

# Step 2: Resolve model download URLs
.venv/bin/python -m pipeline.resolve_models
# → output/resources.json

# Step 3: Download models (preview first with --dry-run)
.venv/bin/python -m pipeline.download_models --dry-run
.venv/bin/python -m pipeline.download_models
# → model files saved to ComfyUI/models/

# Step 4: Generate ComfyUI workflow
.venv/bin/python -m pipeline.generate_workflow
# → output/workflow.json

# Step 4b: Generate and submit to ComfyUI
.venv/bin/python -m pipeline.generate_workflow --submit
```

### Options

| Option | Description |
|--------|-------------|
| `--models-dir PATH` | Path to your ComfyUI models directory (or set `MODELS_DIR` in `.env`) |
| `--submit` | Submit the generated workflow to a running ComfyUI instance |
| `--comfyui-url URL` | ComfyUI server URL (default: `http://127.0.0.1:8188`) |
| `--skip-download` | Skip model download step |
| `--output-dir DIR` | Output directory for JSON files (default: `output`) |
| `--api-key KEY` | Civitai API key (or set `CIVITAI_API_KEY` in `.env`) |

### How it works with ComfyUI

This tool is **independent** from ComfyUI — it does not need to be installed inside ComfyUI. It interacts with ComfyUI in two ways:

1. **Model directory**: Downloads models directly into your ComfyUI `models/` subdirectories (checkpoints, loras, vae, embeddings, upscale_models)
2. **HTTP API** (optional): When using `--submit`, sends the generated workflow to ComfyUI's API endpoint for execution

You can also use the generated `output/workflow.json` manually — load it into ComfyUI's web interface or submit it via any API client.

## Project Structure

```
comfyui-civitai-alchemist/
├── pipeline/                   # Main pipeline scripts
│   ├── fetch_metadata.py       # Step 1: URL → metadata.json
│   ├── resolve_models.py       # Step 2: metadata → resources.json
│   ├── download_models.py      # Step 3: download model files
│   ├── generate_workflow.py    # Step 4: generate workflow.json
│   ├── sampler_map.py          # Civitai ↔ ComfyUI sampler name mapping
│   └── reproduce.py            # One-shot runner (all steps)
├── utils/
│   ├── civitai_api.py          # Civitai API client
│   └── model_manager.py        # Model download & directory management
├── output/                     # Pipeline output (gitignored)
│   ├── metadata.json
│   ├── resources.json
│   └── workflow.json
├── .env                        # Environment variables (gitignored)
├── .env.example                # .env template
└── pyproject.toml              # Project dependencies
```

## Development Setup

If you want to set up a full development environment (including ComfyUI and PyTorch with CUDA), see the setup script:

```bash
bash scripts/setup.sh
```

This will install PyTorch with CUDA support, clone ComfyUI, set up symlinks, and configure the full development environment. See [CLAUDE.md](CLAUDE.md) for development details.

## Not Yet Supported

- img2img / inpainting
- ControlNet
- Non-standard ComfyUI nodes

## References

- [Civitai API Documentation](https://github.com/civitai/civitai/wiki/REST-API-Reference)
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI)

## License

MIT
