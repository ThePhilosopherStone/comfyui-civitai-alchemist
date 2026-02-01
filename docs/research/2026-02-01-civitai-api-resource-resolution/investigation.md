# Civitai API Investigation Report

Comparing REST `/api/v1/images` vs tRPC `image.getGenerationData`.

---

## Image 118787371

URL: https://civitai.com/images/118787371

### Model Info (REST)

- Model: `urn:air:sdxl:checkpoint:civitai:1882087@2130256`

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2130256 | - | - |
| lora | 2230391 | - | 1 |
| upscaler | 164821 | - | - |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 164821 | Remacri | Upscaler | - | 147759 | Other |
| 2130256 | Vixon’s NSFW Milk Factory | Checkpoint | - | 1882087 | Illustrious |
| 2230391 | Fox Dives Headfirst Into Snow - Meme | LORA | 1 | 1970518 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=1
- **upscaler**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (3 entries)

---

## Image 118810911

URL: https://civitai.com/images/118810911

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 691639 | FLUX | Checkpoint | - | 618692 | Flux.1 D |
| 747534 | Cyberpunk Anime Style | LORA | 0.5 | 128568 | Flux.1 D |
| 778925 | Daubrez Painterly Style | LORA | 0.3 | 696050 | Flux.1 D |
| 1050932 | Neurocore Anime Shadow Circuit by ChronoKnight - [FLUX, IL, ZIT] | LORA | 0.35 | 938811 | Flux.1 D |
| 1264088 | NEW FANTASY CORE - ILL-FLUX-PONY-SDXL- ZIT(detailer) | LORA | 0.6 | 810000 | Flux.1 D |
| 2425801 | Dark Side of Light | LORA | 0.35 | 1032948 | Flux.1 D |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=5

---

## Image 119006130

URL: https://civitai.com/images/119006130

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2512167 | OpenAI's GPT-image-1 | Checkpoint | - | 1532032 | OpenAI |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1

---

## Image 118735250

URL: https://civitai.com/images/118735250

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2436219 | Google's Nano Banana | Checkpoint | - | 1903424 | Nano Banana |
| 2470991 | Seedream | Checkpoint | - | 1951069 | Seedream |

### Cross-reference

- **checkpoint**: REST=0, tRPC=2

---

## Image 118859855

URL: https://civitai.com/images/118859855

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2442439 | Z Image Turbo | Checkpoint | - | 2168935 | ZImageTurbo |
| 2454927 | Cinematic Shot✨ | LORA | - | 432586 | ZImageTurbo |
| 2524277 | Realistic Skin Texture style (Detailed Skin) XL + SD1.5 + F1D + Pony + Illu + Zit | LORA | - | 580857 | ZImageTurbo |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=2

---

## Image 119245793

URL: https://civitai.com/images/119245793

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2512167 | OpenAI's GPT-image-1 | Checkpoint | - | 1532032 | OpenAI |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1

---

## Image 119146787

URL: https://civitai.com/images/119146787

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2436219 | Google's Nano Banana | Checkpoint | - | 1903424 | Nano Banana |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1

---

## Image 119083954

URL: https://civitai.com/images/119083954

### LoRAs from prompt (parsed `<lora:name:weight>`)

| name | weight |
|------|--------|
| `volleyball-bump-in-the-face-illustriousxl-lora-nochekaiser` | 1.0 |

### REST `meta.resources`

| name | type | hash | weight |
|------|------|------|--------|
| `volleyball-bump-in-the-face-illustriousxl-lora-nochekaiser` | lora | `-` | 1 |

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2167369 | - | - |
| lora | 2040171 | - | 1 |
| lora | 2498503 | - | 0.4 |
| lora | 1447126 | - | 0.6 |
| lora | 2524593 | - | 0.4 |
| lora | 1882710 | - | 0.8 |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 1447126 | ma1ma1helmes \| Shiiro's Styles \| Niji | LORA | 0.6 | 1204563 | Illustrious |
| 1882710 | Niji semi realism | LORA | 0.8 | 534506 | Illustrious |
| 2040171 | Volleyball Bump In The Face - Concept | LORA | 1 | 1802803 | Illustrious |
| 2167369 | WAI-illustrious-SDXL | Checkpoint | - | 827184 | Illustrious |
| 2498503 | MoriiMee Gothic Niji \| LoRA Style | LORA | 0.4 | 915918 | Illustrious |
| 2524593 | People's Works + | LORA | 0.4 | 1400090 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=1, tRPC=5
- civitaiResources vs tRPC version IDs: **identical** (6 entries)
- REST entries with no obvious tRPC name match: ['volleyball-bump-in-the-face-illustriousxl-lora-nochekaiser']

---

## Image 118717360

URL: https://civitai.com/images/118717360

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 1833157 | ✨ Lazy Embeddings for ALL illustrious NoobAI Pony SDXL models LazyPositive LazyNegative (Positive and Negative plus more!) | TextualInversion | - | 1302719 | Illustrious |

### Cross-reference

- **textualinversion**: REST=0, tRPC=1

---

## Image 118764059

URL: https://civitai.com/images/118764059

### Model Info (REST)

- Model: `0.7(lora2_00001_) + 0.3(Lo~fij)`
- Model hash: `96acec2bde`

### REST `meta.resources`

| name | type | hash | weight |
|------|------|------|--------|
| `0.7(lora2_00001_) + 0.3(Lo~fij)` | model | `96acec2bde` | - |

### REST `meta.hashes`

| key | hash |
|-----|------|
| `model` | `96acec2bde` |

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2629873 | Illustrij-GEN | Checkpoint | - | 2003939 | Illustrious |

### Cross-reference

- **checkpoint**: REST=1, tRPC=1
- REST entries with no obvious tRPC name match: ['0.7(lora2_00001_) + 0.3(Lo~fij)']

---

## Image 118962148

URL: https://civitai.com/images/118962148

### Model Info (REST)

- Model: `urn:air:sdxl:checkpoint:civitai:827184@2514310`

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2514310 | - | - |
| lora | 1447126 | - | 0.45 |
| - | 1833157 | - | 1 |
| lora | 1888209 | - | 0.75 |
| lora | 1444863 | - | -0.85 |
| lora | 2524593 | - | 0.5 |
| lora | 1278054 | - | 0.3 |
| upscaler | 164821 | - | - |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 164821 | Remacri | Upscaler | - | 147759 | Other |
| 1278054 | [Style filter] Xu Er thick paint composition light texture enhancement | LORA | 0.3 | 768917 | Illustrious |
| 1444863 | Lighting / darkness slider | LORA | -0.85 | 1280702 | Illustrious |
| 1447126 | ma1ma1helmes \| Shiiro's Styles \| Niji | LORA | 0.45 | 1204563 | Illustrious |
| 1833157 | ✨ Lazy Embeddings for ALL illustrious NoobAI Pony SDXL models LazyPositive LazyNegative (Positive and Negative plus more!) | TextualInversion | 1 | 1302719 | Illustrious |
| 1888209 | MGE Monster Girls | LORA | 0.75 | 556479 | Illustrious |
| 2514310 | WAI-illustrious-SDXL | Checkpoint | - | 827184 | Illustrious |
| 2524593 | People's Works + | LORA | 0.5 | 1400090 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=5
- **textualinversion**: REST=0, tRPC=1
- **upscaler**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (8 entries)

---

## Image 118810961

URL: https://civitai.com/images/118810961

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2615702 | - | - |
| lora | 1447126 | - | 0.45 |
| embed | 1833157 | - | 1 |
| lora | 1888209 | - | 0.75 |
| lora | 1444863 | - | -0.85 |
| lora | 2524593 | - | 0.5 |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 1444863 | Lighting / darkness slider | LORA | -0.85 | 1280702 | Illustrious |
| 1447126 | ma1ma1helmes \| Shiiro's Styles \| Niji | LORA | 0.45 | 1204563 | Illustrious |
| 1833157 | ✨ Lazy Embeddings for ALL illustrious NoobAI Pony SDXL models LazyPositive LazyNegative (Positive and Negative plus more!) | TextualInversion | 1 | 1302719 | Illustrious |
| 1888209 | MGE Monster Girls | LORA | 0.75 | 556479 | Illustrious |
| 2524593 | People's Works + | LORA | 0.5 | 1400090 | Illustrious |
| 2615702 | Hassaku XL (Illustrious) | Checkpoint | - | 140272 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=4
- **textualinversion**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (6 entries)

---

## Image 119240483

URL: https://civitai.com/images/119240483

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2442439 | Z Image Turbo | Checkpoint | - | 2168935 | ZImageTurbo |
| 2544677 | Aetheric Rendering Style | LORA | - | 2260542 | ZImageTurbo |
| 2460437 | Midjourney Luneva Cinematic Lora | LORA | - | 2185167 | ZImageTurbo |
| 2515203 | [ZIT] Detail Slider | LORA | - | 2234266 | ZImageTurbo |
| 2455794 | Z-Image/Chroma/Qwen-Anime | LORA | - | 1994924 | ZImageTurbo |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=4

---

## Image 118952863

URL: https://civitai.com/images/118952863

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2514310 | - | - |
| lora | 1447126 | - | 0.45 |
| embed | 1833157 | - | 1 |
| lora | 1888209 | - | 0.75 |
| lora | 1444863 | - | -0.85 |
| lora | 2524593 | - | 0.5 |
| lora | 1278054 | - | 0.3 |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 1278054 | [Style filter] Xu Er thick paint composition light texture enhancement | LORA | 0.3 | 768917 | Illustrious |
| 1444863 | Lighting / darkness slider | LORA | -0.85 | 1280702 | Illustrious |
| 1447126 | ma1ma1helmes \| Shiiro's Styles \| Niji | LORA | 0.45 | 1204563 | Illustrious |
| 1833157 | ✨ Lazy Embeddings for ALL illustrious NoobAI Pony SDXL models LazyPositive LazyNegative (Positive and Negative plus more!) | TextualInversion | 1 | 1302719 | Illustrious |
| 1888209 | MGE Monster Girls | LORA | 0.75 | 556479 | Illustrious |
| 2514310 | WAI-illustrious-SDXL | Checkpoint | - | 827184 | Illustrious |
| 2524593 | People's Works + | LORA | 0.5 | 1400090 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=5
- **textualinversion**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (7 entries)

---

## Image 118947999

URL: https://civitai.com/images/118947999

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2167369 | - | - |
| lora | 2631122 | - | 1 |
| lora | 2498503 | - | 0.4 |
| lora | 1447126 | - | 0.6 |
| lora | 2524593 | - | 0.4 |
| lora | 1882710 | - | 0.8 |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 1447126 | ma1ma1helmes \| Shiiro's Styles \| Niji | LORA | 0.6 | 1204563 | Illustrious |
| 1882710 | Niji semi realism | LORA | 0.8 | 534506 | Illustrious |
| 2167369 | WAI-illustrious-SDXL | Checkpoint | - | 827184 | Illustrious |
| 2498503 | MoriiMee Gothic Niji \| LoRA Style | LORA | 0.4 | 915918 | Illustrious |
| 2524593 | People's Works + | LORA | 0.4 | 1400090 | Illustrious |
| 2631122 | In Crane Game | LORA | 1 | 2339131 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=5
- civitaiResources vs tRPC version IDs: **identical** (6 entries)

---

## Image 118712167

URL: https://civitai.com/images/118712167

### Model Info (REST)

- Model: `urn:air:sdxl:checkpoint:civitai:138630@2273895`

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2273895 | - | - |
| lora | 1242203 | - | 2.2 |
| lora | 2160260 | - | 0.8 |
| lycoris | 2349271 | - | 0.4 |
| lora | 1495543 | - | 0.3 |
| - | 1860747 | - | 1 |
| - | 1550840 | - | 1 |
| - | 1833199 | - | 1 |
| lora | 2303894 | - | 0.4 |
| upscaler | 164821 | - | - |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 164821 | Remacri | Upscaler | - | 147759 | Other |
| 1242203 | Dramatic Lighting Slider | LORA | 2.2 | 1105685 | Pony |
| 1495543 | Sinozick \| Shiiro's Styles \| Niji | LORA | 0.3 | 1324670 | Illustrious |
| 1550840 | ✨ Lazy Embeddings for ALL illustrious NoobAI Pony SDXL models LazyPositive LazyNegative (Positive and Negative plus more!) | TextualInversion | 1 | 1302719 | Illustrious |
| 1833199 | ✨ Lazy Embeddings for ALL illustrious NoobAI Pony SDXL models LazyPositive LazyNegative (Positive and Negative plus more!) | TextualInversion | 1 | 1302719 | Illustrious |
| 1860747 | ✨ Lazy Embeddings for ALL illustrious NoobAI Pony SDXL models LazyPositive LazyNegative (Positive and Negative plus more!) | TextualInversion | 1 | 1302719 | Illustrious |
| 2160260 | 2dReal/Photo Background | LORA | 0.8 | 1908594 | Illustrious |
| 2273895 | Hardcore Asian Cosplay Porn | Checkpoint | - | 138630 | Illustrious |
| 2303894 | [BSS] - Styles for Equinox (Illustrious) | LORA | 0.4 | 1963101 | Illustrious |
| 2349271 | Rella - Illustriou/NoobAI | LoCon | 0.4 | 2076229 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **locon**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=4
- **textualinversion**: REST=0, tRPC=3
- **upscaler**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (10 entries)

---

## Image 118662409

URL: https://civitai.com/images/118662409

### Model Info (REST)

- Model: `urn:air:sdxl:checkpoint:civitai:2099347@2569166`

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2569166 | - | - |
| lora | 1652667 | - | 1 |
| upscaler | 164821 | - | - |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 164821 | Remacri | Upscaler | - | 147759 | Other |
| 1652667 | (IL Tool) Native High Resolution / Super Wide Shot / Better Highres Fix | LORA | 1 | 1461427 | Illustrious |
| 2569166 | (illustrious) New Mecha | Checkpoint | - | 2099347 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=1
- **upscaler**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (3 entries)

---

## Image 119065683

URL: https://civitai.com/images/119065683

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2514310 | - | - |
| lora | 2034730 | - | 0.5 |
| lora | 1736373 | - | 1 |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 1736373 | Detailer IL | LORA | 1 | 1231943 | Illustrious |
| 2034730 | People's Works + | LORA | 0.5 | 1400090 | Illustrious |
| 2514310 | WAI-illustrious-SDXL | Checkpoint | - | 827184 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=2
- civitaiResources vs tRPC version IDs: **identical** (3 entries)

---

## Image 119275267

URL: https://civitai.com/images/119275267

### Model Info (REST)

- Model: `z_image_turbo_bf16`
- Model hash: `2407613050`

### LoRAs from prompt (parsed `<lora:name:weight>`)

| name | weight |
|------|--------|
| `Style_haiti5-Pr1sm_fx-ZIT` | 0.7 |

### REST `meta.resources`

| name | type | hash | weight |
|------|------|------|--------|
| `Style_haiti5-Pr1sm_fx-ZIT` | lora | `320320581236` | 0.7 |
| `z_image_turbo_bf16` | model | `2407613050` | - |

### REST `meta.hashes`

| key | hash |
|-----|------|
| `model` | `2407613050` |
| `lora:Style_haiti5-Pr1sm_fx-ZIT` | `320320581236` |

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2442439 | Z Image Turbo | Checkpoint | - | 2168935 | ZImageTurbo |
| 2633749 | Prismatic Glitchcore aka Prismcore | LORA | - | 2341503 | ZImageTurbo |

### Cross-reference

- **checkpoint**: REST=1, tRPC=1
- **lora**: REST=1, tRPC=1
- REST entries with no obvious tRPC name match: ['Style_haiti5-Pr1sm_fx-ZIT', 'z_image_turbo_bf16']

---

## Image 118705873

URL: https://civitai.com/images/118705873

### Model Info (REST)

- Model: `gpQúwaiIllustriousSDXL_v160`

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2514310 | - | - |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2514310 | WAI-illustrious-SDXL | Checkpoint | - | 827184 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (1 entries)

---

## Image 118662408

URL: https://civitai.com/images/118662408

### Model Info (REST)

- Model: `urn:air:sdxl:checkpoint:civitai:2099347@2569166`

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2569166 | - | - |
| lora | 1652667 | - | 1 |
| upscaler | 164821 | - | - |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 164821 | Remacri | Upscaler | - | 147759 | Other |
| 1652667 | (IL Tool) Native High Resolution / Super Wide Shot / Better Highres Fix | LORA | 1 | 1461427 | Illustrious |
| 2569166 | (illustrious) New Mecha | Checkpoint | - | 2099347 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=1
- **upscaler**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (3 entries)

---

## Image 119112936

URL: https://civitai.com/images/119112936

### LoRAs from prompt (parsed `<lora:name:weight>`)

| name | weight |
|------|--------|
| `Osu` | 1.0 |

### REST `meta.resources`

| name | type | hash | weight |
|------|------|------|--------|
| `Osu` | lora | `-` | 1 |

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2578565 | - | - |
| lora | 1447126 | - | 0.45 |
| embed | 1833157 | - | 1 |
| lora | 2625588 | - | 0.7 |
| lora | 1444863 | - | -0.85 |
| lora | 1888209 | - | 0.75 |
| lora | 2524593 | - | 0.5 |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 1444863 | Lighting / darkness slider | LORA | -0.85 | 1280702 | Illustrious |
| 1447126 | ma1ma1helmes \| Shiiro's Styles \| Niji | LORA | 0.45 | 1204563 | Illustrious |
| 1833157 | ✨ Lazy Embeddings for ALL illustrious NoobAI Pony SDXL models LazyPositive LazyNegative (Positive and Negative plus more!) | TextualInversion | 1 | 1302719 | Illustrious |
| 1888209 | MGE Monster Girls | LORA | 0.75 | 556479 | Illustrious |
| 2524593 | People's Works + | LORA | 0.5 | 1400090 | Illustrious |
| 2578565 | ✨ JANKU Trained + NoobAI + RouWei Illustrious XL ✨ | Checkpoint | - | 1277670 | Illustrious |
| 2625588 | Osu \| by UTdT69 | LORA | 0.7 | 2334106 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=1, tRPC=5
- **textualinversion**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (7 entries)

---

## Image 118993188

URL: https://civitai.com/images/118993188

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

(empty)

### Cross-reference


---

## Image 118991713

URL: https://civitai.com/images/118991713

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

(empty)

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 2436219 | Google's Nano Banana | Checkpoint | - | 1903424 | Nano Banana |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1

---

## Image 119059829

URL: https://civitai.com/images/119059829

### REST `meta.resources`

(empty)

### REST `meta.hashes`

(empty)

### REST `meta.civitaiResources`

| type | modelVersionId | modelName | weight |
|------|----------------|-----------|--------|
| checkpoint | 2615702 | - | - |
| lora | 1447126 | - | 0.45 |
| embed | 1833157 | - | 1 |
| lora | 1444863 | - | -0.85 |
| lora | 2524593 | - | 0.5 |
| lora | 1278054 | - | 0.3 |
| lora | 1888209 | - | 0.75 |

### tRPC `resources`

| modelVersionId | modelName | modelType | strength | modelId | baseModel |
|----------------|-----------|-----------|----------|---------|-----------|
| 1278054 | [Style filter] Xu Er thick paint composition light texture enhancement | LORA | 0.3 | 768917 | Illustrious |
| 1444863 | Lighting / darkness slider | LORA | -0.85 | 1280702 | Illustrious |
| 1447126 | ma1ma1helmes \| Shiiro's Styles \| Niji | LORA | 0.45 | 1204563 | Illustrious |
| 1833157 | ✨ Lazy Embeddings for ALL illustrious NoobAI Pony SDXL models LazyPositive LazyNegative (Positive and Negative plus more!) | TextualInversion | 1 | 1302719 | Illustrious |
| 1888209 | MGE Monster Girls | LORA | 0.75 | 556479 | Illustrious |
| 2524593 | People's Works + | LORA | 0.5 | 1400090 | Illustrious |
| 2615702 | Hassaku XL (Illustrious) | Checkpoint | - | 140272 | Illustrious |

### Cross-reference

- **checkpoint**: REST=0, tRPC=1
- **lora**: REST=0, tRPC=5
- **textualinversion**: REST=0, tRPC=1
- civitaiResources vs tRPC version IDs: **identical** (7 entries)
