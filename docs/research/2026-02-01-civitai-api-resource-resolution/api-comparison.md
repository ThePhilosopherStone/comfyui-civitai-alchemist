# REST API vs tRPC API Comparison

Comparing `GET /api/v1/images?imageId={id}` (meta.resources, meta.hashes, meta.civitaiResources)
with `GET /api/trpc/image.getGenerationData` (resources) for the same images.

---

## Image 119018511

### REST `meta.resources`

| name | type | hash | weight |
|------|------|------|--------|
| glitter_dress_ilxl_goofy | lora | 07b3719602d2 | 1 |
| prefect_illustrious_v4.fp16 | model | 462cf8610a | - |

### REST `meta.hashes`

| key | hash |
|-----|------|
| vae | 235745af8d |
| model | 462cf8610a |
| lora:glitter_dress_ilxl_goofy | 07b3719602d2 |

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId |
|----------------|-----------|-----------|----------|---------|
| 2320393 | Prefect illustrious XL | Checkpoint | - | 1224788 |
| 2636014 | Glitter Dress \| Goofy Ai | LORA | - | 2343496 |

### Notes

- REST has `hash` + `weight` but no `modelVersionId`
- tRPC has `modelVersionId` but no `hash`, no `weight` (strength is null)
- Hash `07b3719602d2` returns 404 on by-hash API and doesn't match any hash in model version 2636014
- tRPC has `strength: null` for both, but REST has `weight: 1` for the lora
- **Bug**: `_merge_trpc_resources` can't match "glitter_dress_ilxl_goofy" to "Glitter Dress | Goofy Ai" by name

---

## Image 118854383

### REST `meta.resources`

| name | type | hash | weight |
|------|------|------|--------|
| style_of_Rembrandt_FLUX_135 | lora | 3957eaee0308 | 0.8 |
| 113_novuschromaFLX_1 | lora | 9558914853e7 | 0.2 |
| softwhim | lora | 45f94768beb7 | 1 |
| FS_v3 | lora | 5d4d457c3321 | 0.4 |
| NixPort_style_for_semi-real_upper_body_portrait | lora | 1106362582bc | 0.3 |
| - Flux1 - vanta_black_V2.0 | lora | 5d8cf3724039 | - |
| age_v1 | lora | efc12548f3d1 | - |
| flux_dev | model | 2eda627c8a | - |

### REST `meta.hashes`

| key | hash |
|-----|------|
| model | 2eda627c8a |
| lora:FS_v3 | 5d4d457c3321 |
| lora:age_v1 | efc12548f3d1 |
| lora:softwhim | 45f94768beb7 |
| lora:113_novuschromaFLX_1 | 9558914853e7 |
| lora:- Flux1 - vanta_black_V2.0 | 5d8cf3724039 |
| lora:style_of_Rembrandt_FLUX_135 | 3957eaee0308 |
| lora:NixPort_style_for_semi-real_upper_body_portrait | 1106362582bc |

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId |
|----------------|-----------|-----------|----------|---------|
| 1824428 | Portrait style from Nixst3r | LORA | 0.3 | 1612134 |
| 691639 | FLUX | Checkpoint | - | 618692 |
| 749527 | style of Rembrandt [FLUX] 135 | LORA | 0.8 | 669566 |
| 2093669 | Lost in color | LORA | 1 | 1723177 |
| 1946460 | Former Splendor | LORA | 0.4 | 997539 |
| 801005 | SDXL / Flux.1 D - Matte (Vanta)Black - Experiment | LORA | 1 | 263107 |
| 905597 | Dry Brush Paint [FLUX] | LORA | 0.2 | 809834 |

### Notes

- REST has 8 entries (7 loras + 1 model), tRPC has 7 entries (6 loras + 1 checkpoint)
- REST has `age_v1` lora (hash efc12548f3d1) which is **missing from tRPC**
- tRPC has `strength` values that mostly match REST `weight` values
- Name mapping challenges:
  - REST `softwhim` -> tRPC `Lost in color` (version: Whimsical)
  - REST `FS_v3` -> tRPC `Former Splendor` (version: v3.0)
  - REST `113_novuschromaFLX_1` -> tRPC `Dry Brush Paint [FLUX]` (version: 113_a6)
  - REST `NixPort_style_for_semi-real_upper_body_portrait` -> tRPC `Portrait style from Nixst3r`
  - REST `- Flux1 - vanta_black_V2.0` -> tRPC `SDXL / Flux.1 D - Matte (Vanta)Black - Experiment`

---

## Image 118713023

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId |
|----------------|-----------|-----------|----------|---------|
| 1160985 | Flux Art Fusion - v1.0 fp8 | Checkpoint | - | 1520970 |
| 1376386 | Anime art | LORA | - | 832858 |
| 802003 | Artify's Fantastic Flux Landscape Lora | LORA | - | 717187 |

### Notes

- REST has **nothing** — all metadata hidden by uploader
- tRPC is the **only source** of resource info
- All tRPC `strength` values are null

---

## Image 119083954

### REST `meta.resources`

| name | type | hash | weight |
|------|------|------|--------|
| volleyball-bump-in-the-face-illustriousxl-lora-nochekaiser | lora | - | 1 |

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | weight |
|------|----------------|--------|
| checkpoint | 2167369 | - |
| lora | 2040171 | 1 |
| lora | 2498503 | 0.4 |
| lora | 1447126 | 0.6 |
| lora | 2524593 | 0.4 |
| lora | 1882710 | 0.8 |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId |
|----------------|-----------|-----------|----------|---------|
| 1447126 | ma1ma1helmes \| Shiiro's Styles \| Niji | LORA | 0.6 | 1204563 |
| 1882710 | Niji semi realism | LORA | 0.8 | 534506 |
| 2040171 | Volleyball Bump In The Face - Concept | LORA | 1 | 1802803 |
| 2167369 | WAI-illustrious-SDXL | Checkpoint | - | 827184 |
| 2498503 | MoriiMee Gothic Niji \| LoRA Style | LORA | 0.4 | 915918 |
| 2524593 | People's Works + | LORA | 0.4 | 1400090 |

### Notes

- REST `meta.resources` has only 1 lora entry (no hash, no checkpoint)
- REST `meta.civitaiResources` has all 6 entries with `modelVersionId` + `weight` (but no `modelName`)
- tRPC has all 6 entries with `modelVersionId` + `modelName` + `strength`
- `civitaiResources` and tRPC share the same `modelVersionId` set — tRPC adds `modelName` / `modelType` / `modelId`
- tRPC `strength` values exactly match `civitaiResources` `weight` values

---

## Summary: Data Source Comparison

| Field | REST `meta.resources` | REST `meta.hashes` | REST `meta.civitaiResources` | tRPC `resources` |
|-------|----------------------|-------------------|----------------------------|-----------------|
| name (filename) | Yes | - | - | No (display name) |
| type | Yes | - | Yes | Yes |
| hash | Yes | Yes | - | No |
| weight/strength | Yes (some) | - | Yes (some) | Yes (some, can be null) |
| modelVersionId | No | - | Yes | Yes |
| modelId | No | - | No | Yes |
| modelName (display) | No | - | No | Yes |

### Key observations

1. **REST `meta.resources`** uses **filenames** as `name` (e.g. `glitter_dress_ilxl_goofy`, `FS_v3`), has `hash`
2. **tRPC `resources`** uses **display names** (e.g. `Glitter Dress | Goofy Ai`, `Former Splendor`), has `modelVersionId`
3. **REST `meta.civitaiResources`** is a middle ground: has `modelVersionId` + `weight` but no names
4. Name mapping between REST and tRPC is **unreliable** — filenames vs display names have no consistent pattern
5. tRPC can be missing entries that REST has (e.g. `age_v1` in 118854383)
6. REST can be entirely empty while tRPC has data (e.g. 118713023)
7. When `civitaiResources` exists, its `modelVersionId` set matches tRPC exactly
8. tRPC `strength` matches `civitaiResources` `weight` when both are present
