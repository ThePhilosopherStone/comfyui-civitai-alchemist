"""
Investigate Civitai API responses for given image IDs.

Fetches data from both REST API and tRPC endpoint, then produces a
structured comparison for analysis.

Usage:
    python scripts/investigate_apis.py 119018511 118854383 118713023
    python scripts/investigate_apis.py 119018511 118854383 --output output/investigation.md
"""

import argparse
import json
import os
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

try:
    from dotenv import load_dotenv
except ImportError:
    load_dotenv = None

from civitai_utils.civitai_api import CivitaiAPI


def parse_image_id(raw: str) -> int:
    """Accept bare ID or full Civitai URL."""
    if raw.isdigit():
        return int(raw)
    match = re.search(r"civitai\.com/images/(\d+)", raw)
    if match:
        return int(match.group(1))
    raise ValueError(f"Cannot parse image ID from: {raw}")


def extract_loras_from_prompt(prompt: str) -> list[dict]:
    """Parse <lora:name:weight> tags from the prompt string."""
    results = []
    for match in re.finditer(r"<lora:([^:>]+):([^>]+)>", prompt):
        name = match.group(1)
        try:
            weight = float(match.group(2))
        except ValueError:
            weight = None
        results.append({"name": name, "weight": weight})
    return results


def fetch_image_data(api: CivitaiAPI, image_id: int) -> dict:
    """Fetch all available data for a single image from both APIs."""
    result = {
        "image_id": image_id,
        "rest": {
            "meta_resources": [],
            "meta_hashes": {},
            "civitai_resources": [],
            "model_name": None,
            "model_hash": None,
            "vae": None,
            "prompt_loras": [],
            "error": None,
        },
        "trpc": {
            "resources": [],
            "error": None,
        },
    }

    # --- REST API ---
    try:
        img = api.get_image_metadata(image_id)
        if img is None:
            result["rest"]["error"] = "Image not found"
        else:
            meta = img.get("meta") or {}
            if "meta" in meta and isinstance(meta["meta"], dict):
                meta = meta["meta"]

            result["rest"]["meta_resources"] = meta.get("resources", [])
            result["rest"]["meta_hashes"] = meta.get("hashes", {})
            result["rest"]["civitai_resources"] = meta.get("civitaiResources", [])
            result["rest"]["model_name"] = meta.get("Model")
            result["rest"]["model_hash"] = meta.get("Model hash")
            result["rest"]["vae"] = meta.get("VAE")
            result["rest"]["prompt_loras"] = extract_loras_from_prompt(
                meta.get("prompt", "")
            )
    except Exception as e:
        result["rest"]["error"] = str(e)

    # --- tRPC API ---
    try:
        gen_data = api.get_image_generation_data(image_id)
        if gen_data is None:
            result["trpc"]["error"] = "No generation data"
        else:
            result["trpc"]["resources"] = gen_data.get("resources", [])
    except Exception as e:
        result["trpc"]["error"] = str(e)

    return result


def format_markdown(all_data: list[dict]) -> str:
    """Format investigation results as a markdown report."""
    lines = []
    lines.append("# Civitai API Investigation Report\n")
    lines.append("Comparing REST `/api/v1/images` vs tRPC `image.getGenerationData`.\n")

    for data in all_data:
        image_id = data["image_id"]
        rest = data["rest"]
        trpc = data["trpc"]

        lines.append(f"---\n")
        lines.append(f"## Image {image_id}\n")
        lines.append(f"URL: https://civitai.com/images/{image_id}\n")

        # REST error
        if rest["error"]:
            lines.append(f"**REST Error**: {rest['error']}\n")

        # Model info
        if rest["model_name"] or rest["model_hash"] or rest["vae"]:
            lines.append("### Model Info (REST)\n")
            if rest["model_name"]:
                lines.append(f"- Model: `{rest['model_name']}`")
            if rest["model_hash"]:
                lines.append(f"- Model hash: `{rest['model_hash']}`")
            if rest["vae"]:
                lines.append(f"- VAE: `{rest['vae']}`")
            lines.append("")

        # Prompt LoRAs
        if rest["prompt_loras"]:
            lines.append("### LoRAs from prompt (parsed `<lora:name:weight>`)\n")
            lines.append("| name | weight |")
            lines.append("|------|--------|")
            for lora in rest["prompt_loras"]:
                lines.append(f"| `{lora['name']}` | {lora['weight']} |")
            lines.append("")

        # REST meta.resources
        lines.append("### REST `meta.resources`\n")
        if rest["meta_resources"]:
            lines.append("| name | type | hash | weight |")
            lines.append("|------|------|------|--------|")
            for r in rest["meta_resources"]:
                name = r.get("name", "-")
                rtype = r.get("type", "-")
                rhash = r.get("hash") or "-"
                weight = r.get("weight") if r.get("weight") is not None else "-"
                lines.append(f"| `{name}` | {rtype} | `{rhash}` | {weight} |")
        else:
            lines.append("(empty)")
        lines.append("")

        # REST meta.hashes
        lines.append("### REST `meta.hashes`\n")
        if rest["meta_hashes"]:
            lines.append("| key | hash |")
            lines.append("|-----|------|")
            for k, v in rest["meta_hashes"].items():
                lines.append(f"| `{k}` | `{v}` |")
        else:
            lines.append("(empty)")
        lines.append("")

        # REST civitaiResources
        lines.append("### REST `meta.civitaiResources`\n")
        if rest["civitai_resources"]:
            lines.append("| type | modelVersionId | modelName | weight |")
            lines.append("|------|----------------|-----------|--------|")
            for cr in rest["civitai_resources"]:
                ctype = cr.get("type", "-")
                vid = cr.get("modelVersionId", "-")
                cname = cr.get("modelName", "-")
                weight = cr.get("weight") if cr.get("weight") is not None else "-"
                lines.append(f"| {ctype} | {vid} | {cname} | {weight} |")
        else:
            lines.append("(empty)")
        lines.append("")

        # tRPC resources
        lines.append("### tRPC `resources`\n")
        if trpc["error"]:
            lines.append(f"**Error**: {trpc['error']}\n")
        elif trpc["resources"]:
            lines.append(
                "| modelVersionId | modelName | modelType | strength | modelId | baseModel |"
            )
            lines.append(
                "|----------------|-----------|-----------|----------|---------|-----------|"
            )
            for r in trpc["resources"]:
                vid = r.get("modelVersionId", "-")
                name = r.get("modelName", "-")
                mtype = r.get("modelType", "-")
                strength = r.get("strength") if r.get("strength") is not None else "-"
                mid = r.get("modelId", "-")
                base = r.get("baseModel", "-")
                # Escape pipe characters in names
                name = name.replace("|", "\\|")
                lines.append(
                    f"| {vid} | {name} | {mtype} | {strength} | {mid} | {base} |"
                )
        else:
            lines.append("(empty)")
        lines.append("")

        # Cross-reference analysis
        lines.append("### Cross-reference\n")

        rest_types = {}
        for r in rest["meta_resources"]:
            t = r.get("type", "unknown")
            if t == "model":
                t = "checkpoint"
            rest_types.setdefault(t, []).append(r)

        trpc_types = {}
        for r in trpc.get("resources", []):
            t = r.get("modelType", "unknown").lower()
            if t in ("checkpoint", "model"):
                t = "checkpoint"
            trpc_types.setdefault(t, []).append(r)

        civitai_version_ids = {
            cr.get("modelVersionId")
            for cr in rest["civitai_resources"]
            if cr.get("modelVersionId")
        }
        trpc_version_ids = {
            r.get("modelVersionId")
            for r in trpc.get("resources", [])
            if r.get("modelVersionId")
        }

        all_types = sorted(set(list(rest_types.keys()) + list(trpc_types.keys())))
        for t in all_types:
            rc = len(rest_types.get(t, []))
            tc = len(trpc_types.get(t, []))
            lines.append(f"- **{t}**: REST={rc}, tRPC={tc}")

        if civitai_version_ids and trpc_version_ids:
            if civitai_version_ids == trpc_version_ids:
                lines.append(
                    f"- civitaiResources vs tRPC version IDs: **identical** ({len(civitai_version_ids)} entries)"
                )
            else:
                only_civitai = civitai_version_ids - trpc_version_ids
                only_trpc = trpc_version_ids - civitai_version_ids
                if only_civitai:
                    lines.append(
                        f"- Only in civitaiResources: {only_civitai}"
                    )
                if only_trpc:
                    lines.append(f"- Only in tRPC: {only_trpc}")

        # Check for REST entries that might not match any tRPC entry
        rest_only_names = []
        for r in rest["meta_resources"]:
            rname = r.get("name", "")
            matched = False
            for tr in trpc.get("resources", []):
                trname = tr.get("modelName", "")
                if (
                    rname.lower() in trname.lower()
                    or trname.lower() in rname.lower()
                ):
                    matched = True
                    break
            if not matched:
                rest_only_names.append(rname)
        if rest_only_names:
            lines.append(
                f"- REST entries with no obvious tRPC name match: {rest_only_names}"
            )

        lines.append("")

    return "\n".join(lines)


def main():
    if load_dotenv:
        load_dotenv()

    parser = argparse.ArgumentParser(
        description="Investigate Civitai REST vs tRPC API responses"
    )
    parser.add_argument(
        "ids",
        nargs="+",
        help="Image IDs or Civitai URLs",
    )
    parser.add_argument(
        "--output",
        "-o",
        default="output/investigation.md",
        help="Output markdown file (default: output/investigation.md)",
    )
    parser.add_argument(
        "--api-key",
        default=None,
        help="Civitai API key (or set CIVITAI_API_KEY env var)",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Also save raw JSON data alongside the markdown",
    )
    args = parser.parse_args()

    # Parse IDs
    image_ids = []
    for raw in args.ids:
        try:
            image_ids.append(parse_image_id(raw))
        except ValueError as e:
            print(f"Warning: {e}, skipping", file=sys.stderr)

    if not image_ids:
        print("No valid image IDs provided.", file=sys.stderr)
        sys.exit(1)

    print(f"Investigating {len(image_ids)} image(s)...\n")

    api_key = args.api_key or os.environ.get("CIVITAI_API_KEY")
    api = CivitaiAPI(api_key=api_key)

    all_data = []
    for image_id in image_ids:
        print(f"  [{image_id}] fetching...", end=" ", flush=True)
        data = fetch_image_data(api, image_id)
        rest_count = len(data["rest"]["meta_resources"])
        civitai_count = len(data["rest"]["civitai_resources"])
        trpc_count = len(data["trpc"]["resources"])
        print(
            f"REST resources={rest_count}, civitaiResources={civitai_count}, tRPC={trpc_count}"
        )
        all_data.append(data)

    # Write markdown
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    md = format_markdown(all_data)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(md)
    print(f"\nMarkdown report saved to {output_path}")

    # Optionally save raw JSON
    if args.json:
        json_path = output_path.with_suffix(".json")
        with open(json_path, "w", encoding="utf-8") as f:
            json.dump(all_data, f, indent=2, ensure_ascii=False)
        print(f"Raw JSON saved to {json_path}")


if __name__ == "__main__":
    main()
