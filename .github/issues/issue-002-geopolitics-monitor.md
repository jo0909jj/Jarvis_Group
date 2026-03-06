# [FEATURE] 地緣政治風險監控系統 - GEOPOLITICS Agent

---

## 📋 需求描述

創建專門的地緣政治風險監控 Agent，追蹤中東局勢、能源價格，評估對台灣半導體業及投資組合的影響。

## 🎯 用戶需求

> 「不及著買賣 你在創建一個子 agent 負責監控地緣政治的風險 目前主要關注伊朗戰爭狀況 要把天然氣和石油的價格考慮進去 因為會大大影響台灣的半導體業」

## 💬 Agent 討論

### 與會 Agent
- [x] JARVIS (決策者)
- [x] SENTINEL (安全審計)
- [x] NEXUS (系統整合)
- [x] GEOPOLITICS (新建)

### 討論重點

**SENTINEL:** 這本來就該是風險控管的一環。

**NEXUS:** 需要整合能源價格、地緣政治新聞、供應鏈影響分析。

**GEOPOLITICS:** 我會監控中東局勢、能源價格、兩岸關係、半導體供應鏈。

**風險閾值:**
- 🟢 GREEN: 原油<100 USD, 天然氣<5 USD
- 🟡 YELLOW: 原油>100 USD, 天然氣>5 USD
- 🟠 ORANGE: 原油>120 USD, 天然氣>8 USD
- 🔴 RED: 原油>150 USD, 天然氣>12 USD

## ✅ 驗收標準

- [x] 創建 GEOPOLITICS Agent (`agents/GEOPOLITICS.md`)
- [x] 建立監控專案 (`projects/geopolitical_risk/`)
- [x] 建立能源價格監控腳本 (`monitor_energy.js`)
- [x] 設定風險閾值警告
- [x] 整合 006208 建倉計劃
- [ ] 建立每日能源快報
- [ ] 建立每週地緣政治報告
- [ ] 整合新聞 API (待實作)

## 📎 相關檔案

- `agents/GEOPOLITICS.md`
- `projects/geopolitical_risk/PROJECT.md`
- `projects/geopolitical_risk/monitor_energy.js`
- `projects/geopolitical_risk/risk_log.json`
- `meetings/2026/2026-03-06_geopolitics-agent.md`

## 🏷️ 標籤

#GEOPOLITICS #地緣政治 #能源價格 #風險監控 #中東局勢

---

**優先級：** High  
**預計完成：** 2026-03-13  
**狀態：** 🟢 已完成 (持續監控中)
