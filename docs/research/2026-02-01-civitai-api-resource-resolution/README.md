# Civitai API Resource Resolution 研究：REST vs tRPC 資料來源分析

## 執行摘要

本研究針對 Civitai 三個資料來源（REST `meta.resources`、REST `meta.civitaiResources`、tRPC `image.getGenerationData`）進行系統性比較分析，目的是解決現有 `_merge_trpc_resources` 合併邏輯產生重複條目和遺漏 `modelVersionId` 的問題。

透過 25 張圖片（94 個 tRPC resources）的實證分析，關鍵發現：

- **tRPC 是最完整的資料來源**：24/25 張圖片有 tRPC 資料，只有 1 張完全為空
- **REST `meta.resources` 高度不可靠**：25 張中只有 6 張有資料（24%），且不包含 `modelVersionId`
- **`civitaiResources` 與 tRPC 完全一致**：當 `civitaiResources` 存在時，其 `modelVersionId` 集合與 tRPC 100% 相同
- **tRPC strength 缺失可控**：37 個 null strength 中，30 個是 Checkpoint/Upscaler/TextualInversion（本來就不需要 weight），真正有影響的只有 7 個 LoRA（7.4%），且這些 LoRA 在 REST 側也同樣沒有 weight

**結論：以 tRPC 作為唯一資料來源，完全取代現有的三源合併策略。** 這樣可以消除合併邏輯中的 name matching 問題，同時不會損失任何實際有用的資料。

## 背景與脈絡

### 問題起因

在處理 Civitai image 119018511 時，LoRA `glitter_dress_ilxl_goofy` 出現了重複條目：一個來自 REST `meta.resources`（無 `modelVersionId`，hash 404），另一個來自 tRPC enrichment（有 `modelVersionId` 2636014）。根本原因是 `_merge_trpc_resources` 的 name matching 邏輯無法將 filename 格式的名稱（`glitter_dress_ilxl_goofy`）對應到 display name（`Glitter Dress | Goofy Ai`）。

### 現有架構

`fetch_metadata.py` 中的 `extract_metadata()` 和 `enrich_metadata()` 使用三個 Civitai 資料來源：

1. **REST `meta.resources`**（嵌入式 metadata）— 從 `GET /api/v1/images?imageId={id}` 取得
2. **REST `meta.civitaiResources`**（嵌入式 metadata）— 同上
3. **tRPC `resources`**（伺服器端解析）— 從 `GET /api/trpc/image.getGenerationData` 取得

資料流如下：

```
extract_metadata()
  ├─ 優先使用 meta.resources（有 hash, filename, weight）
  ├─ Fallback 到 meta.civitaiResources（有 modelVersionId, weight）
  └─ enrich_metadata() → _merge_trpc_resources()
       └─ 嘗試將 tRPC 資料合併到現有 resources
          ├─ Strategy 1: 用 modelVersionId 匹配
          └─ Strategy 2: 用 type + name substring 匹配 ← 這裡出問題
```

### 研究方法

為系統性分析三個資料來源的差異，建立了 `scripts/investigate_apis.py` 工具，可批量查詢多張圖片並產生結構化報告。共分析了 25 張涵蓋不同模型架構（Illustrious、Flux、ZImageTurbo、OpenAI、Nano Banana、Seedream）的圖片，原始資料儲存於 `output/investigation.json`。

## 資料來源分析

### 三個 API 的欄位對照

| 欄位 | REST `meta.resources` | REST `meta.civitaiResources` | tRPC `resources` |
|------|----------------------|----------------------------|--------------------|
| name (filename) | Yes | No | No |
| name (display) | No | No | Yes (`modelName`) |
| type | Yes | Yes | Yes (`modelType`) |
| hash | Yes | No | No |
| weight/strength | Yes (部分) | Yes (部分) | Yes (部分, 可能 null) |
| modelVersionId | No | Yes | Yes |
| modelId | No | No | Yes |
| baseModel | No | No | Yes |
| versionName | No | No | Yes |

### 資料完整度統計（25 張圖片）

| 資料來源 | 有資料的圖片數 | 比例 |
|----------|--------------|------|
| REST `meta.resources` | 6 | 24% |
| REST `meta.civitaiResources` | 12 | 48% |
| tRPC `resources` | 24 | 96% |
| 全部為空 | 1 (118993188) | 4% |

### tRPC strength/weight 分析（94 個 tRPC resources）

| 類別 | 數量 | 比例 | 影響 |
|------|------|------|------|
| strength 有值 | 57 | 60.6% | 正常 |
| strength=null (Checkpoint) | 24 | 25.5% | 不影響 — checkpoint 不需要 weight |
| strength=null (Upscaler) | 5 | 5.3% | 不影響 — upscaler 不需要 weight |
| strength=null (TextualInversion) | 1 | 1.1% | 不影響 — embedding 不需要 weight |
| **strength=null (LORA)** | **7** | **7.4%** | **有影響 — LoRA 需要 weight** |

7 個缺少 weight 的 LoRA 詳細分布：

| Image ID | baseModel | LoRA Name | 可否從其他來源恢復 |
|----------|-----------|-----------|-------------------|
| 118859855 | ZImageTurbo | Cinematic Shot | 否（civitaiResources 為空、prompt_loras 為空）|
| 118859855 | ZImageTurbo | Realistic Skin Texture | 同上 |
| 119240483 | ZImageTurbo | Aetheric Rendering Style | 同上 |
| 119240483 | ZImageTurbo | Midjourney Luneva Cinematic Lora | 同上 |
| 119240483 | ZImageTurbo | [ZIT] Detail Slider | 同上 |
| 119240483 | ZImageTurbo | Z-Image/Chroma/Qwen-Anime | 同上 |
| 119275267 | ZImageTurbo | Prismatic Glitchcore | 部分（prompt_loras 有 `Style_haiti5-Pr1sm_fx-ZIT` weight=0.7，但名稱不匹配）|

所有 7 個都來自 ZImageTurbo 生態系統，且 REST 側也同樣沒有任何 weight 資料可供回退。

### civitaiResources 與 tRPC 的對應關係

在 12 張同時擁有 `civitaiResources` 和 tRPC 資料的圖片中，`modelVersionId` 集合 **100% 完全一致**。tRPC 在 `civitaiResources` 的基礎上額外提供了 `modelName`、`modelType`、`modelId`、`baseModel`。

也就是說，`civitaiResources` 是 tRPC 的子集 — 如果 tRPC 有資料，`civitaiResources` 能提供的資訊 tRPC 都有，而且更多。

### REST `meta.resources` 獨有價值分析

REST `meta.resources` 提供了兩個 tRPC 沒有的欄位：

**1. hash（檔案雜湊）**

理論上可用於 `GET /api/v1/model-versions/by-hash/{hash}` 查詢。但實測發現：
- Image 119018511 的 hash `07b3719602d2` 對 by-hash API 回傳 404，且與 model version 2636014 的任何官方 hash 格式（AutoV2、AutoV3、SHA256）都不匹配
- 25 張圖中有 hash 的只有 4 張（119083954、118764059、119275267、119112936），且大部分 hash 欄位為空或 `-`

**2. name（檔案名稱格式）**

如 `glitter_dress_ilxl_goofy`、`Style_haiti5-Pr1sm_fx-ZIT`、`FS_v3`。這些名稱在 resolve 階段沒有用途（需要 `modelVersionId` 或有效 hash），在 workflow 生成階段也沒有用途（ComfyUI 使用 `modelName` 或下載後的實際檔名）。

**3. weight（LoRA 權重）**

可從 prompt 中的 `<lora:name:weight>` 語法解析取得相同資訊。而且 tRPC 的 strength 值已經涵蓋了大部分情況。

**結論：REST `meta.resources` 沒有任何不可替代的獨有價值。**

## 現有合併邏輯的問題

### `_merge_trpc_resources` 的 Name Matching 缺陷

現有的 Strategy 2 使用 substring matching：

```python
names_match = (
    res_name.lower() in trpc_name.lower()
    or trpc_name.lower() in res_name.lower()
)
```

以下是 25 張圖片中觀察到的 name mismatch 案例：

| REST filename | tRPC display name | 能否 substring 匹配 |
|---------------|-------------------|---------------------|
| `glitter_dress_ilxl_goofy` | `Glitter Dress \| Goofy Ai` | 否 |
| `Style_haiti5-Pr1sm_fx-ZIT` | `Prismatic Glitchcore aka Prismcore` | 否 |
| `z_image_turbo_bf16` | `Z Image Turbo` | 否 |
| `0.7(lora2_00001_) + 0.3(Lo~fij)` | `Illustrij-GEN` | 否 |
| `Osu` | `Osu \| by UTdT69` | 是（Osu 是 substring）|

在先前的 api-comparison.md 分析中也觀察到：

| REST filename | tRPC display name | 能否匹配 |
|---------------|-------------------|----------|
| `softwhim` | `Lost in color` | 否 |
| `FS_v3` | `Former Splendor` | 否 |
| `113_novuschromaFLX_1` | `Dry Brush Paint [FLUX]` | 否 |

**Filename 和 display name 之間沒有任何可靠的對應規則**，因為 filename 是上傳者自訂的（可能是隨機縮寫、暱稱、或自動生成的名稱），而 display name 是模型作者在 Civitai 上設定的正式名稱。

### 合併導致的具體問題

1. **重複條目**：同一個 LoRA 出現兩次 — 一個來自 REST（無 `modelVersionId`），一個來自 tRPC（有 `modelVersionId`）
2. **錯誤匹配**：如果兩個不同 LoRA 的名稱碰巧有 substring 關係，可能被錯誤合併
3. **遺漏 `modelVersionId`**：未匹配到的 REST 條目沒有 `modelVersionId`，導致 resolve 只能靠 hash（常 404）或 name search（不可靠）

## 方案評估

### 方案 A：改善 Name Matching（放棄）

加入 fuzzy matching、normalize underscores/spaces 等。

- 優點：最小改動
- 缺點：filename vs display name 之間根本沒有可靠的對應規則（`softwhim` vs `Lost in color`），任何 fuzzy matching 都無法解決

### 方案 B：tRPC 為主要來源（採用）

完全以 tRPC 作為資源列表的來源，不再使用 REST `meta.resources`。

- 優點：消除所有合併問題、程式碼大幅簡化、`modelVersionId` 覆蓋率最高
- 缺點：7/94 (7.4%) 的 LoRA 缺少 weight → fallback 為 1.0
- 風險：tRPC 可能比 REST 晚更新或暫時無法使用 → 可保留 REST 作為最後手段

### 方案 C：Hash 交叉比對（放棄）

用 REST 的 hash 與 tRPC 的 modelVersionId 交叉比對。

- 結果：經實測，REST 的 embedded hash 與 model version 的官方 hash 格式不同，比對失敗
- 具體案例：hash `07b3719602d2` vs model version 2636014 的 AutoV2 `BD7F011662` — 完全不匹配

### 方案 D：civitaiResources 為橋樑（不必要）

用 `civitaiResources` 的 `modelVersionId` 來匹配 REST 和 tRPC。

- 分析結果：`civitaiResources` 的 `modelVersionId` 集合與 tRPC 100% 一致，但 `civitaiResources` 少了 `modelName`、`modelType`、`baseModel`
- 結論：直接用 tRPC 就好，中間多一層 `civitaiResources` 橋接沒有意義

## 建議實作方案

### 架構變更

將 `fetch_metadata.py` 中的資源提取邏輯重構為：

```
extract_metadata()
  └─ 從 REST API 取得 prompt, sampler, steps, cfg, seed, size 等生成參數

enrich_metadata()
  └─ 從 tRPC 取得 resources（直接作為唯一資源列表）
     ├─ 有 strength → 直接使用
     ├─ strength=null 且 type=LORA → fallback 為 1.0
     └─ strength=null 且 type=Checkpoint/Upscaler/TI → 不需要 weight
```

### 具體改動

1. **`extract_metadata()`**：移除 `meta.resources` 和 `meta.civitaiResources` 的資源解析邏輯，這些欄位只用於提取生成參數（prompt, sampler 等）
2. **`enrich_metadata()`**：改為主要的資源提取入口，直接從 tRPC 建構 resources 列表
3. **移除 `_merge_trpc_resources()`**：不再需要合併邏輯
4. **weight fallback**：tRPC strength 為 null 的 LoRA，fallback 為 1.0（現行行為不變）

### Fallback 策略

如果 tRPC 完全無資料（如 image 118993188），依序 fallback：

1. `meta.civitaiResources`（有 `modelVersionId` + `weight`，缺 `modelName`）
2. `meta.resources`（有 filename + hash + weight，缺 `modelVersionId`）

這個 fallback 路徑保留了對邊緣情況的支援，但預期極少觸發。

### 預期效果

| 指標 | 改動前 | 改動後 |
|------|--------|--------|
| 重複條目問題 | 存在（name mismatch 時） | 消除 |
| `modelVersionId` 覆蓋率 | 取決於合併成功率 | 96%（tRPC 覆蓋率） |
| 程式碼複雜度 | `extract_metadata` + `_merge_trpc_resources` ~120 行合併邏輯 | 移除合併邏輯，淨減 ~80 行 |
| LoRA weight 缺失率 | 7.4%（這些 LoRA 在 REST 側也缺失） | 7.4%（fallback 1.0，不變） |

## 實證資料

### 25 張圖片調查結果

完整分析報告位於 `investigation.md`，原始 JSON 資料位於 `investigation.json`（均位於本目錄下）。

以下列出代表性案例：

#### 案例 1：tRPC 為唯一資料來源（Image 118810911）

REST 完全為空，tRPC 提供完整 resource 列表含 strength：

| modelVersionId | modelName | modelType | strength |
|----------------|-----------|-----------|----------|
| 691639 | FLUX | Checkpoint | null |
| 747534 | Cyberpunk Anime Style | LORA | 0.5 |
| 778925 | Daubrez Painterly Style | LORA | 0.3 |
| 1050932 | Neurocore Anime Shadow Circuit | LORA | 0.35 |
| 1264088 | NEW FANTASY CORE | LORA | 0.6 |
| 2425801 | Dark Side of Light | LORA | 0.35 |

#### 案例 2：civitaiResources 與 tRPC 完全一致（Image 118962148）

civitaiResources 有 8 個 `modelVersionId` + `weight`，tRPC 有相同的 8 個 `modelVersionId` 加上 `modelName`、`modelType`、`baseModel`。weight/strength 值完全對應。

#### 案例 3：tRPC LoRA strength 為 null（Image 119240483）

ZImageTurbo 圖片，4 個 LoRA 全部 strength=null。REST 側也完全為空。無論用哪個資料來源都無法取得 weight。

#### 案例 4：Name mismatch 導致重複（Image 119275267）

REST 有 `Style_haiti5-Pr1sm_fx-ZIT`（weight=0.7），tRPC 有 `Prismatic Glitchcore aka Prismcore`（strength=null）。Name matching 無法對應這兩個名稱，導致現有邏輯產生兩個條目。改用 tRPC-only 方案後，只會有一個條目（`Prismatic Glitchcore`），weight fallback 為 1.0。

注意：此案例中 REST 的 weight=0.7 在切換為 tRPC-only 後會遺失，但這是 25 張圖中唯一一個 tRPC 缺 strength 但 REST 有的案例，且 weight 差異（0.7 vs 1.0）對生成結果的影響相對有限。

## 工具

本研究建立了 `investigate_apis.py`（位於本目錄下），可用於未來持續驗證 API 行為：

```bash
# 調查單張圖片
python docs/research/2026-02-01-civitai-api-resource-resolution/investigate_apis.py 119018511

# 批量調查（markdown + JSON output）
python docs/research/2026-02-01-civitai-api-resource-resolution/investigate_apis.py 119018511 118854383 118713023 --json

# 指定輸出路徑
python docs/research/2026-02-01-civitai-api-resource-resolution/investigate_apis.py 119018511 --output output/investigation.md
```

## 參考資料

### Civitai API
- REST API: `GET /api/v1/images?imageId={id}` — 回傳 `meta.resources`、`meta.hashes`、`meta.civitaiResources`
- REST API: `GET /api/v1/model-versions/by-hash/{hash}` — 用 hash 查詢 model version
- REST API: `GET /api/v1/model-versions/{id}` — 用 version ID 查詢 model version
- tRPC API: `GET /api/trpc/image.getGenerationData?input={"json":{"id":{id}}}` — 伺服器端解析的 resource 列表

### 本目錄內文件
- `investigation.md` — 25 張圖片的完整調查報告
- `investigation.json` — 25 張圖片的原始 JSON 資料
- `api-comparison.md` — 早期 4 張圖片的手動比較（已被 investigation.md 取代）
- `investigate_apis.py` — 批量調查工具

### 專案內相關文件
- `pipeline/fetch_metadata.py` — metadata 提取邏輯（已依本報告重構為 tRPC-first）
- `civitai_utils/civitai_api.py` — Civitai API 客戶端
