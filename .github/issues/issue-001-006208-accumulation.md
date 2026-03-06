# [FEATURE] 006208 富邦台 50 建倉計劃 - 400 萬資金分批進場

---

## 📋 需求描述

建立自動化建倉系統，以 400 萬資金分批買入 006208 富邦台 50 ETF，目標最小化平均進場成本。

## 🎯 用戶需求

> 「我最近在建倉富邦台 50 006208 目前資金還有 400 萬 目標是買進最低的價格 這是我的需求」

## 💬 Agent 討論

### 與會 Agent
- [x] JARVIS (決策者)
- [x] ATHENA (研究分析)
- [x] BLAZE (創意開發)
- [x] SENTINEL (安全審計)
- [x] NEXUS (系統整合)
- [x] ECHO (用戶溝通)

### 討論重點

**ATHENA:** 要精確抓最低點幾乎不可能，建議分批進場。

**SENTINEL:** ⚠️ 建議保留 10% 預備金，不要全部投入。

**NEXUS:** 建議 5 批次，每批 20%，按跌幅觸發。

**BLAZE:** 🔥 可以加入 RSI 指標作為額外觸發條件！

**最終決策:**
- 360 萬投資 (90%) + 40 萬預備金 (10%)
- 5 批次，每批 72 萬
- 觸發條件：市價、下跌 5%/10%/15%/20%

## ✅ 驗收標準

- [x] 建立專案結構 (`projects/006208_accumulation/`)
- [x] 撰寫策略文件 (`PROJECT.md`, `strategy.md`)
- [x] 建立持倉追蹤 (`holdings.json`)
- [x] 整合 Yahoo Finance API (`fetch_price.js`)
- [x] 設定五批次目標價位
- [ ] 用戶確認第 1 批買入
- [ ] 建立定時監控 (cron job)
- [ ] 每週報告生成

## 📎 相關檔案

- `projects/006208_accumulation/PROJECT.md`
- `projects/006208_accumulation/strategy.md`
- `projects/006208_accumulation/holdings.json`
- `projects/006208_accumulation/fetch_price.js`
- `meetings/2026/2026-03-06_project-setup.md`

## 🏷️ 標籤

#006208 #建倉計劃 #ETF #台股 #分批進場

---

**優先級：** High  
**預計完成：** 2026-03-13  
**狀態：** 🟡 進行中 (等待用戶確認第 1 批買入)
