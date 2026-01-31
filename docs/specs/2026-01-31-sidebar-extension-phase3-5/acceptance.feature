# language: zh-TW
功能: Civitai Alchemist Sidebar Extension（第三、四、五階段）
  作為 ComfyUI 使用者
  我想要在 ComfyUI sidebar 中下載缺少的模型、生成 workflow 並載入到 canvas
  以便完成從「看圖」到「出圖」的完整流程，全程不離開 ComfyUI 介面

  背景:
    假設 ComfyUI 已啟動且 Civitai Alchemist extension 已安裝
    並且 extension 的前端 JS 已建置完成（js/main.js 存在）
    並且 API key 已正確設定

  # ── Phase 3：模型下載 ──────────────────────────────

  場景: 缺少的 model 顯示 Download 按鈕
    假設 使用者已查詢 image ID 並看到 model 列表
    當 model 列表中有缺少（❌）且已解析的 model
    那麼 該 model 卡片應顯示「Download」按鈕
    並且 已存在（✅）的 model 卡片不應顯示「Download」按鈕
    並且 無法解析的 model 卡片應顯示「Cannot resolve」而非 Download 按鈕

  場景: Download All Missing 按鈕顯示條件
    假設 使用者已查詢 image ID 並看到 model 列表
    當 model 列表中有缺少且已解析的 model
    那麼 應該看到「Download All Missing」按鈕
    當 所有 model 都已存在
    那麼 不應該看到「Download All Missing」按鈕

  場景: 單一模型下載 — 成功流程
    假設 使用者已查詢 image ID 並看到 model 列表
    並且 有一個缺少的 model（例如某個 LoRA）
    當 使用者點擊該 model 卡片上的「Download」按鈕
    那麼 該卡片應顯示進度條和百分比
    並且 該卡片應顯示已下載量和總量（例如「96.5 / 144.0 MB」）
    並且 該卡片應顯示「Cancel」按鈕
    當 下載完成後
    那麼 進度條應消失
    並且 該 model 狀態應變為 ✅ 已存在
    並且 應顯示本地檔案路徑

  場景: 批次下載 — 依序下載多個模型
    假設 使用者已查詢 image ID 並看到 model 列表
    並且 有 2 個以上缺少且已解析的 model
    當 使用者點擊「Download All Missing」按鈕
    那麼 「Download All Missing」按鈕應變為「Downloading... (1/N)」且 disabled
    並且 應該顯示「Cancel All」按鈕
    並且 第一個缺少的 model 卡片應顯示進度條
    並且 其他等待中的 model 卡片應顯示「Waiting...」
    當 第一個 model 下載完成後
    那麼 該 model 狀態應變為 ✅ 已存在
    並且 下一個缺少的 model 應開始下載（顯示進度條）
    並且 按鈕文字應更新為「Downloading... (2/N)」
    當 所有可下載的 model 都完成後
    那麼 「Download All Missing」按鈕和「Cancel All」按鈕應消失
    並且 摘要文字應更新為反映新的 missing count

  場景: 下載期間不阻塞 ComfyUI
    假設 有模型正在下載中
    當 使用者切換到 ComfyUI 的其他 tab（例如 Queue 或 Node Library）
    那麼 下載應該繼續在背景進行
    當 使用者切回 Civitai Alchemist tab
    那麼 下載進度應正確顯示（不會重置為 0%）

  場景: 取消單一模型下載
    假設 有模型正在下載中
    當 使用者點擊該 model 卡片上的「Cancel」按鈕
    那麼 下載應立即停止
    並且 不完整的暫存檔案（.part）應被刪除
    並且 該 model 卡片應顯示「Cancelled」狀態
    並且 該 model 卡片應重新顯示「Download」按鈕（可以重新下載）

  場景: 取消批次下載
    假設 使用者已點擊「Download All Missing」且下載正在進行
    當 使用者點擊「Cancel All」按鈕
    那麼 目前正在下載的模型應停止下載
    並且 等待中的模型應不再開始下載
    並且 所有未完成的 .part 暫存檔案應被刪除
    並且 已完成下載的模型應保持 ✅ 狀態（不會回退）

  場景: 下載失敗 — 顯示錯誤和 Retry
    假設 使用者開始下載某個模型
    當 下載因網路中斷或伺服器錯誤而失敗
    那麼 該 model 卡片應顯示錯誤訊息（例如「Network timeout」）
    並且 該 model 卡片應顯示「Retry」按鈕
    並且 不完整的暫存檔案（.part）應被刪除
    當 使用者點擊「Retry」按鈕
    那麼 應該重新開始下載該模型

  場景: 批次下載中某個模型失敗不影響其他
    假設 使用者已點擊「Download All Missing」且有 3 個模型要下載
    當 第一個模型下載失敗
    那麼 該模型應顯示錯誤訊息和 Retry 按鈕
    並且 下載應自動跳到第二個模型繼續
    並且 第二和第三個模型仍然正常依序下載

  場景: SHA256 校驗 — 成功
    假設 使用者開始下載某個模型
    當 下載完成
    那麼 卡片應短暫顯示「Verifying SHA256...」狀態
    並且 校驗通過後，model 狀態變為 ✅ 已存在

  場景: SHA256 校驗 — 失敗
    假設 使用者下載的模型檔案校驗不通過
    那麼 該 model 卡片應顯示「Checksum mismatch」錯誤訊息
    並且 不完整或損壞的檔案應被刪除
    並且 應顯示「Retry」按鈕讓使用者重新下載

  # ── Phase 4：Workflow 生成與載入 ─────────────────

  場景: Generate Workflow 按鈕可見
    假設 使用者已查詢 image ID 並看到結果
    那麼 應該在 model 列表下方看到「Generate Workflow」按鈕

  場景: 所有模型已存在時生成 Workflow
    假設 使用者已查詢 image ID 並看到結果
    並且 所有 model 都已存在（✅）
    當 使用者點擊「Generate Workflow」按鈕
    那麼 按鈕應變為 disabled 並顯示 loading 狀態
    當 workflow 生成並載入完成後
    那麼 ComfyUI canvas 上應出現完整的 node graph
    並且 sidebar 應顯示確認訊息（包含 node 數量和 workflow type）

  場景: 有缺少模型時生成 Workflow — 顯示警告
    假設 使用者已查詢 image ID 並看到結果
    並且 有部分 model 缺少（❌）
    當 使用者點擊「Generate Workflow」按鈕
    那麼 應該看到警告對話框
    並且 警告應列出缺少的 model 名稱和類型
    並且 警告應說明 workflow 將使用原始檔名
    並且 應看到「Cancel」和「Continue」按鈕

  場景: 有缺少模型時 — 使用者選擇繼續
    假設 使用者看到缺少模型的警告對話框
    當 使用者點擊「Continue」按鈕
    那麼 系統應生成 workflow 並載入到 canvas
    並且 canvas 上的 workflow 應使用原始的模型檔名

  場景: 有缺少模型時 — 使用者選擇取消
    假設 使用者看到缺少模型的警告對話框
    當 使用者點擊「Cancel」按鈕
    那麼 不應生成 workflow
    並且 應回到之前的結果展示狀態

  場景: Workflow 類型正確識別
    假設 API key 已正確設定
    當 使用者查詢 image ID "116872916"（基本 txt2img）
    並且 生成 workflow
    那麼 確認訊息應顯示 workflow type 為 txt2img
    當 使用者查詢 image ID "118577644"（hires fix）
    並且 生成 workflow
    那麼 確認訊息應顯示 workflow type 包含 hires

  場景: 更換查詢後重新生成 Workflow
    假設 使用者已查詢 image ID 並生成了 workflow
    當 使用者輸入新的 image ID 並點擊 Go
    並且 新的查詢完成後點擊「Generate Workflow」
    那麼 canvas 應載入新的 workflow（取代前一個）

  # ── Phase 5：發佈準備 ─────────────────────────────

  場景: js/main.js 已納入版本控制
    那麼 `js/main.js` 應存在於 git 追蹤中
    並且 使用者透過 `git clone` 取得專案後不需要自行建置前端

  場景: pyproject.toml 符合 ComfyUI Registry 規格
    那麼 pyproject.toml 應包含 `[tool.comfy]` 區段
    並且 應包含 `PublisherId` 和 `DisplayName` 欄位
    並且 `includes` 應包含 `js/` 目錄
    並且 版本號應為語義化版本（Semantic Versioning）

  場景: GitHub Actions 發佈 workflow 存在
    那麼 `.github/workflows/publish.yml` 應存在
    並且 應設定為在 tag push 時觸發
    並且 workflow 步驟應包含前端建置和發佈

  場景: README 包含完整安裝說明
    那麼 README.md 應包含 ComfyUI Manager 安裝方式
    並且 應包含手動安裝方式（git clone）
    並且 應包含 sidebar extension 的使用教學
    並且 應包含支援的 workflow 類型說明

  # ── 完整流程驗證 ─────────────────────────────────

  場景: 端到端完整流程 — 查詢、下載、生成
    假設 API key 已正確設定
    當 使用者輸入 image ID（含有缺少的 model）
    並且 點擊 Go 按鈕
    並且 等待查詢完成
    那麼 應該看到 generation info 和 model 列表
    當 使用者點擊「Download All Missing」
    並且 等待所有下載完成
    那麼 所有可下載的 model 應變為 ✅
    當 使用者點擊「Generate Workflow」
    那麼 canvas 應載入完整的 workflow
    並且 workflow 中的 node 應引用已下載的模型檔案

  場景: 已知測試圖片的 Workflow 生成驗證
    假設 API key 已正確設定
    當 使用者依序查詢以下 image ID 並生成 workflow：
      | Image ID  | Workflow Type   | 特徵                    |
      | 116872916 | txt2img         | 基本 txt2img + LoRAs    |
      | 118577644 | txt2img-hires   | Hires fix, 7 LoRAs      |
      | 119258762 | txt2img-hires   | Custom VAE, embeddings   |
    那麼 每個 workflow 都應成功載入到 canvas
    並且 workflow type 應正確顯示
