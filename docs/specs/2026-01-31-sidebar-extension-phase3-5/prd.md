# PRD: Civitai Alchemist ComfyUI Sidebar Extension（第三、四、五階段）

## 簡介/概述

本 PRD 定義 Civitai Alchemist sidebar extension 的第三至第五階段功能，銜接已完成的第一、二階段（metadata 查詢與 model 狀態檢查）。

- **第三階段（模型下載）**：讓使用者可以直接從 sidebar 下載缺少的模型，並即時看到下載進度
- **第四階段（Workflow 生成與載入）**：一鍵生成 ComfyUI workflow 並載入到 canvas，完成「看圖到出圖」的完整流程
- **第五階段（發佈準備）**：讓 extension 可以正式發佈到 ComfyUI Registry，供其他使用者安裝使用

完成後，使用者在 ComfyUI 中看到一張 Civitai 圖片，從輸入 ID 到開始生成，全程不需要離開 ComfyUI 介面或使用終端機。

本 PRD 基於第一、二階段的實作經驗（`docs/specs/2026-01-31-sidebar-extension-phase1-2/implementation.md`）中記錄的技術決策與已知問題。

## 目標

1. **讓使用者可以在 sidebar 中一鍵下載所有缺少的模型**，並看到每個模型的即時下載進度
2. **讓使用者可以在 sidebar 中一鍵生成 ComfyUI workflow 並載入到 canvas**，直接開始使用或修改
3. **讓 extension 具備正式發佈到 ComfyUI Registry 的條件**，包含完整的 CI/CD 流程和文件

## 使用者故事

### US-1：下載缺少的單一模型（Phase 3）

作為 ComfyUI 使用者，我在 sidebar 查詢了一張 Civitai 圖片的資訊，看到 model 列表中有 3 個模型標示為 ❌ 缺少。我點擊其中一個缺少模型旁邊的下載按鈕，該模型開始下載，卡片上顯示進度條和百分比。下載完成後，進度條消失，狀態變為 ✅ 已存在。

### US-2：批次下載所有缺少的模型（Phase 3）

作為 ComfyUI 使用者，我不想逐一點擊下載按鈕。我看到 model 列表上方有「Download All Missing」按鈕，點擊後系統開始依序下載所有缺少的模型。每個模型下載時，對應的卡片顯示進度條。全部下載完成後，所有模型都變成 ✅ 狀態，「Download All Missing」按鈕消失（因為沒有缺少的了）。

### US-3：下載期間繼續使用 ComfyUI（Phase 3）

作為 ComfyUI 使用者，我開始下載模型後，可以切換到其他 ComfyUI tab 繼續操作。回到 Civitai Alchemist tab 時，下載進度仍然正確顯示。下載不會阻塞 ComfyUI 的其他操作。

### US-4：下載失敗時的處理（Phase 3）

作為 ComfyUI 使用者，如果某個模型下載失敗（網路中斷、Civitai 服務暫時不可用等），該模型的卡片顯示錯誤訊息，我可以點擊重試按鈕重新下載。其他模型的下載不受影響（批次下載時會跳過失敗的繼續下載下一個）。

### US-5：生成 Workflow 並載入到 Canvas（Phase 4）

作為 ComfyUI 使用者，我已經查詢了圖片資訊並確認所有模型都已下載。我點擊「Generate Workflow」按鈕，系統根據生成參數和模型資訊產生 ComfyUI workflow，然後自動載入到 canvas。我可以在 canvas 上看到完整的 node graph，確認參數後直接按 Queue Prompt 開始生成。

### US-6：部分模型缺少時生成 Workflow（Phase 4）

作為 ComfyUI 使用者，我有些 LoRA 模型不想下載（可能我想用替代品）。我點擊「Generate Workflow」按鈕時，系統顯示警告訊息告知有模型缺少，但仍然生成 workflow 並載入到 canvas。我可以在 canvas 上手動修改對應的 node，選擇我本地已有的替代模型。

### US-7：透過 ComfyUI Registry 安裝 extension（Phase 5）

作為 ComfyUI 使用者，我可以在 ComfyUI Manager 中搜尋「Civitai Alchemist」並直接安裝。安裝後重啟 ComfyUI，sidebar 中就出現 Civitai Alchemist tab，不需要手動 clone repository 或建置前端。

## 功能需求

### Phase 3：模型下載

#### FR-1：單一模型下載按鈕

1. 每個狀態為「缺少」（❌）的 model 卡片上顯示「Download」按鈕
2. 已存在（✅）的 model 卡片不顯示下載按鈕
3. 無法解析（unresolved）的 model 卡片不顯示下載按鈕，顯示「Cannot resolve」提示
4. 點擊 Download 按鈕後，按鈕變為 disabled 並開始下載

#### FR-2：批次下載按鈕

1. Model 列表摘要區域提供「Download All Missing」按鈕
2. 當沒有缺少的模型時，該按鈕不顯示
3. 點擊後依序下載所有缺少且已解析（resolved）的模型
4. 下載進行中時，按鈕狀態變為「Downloading...」且 disabled
5. 全部完成後，按鈕消失（因為沒有缺少的了）

#### FR-3：下載進度顯示

1. 下載中的 model 卡片內顯示進度條（progress bar）
2. 進度條顯示百分比數值
3. 下載完成後，進度條消失，狀態切換為 ✅ 已存在
4. 後端透過 WebSocket 推送進度事件到前端

#### FR-4：下載錯誤處理與取消

1. 下載失敗時，卡片顯示錯誤訊息
2. 顯示「Retry」按鈕允許使用者重試
3. 批次下載時，失敗的模型不影響其他模型的下載（跳過失敗的，繼續下一個）
4. 網路中斷或 Civitai API 限流（429）時，顯示對應的錯誤提示
5. 下載中的模型可以取消：
   - 單一模型下載中，卡片內顯示「Cancel」按鈕
   - 批次下載時，「Download All Missing」按鈕區域顯示「Cancel All」按鈕
   - 取消時，刪除未完成的暫存檔案（使用 `.part` 副檔名寫入，完成後 rename），確保下次下載不會因殘留的不完整檔案而出問題
6. 下載完成後進行 SHA256 校驗：
   - Civitai API 的 model version 回應中，每個 file 物件包含 `hashes.SHA256` 欄位
   - 下載完成後計算本地檔案的 SHA256，與 API 提供的值比對
   - 校驗失敗時，刪除檔案並顯示「Checksum mismatch」錯誤，允許使用者 Retry
   - 校驗成功後才將 `.part` 檔案 rename 為正式檔名

#### FR-5：下載 API Endpoints

1. `POST /civitai/download`：接受單一 resource 資訊和 api_key，啟動下載任務
   - 使用 Civitai API Key 進行認證（複用現有 API Key 設定）
   - 下載到 ComfyUI 的對應 model 目錄（使用 `folder_paths` 確定路徑）
   - 寫入時使用 `.part` 副檔名，完成 SHA256 校驗後 rename 為正式檔名
   - 回傳 task ID 用於追蹤進度
2. `POST /civitai/download-all`：接受多個 resource 資訊和 api_key，依序下載
3. `POST /civitai/download-cancel`：取消指定 task ID 或全部進行中的下載
   - 取消時中斷 HTTP 連線，刪除對應的 `.part` 暫存檔案
4. 下載過程中透過 WebSocket 事件推送進度（使用 ComfyUI 的 `PromptServer.instance.send_sync()`）
   - 事件類型包含：`progress`、`completed`、`failed`、`cancelled`
5. 下載流程：下載 → `.part` 檔案 → SHA256 校驗 → rename → 完成通知

#### FR-6：下載非阻塞

1. 下載在後端以非同步方式執行，不阻塞 ComfyUI 的其他操作（prompt 排隊、node 計算等）
2. 使用者可以切換到其他 tab 再回來，進度狀態仍然正確

### Phase 4：Workflow 生成與載入

#### FR-7：Generate Workflow 按鈕

1. 在 Model 列表下方提供「Generate Workflow」按鈕
2. 必須先完成 metadata 查詢和 model 解析後才可用（否則 disabled）
3. 點擊後呼叫後端 API 生成 workflow

#### FR-8：Workflow 生成

1. `POST /civitai/generate`：接受 metadata 和 resources，回傳 ComfyUI API-format workflow JSON
2. 重用現有 `pipeline/generate_workflow.py` 的 `build_workflow()` 函式
3. 支援 txt2img 和 txt2img-hires 兩種 workflow 類型
4. 支援 LoRA 鏈、自訂 VAE、Embedding、CLIP skip、Upscaler

#### FR-9：Workflow 載入到 Canvas

1. 前端收到 workflow JSON 後，使用 ComfyUI 的 `app.loadGraphData()` API 載入到 canvas
2. 載入前清除目前 canvas 上的內容（等同開啟新的 workflow）
3. 載入成功後在 sidebar 顯示確認訊息

#### FR-10：缺少模型時的警告

1. 如果有模型處於「缺少」狀態，點擊 Generate Workflow 時顯示警告訊息
2. 警告內容列出缺少的模型名稱和類型
3. 使用者確認後仍可繼續生成 workflow
4. 生成的 workflow 中仍然使用原始的模型檔名（使用者可在 canvas 上手動替換）

### Phase 5：發佈準備

#### FR-11：GitHub Actions 自動化

1. 設定 GitHub Actions workflow，在建立 release tag 時自動發佈到 ComfyUI Registry
2. 發佈流程包含：前端建置（`npm run build`）、打包、發佈
3. CI 包含基本的 lint 和建置檢查

#### FR-12：前端建置產出納入版本控制

1. 將 `js/main.js`（建置後的前端檔案）納入 git 追蹤
2. 確保使用者透過 `git clone` 安裝時不需要自行建置前端
3. 更新 `.gitignore` 相應調整

#### FR-13：README 完善

1. 更新安裝說明，包含 ComfyUI Manager 安裝方式和手動安裝方式
2. 新增 sidebar extension 的使用教學（含截圖佔位符）
3. 新增支援的 workflow 類型說明
4. 更新 troubleshooting 區段

#### FR-14：版本號管理

1. `pyproject.toml` 中的版本號遵循 Semantic Versioning
2. 第一個正式版本為 `0.1.0`
3. 確保 `[tool.comfy]` 區段完整且符合 Registry 規格

## 非目標（超出範圍）

1. **img2img / inpainting / ControlNet workflow 支援**：只支援 txt2img 和 txt2img-hires
2. **模型管理功能**：不提供刪除、移動、重新命名模型等功能
3. **Workflow 編輯功能**：sidebar 不提供修改 workflow 參數的 UI，使用者需在 canvas 上修改
4. **多圖片批次處理**：一次只處理一張圖片
5. **下載佇列持久化**：重新啟動 ComfyUI 後，未完成的下載不會自動恢復
6. **付費模型處理**：如果模型需要 Civitai 付費方案才能下載，只顯示錯誤訊息，不處理付費流程
7. **單元測試或 E2E 測試**：本階段不包含自動化測試的建立（可作為未來改進）

## 設計考量

### UI 示意圖

以下 ASCII 示意圖展示 Phase 3-5 新增的互動狀態。Phase 1-2 的狀態（API Key 未設定、初始輸入、載入中）已在前期 PRD 定義，此處不重複。

#### 階段 3：結果展示 + 下載按鈕 + Generate Workflow 按鈕

查詢完成後，Generation Info 和 Model 列表顯示。缺少的 model 卡片帶有下載按鈕，底部有「Download All Missing」和「Generate Workflow」按鈕。

```
┌─────────────────────────────────┐
│  ⚗ Civitai Alchemist            │
├─────────────────────────────────┤
│                                 │
│  Image ID or URL                │
│  ┌───────────────────────┬────┐ │
│  │ 119258762             │ Go │ │
│  └───────────────────────┴────┘ │
│                                 │
│  ┌─────────────────────────┐   │
│  │ (image preview)         │   │
│  │                         │   │
│  └─────────────────────────┘   │
│                                 │
│  ── Generation Info ──────────  │
│  ▸ Prompt                       │
│  ▸ Negative Prompt              │
│                                 │
│  Sampler    DPM++ 2M Karras     │
│  Steps      30                  │
│  CFG Scale  7                   │
│  Seed       1234567890          │
│  Size       768 × 1152         │
│  Clip Skip  2                   │
│                                 │
│  ── Models (6) ───────────────  │
│                                 │
│  ✅ Marian_v18 · ckpt · 2.1 GB │
│     models/checkpoints/...      │
│                                 │
│  ❌ Detail Tweaker · lora · 144 │
│     ┌──────────────────────┐   │
│     │     ⬇ Download       │   │
│     └──────────────────────┘   │
│                                 │
│  ❌ epiCPhoto · lora · 56 MB   │
│     ┌──────────────────────┐   │
│     │     ⬇ Download       │   │
│     └──────────────────────┘   │
│                                 │
│  ✅ kl-f8-anime2 · vae · 335MB │
│     models/vae/...              │
│                                 │
│  ❌ lazyneg · embed · 25 KB    │
│     Cannot resolve              │
│                                 │
│  ✅ 4x-UltraSharp · upsc · 67M │
│     models/upscale_models/...   │
│                                 │
│  Missing: 3 of 6               │
│  ┌─────────────────────────┐   │
│  │  ⬇ Download All Missing  │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │  ▶ Generate Workflow     │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

#### 階段 4：下載中 — Model 卡片內進度條

點擊下載後，對應的 model 卡片顯示進度條和百分比，取代原本的 Download 按鈕。已完成的切換為 ✅ 狀態。

```
┌─────────────────────────────────┐
│  ── Models (6) ───────────────  │
│                                 │
│  ✅ Marian_v18 · ckpt · 2.1 GB │
│     models/checkpoints/...      │
│                                 │
│  ⏳ Detail Tweaker · lora · 144 │
│     ████████████░░░░░░░  67%   │
│     96.5 / 144.0 MB            │
│     ┌──────────────────────┐   │
│     │     ✕ Cancel          │   │
│     └──────────────────────┘   │
│                                 │
│  ❌ epiCPhoto · lora · 56 MB   │
│     Waiting...                  │
│                                 │
│  ✅ kl-f8-anime2 · vae · 335MB │
│     models/vae/...              │
│                                 │
│  ❌ lazyneg · embed · 25 KB    │
│     Cannot resolve              │
│                                 │
│  ✅ 4x-UltraSharp · upsc · 67M │
│     models/upscale_models/...   │
│                                 │
│  Missing: 3 of 6               │
│  ┌─────────────────────────┐   │
│  │  ⏳ Downloading... (1/2) │   │
│  └─────────────────────────┘   │
│  ┌─────────────────────────┐   │
│  │  ✕ Cancel All            │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │  ▶ Generate Workflow     │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

#### 下載失敗 — 錯誤狀態與 Retry 按鈕

下載失敗的 model 卡片顯示錯誤訊息和 Retry 按鈕。

```
│  ❌ Detail Tweaker · lora · 144 │
│     Error: Network timeout      │
│     ┌──────────────────────┐   │
│     │     ↻ Retry          │   │
│     └──────────────────────┘   │
```

#### 下載全部完成

所有可下載的 model 完成後，「Download All Missing」按鈕消失，缺少的只剩無法解析的。

```
│  ── Models (6) ───────────────  │
│                                 │
│  ✅ Marian_v18 · ckpt · 2.1 GB │
│     models/checkpoints/...      │
│                                 │
│  ✅ Detail Tweaker · lora · 144 │
│     models/loras/...            │
│                                 │
│  ✅ epiCPhoto · lora · 56 MB   │
│     models/loras/...            │
│                                 │
│  ✅ kl-f8-anime2 · vae · 335MB │
│     models/vae/...              │
│                                 │
│  ❌ lazyneg · embed · 25 KB    │
│     Cannot resolve              │
│                                 │
│  ✅ 4x-UltraSharp · upsc · 67M │
│     models/upscale_models/...   │
│                                 │
│  All downloadable models found  │
│                                 │
│  ┌─────────────────────────┐   │
│  │  ▶ Generate Workflow     │   │
│  └─────────────────────────┘   │
```

#### 階段 5：缺少模型時的 Generate Workflow 警告

點擊 Generate Workflow 時，如果有缺少的 model，先顯示警告。

```
│  ┌─────────────────────────┐   │
│  │ ⚠ Missing models:       │   │
│  │                          │   │
│  │ · lazyneg (embedding)    │   │
│  │                          │   │
│  │ Workflow will be         │   │
│  │ generated with original  │   │
│  │ filenames. You can       │   │
│  │ replace them on canvas.  │   │
│  │                          │   │
│  │ ┌────────┐ ┌──────────┐ │   │
│  │ │ Cancel │ │ Continue │ │   │
│  │ └────────┘ └──────────┘ │   │
│  └─────────────────────────┘   │
```

#### 階段 6：Workflow 生成完成

Workflow 載入到 canvas 後，顯示成功確認訊息。

```
│  ┌─────────────────────────┐   │
│  │  ✅ Workflow loaded       │   │
│  │                          │   │
│  │  20 nodes · txt2img-hires│   │
│  │  Loaded to canvas.       │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │  ▶ Generate Workflow     │   │
│  └─────────────────────────┘   │
```

#### Model 卡片七種狀態速覽

```
已存在：       ✅ ModelName · type · size
               models/subfolder/...

缺少(已解析)： ❌ ModelName · type · size
               [ ⬇ Download ]

缺少(未解析)： ❌ ModelName · type · size
               Cannot resolve

下載中：       ⏳ ModelName · type · size
               ████████░░░░░░  52%
               75.2 / 144.0 MB
               [ ✕ Cancel ]

校驗中：       ⏳ ModelName · type · size
               Verifying SHA256...

下載失敗：     ❌ ModelName · type · size
               Error: Network timeout
               [ ↻ Retry ]

已取消：       ❌ ModelName · type · size
               Cancelled
               [ ⬇ Download ]
```

> **下載流程**：下載至 `.part` 暫存檔 → SHA256 校驗 → rename 為正式檔名 → ✅
> 取消或校驗失敗時，`.part` 檔案會被刪除，不留殘檔。

### UI 狀態機擴展

在第一、二階段建立的 4 個 UI 狀態基礎上，擴展為完整的 7 個狀態：

- **階段 0**：API Key 未設定 → 提示訊息 + Open Settings 按鈕（已完成）
- **階段 1**：正常輸入狀態 → Image ID/URL 輸入欄位 + Go 按鈕（已完成）
- **階段 2**：載入中 → Spinner + 步驟文字（已完成）
- **階段 3**：結果展示 → Generation Info + Model 列表 + Download 按鈕 + Generate Workflow 按鈕（**Phase 3-4 新增**）
- **階段 4**：下載中 → Model 卡片內進度條（**Phase 3 新增**）
- **階段 5**：Workflow 生成中 → Generate 按鈕 disabled + Spinner（**Phase 4 新增**）
- **階段 6**：完成 → 確認訊息（Workflow 已載入到 canvas）（**Phase 4 新增**）

### Model 卡片狀態擴展

目前 ModelCard 有兩種狀態，擴展為五種：

| 狀態 | 視覺 | 操作 |
|------|------|------|
| 已存在 | ✅ + 路徑 | 無 |
| 缺少（已解析） | ❌ + Download 按鈕 | 可點擊下載 |
| 缺少（未解析） | ❌ + 「Cannot resolve」 | 無 |
| 下載中 | 進度條 + 百分比 | 無（等待完成） |
| 下載失敗 | ❌ + 錯誤訊息 + Retry 按鈕 | 可點擊重試 |

### CSS 風格延續

延續第一、二階段確立的 CSS 策略：

- 使用 ComfyUI 原生 CSS 變數（`--fg-color`、`--descrip-text`、`--border-color`、`--comfy-input-bg`）
- 不使用 PrimeVue tokens（`--p-text-color` 等），因為不會隨 ComfyUI 深色主題切換
- 進度條使用 PrimeVue `<ProgressBar>` 元件（ComfyUI Model Library 也使用此元件），自動適應深色/淺色主題

## 技術考量

### 來自第一、二階段的關鍵學習

以下是實作過程中遇到的問題和確立的技術決策，Phase 3-5 應繼續遵循：

1. **模組命名衝突**：`utils/` 已改名為 `civitai_utils/` 以避免與 ComfyUI 的 `utils` 衝突。新增的程式碼不可使用與 ComfyUI 內建模組相同的名稱
2. **路由註冊方式**：使用裝飾器模式（`@routes.post(...)`），不使用 `register_routes()` 函式
3. **CSS 注入**：已使用 `vite-plugin-css-injected-by-js` 解決 ComfyUI 不載入獨立 CSS 檔案的問題
4. **PrimeVue 主題不相容**：PrimeVue 的 CSS 變數不隨 ComfyUI 深色主題切換，所有新元件需使用 ComfyUI 原生 CSS 變數
5. **Sidebar render 重複呼叫**：`render` callback 會被多次呼叫，需要正確管理 Vue app 實例生命週期
6. **Vite library mode 的 `process.env`**：需在 vite config 中 `define` 替換，否則 Vue runtime 會在瀏覽器中報錯
7. **前端不可 import ComfyUI 的 `app.js`**：必須透過 `window.app` 全域物件存取 API

### 下載功能的技術方向

- 後端下載使用 Python `asyncio` 非同步執行，避免阻塞 aiohttp event loop
- 下載進度透過 ComfyUI 的 `PromptServer.instance.send_sync()` 推送 WebSocket 事件
- 前端使用 `window.app.api.addEventListener()` 監聯下載進度事件
- 下載目標路徑使用 `folder_paths` API 確定，確保與使用者的 ComfyUI model 目錄設定一致
- 現有 `ModelManager.download_file()` 可重用，但需適配非同步介面和進度回調

### Workflow 生成的技術方向

- 重用現有 `pipeline/generate_workflow.py` 的 `build_workflow()` 函式，不重新實作
- `build_workflow()` 已支援 txt2img 和 txt2img-hires，含 LoRA 鏈、自訂 VAE、Embedding 語法轉換等
- 前端使用 `app.loadGraphData()` 載入 workflow 到 canvas（需確認 API format 與 graph format 的轉換）
- 需要注意 `build_workflow()` 產生的是 API format（flat dict with node IDs），而 `loadGraphData()` 可能期望不同的 graph format，需在後端或前端做轉換

### 發佈的技術方向

- ComfyUI Registry 發佈透過 GitHub Actions，使用 `comfy-cli` 或 Registry API
- `js/main.js` 已在第二階段末期納入 git 追蹤（`14cd8f1` commit），git clone 安裝方式已可用
- `pyproject.toml` 的 `[tool.comfy]` 區段已設定好

## 開放問題

1. **`app.loadGraphData()` 的 workflow 格式**：ComfyUI 的 `loadGraphData()` 接受的是 graph format（包含 node 座標、link 資訊等）還是 API format（只有 node class 和 inputs）？如果是 graph format，需要在後端做 API format → graph format 的轉換，或使用 ComfyUI 的 `/prompt` endpoint 提交執行。
2. **大型模型下載的穩定性**：Checkpoint 模型通常 2-7 GB，下載時間可能超過 10 分鐘。需要確認 aiohttp 的 WebSocket 連線在長時間下載期間是否穩定，以及是否需要實作斷點續傳。
3. **Civitai 下載限流**：Civitai 的下載 API 是否有頻率限制？批次下載多個模型時是否需要加入延遲？
4. **ComfyUI Registry 發佈流程**：Registry 的具體發佈步驟和 API key 管理方式需要進一步研究確認。

## 參考資料

- [第一、二階段 PRD](../2026-01-31-sidebar-extension-phase1-2/prd.md)
- [第一、二階段實作記錄](../2026-01-31-sidebar-extension-phase1-2/implementation.md) — 包含已知技術問題和解決方案
- [ComfyUI Sidebar Extension 研究文件](../../research/2026-01-31-comfyui-sidebar-extension.md)
- [Civitai API Documentation](https://github.com/civitai/civitai/wiki/REST-API-Reference)
- [ComfyUI Registry Specifications](https://docs.comfy.org/registry/specifications)
- [ComfyUI Registry Publishing](https://docs.comfy.org/registry/publishing)
