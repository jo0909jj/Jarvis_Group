# [FEATURE] 投資組合整合 - 006208/MSFT/GOOGL 統一監控

---

## 📋 需求描述

整合用戶所有持股 (006208、MSFT、GOOGL) 到統一投資組合視圖，提供即時價格、損益計算、風險曝險分析。

## 🎯 用戶需求

> 「我還有持倉 MSFT 和 ALPHABET INC A 這也加入持股」

## 💬 Agent 討論

### 與會 Agent
- [x] JARVIS (決策者)
- [x] NEXUS (系統整合)
- [x] GEOPOLITICS (風險評估)
- [x] SENTINEL (安全審計)
- [x] ECHO (用戶溝通)

### 討論重點

**NEXUS:** 需要整合台股和美股，統一查詢介面。

**GEOPOLITICS:** 這改變了風險敞口。美股科技股對中美科技戰敏感。

**SENTINEL:** 建議重新評估整體風險配置。科技股集中度可能過高。

**ECHO:** 需要向用戶確認持倉數量和成本。

## ✅ 驗收標準

- [x] 創建 portfolio 專案目錄 (`projects/portfolio/`)
- [x] 建立統一查詢腳本 (`fetch_all.js`)
- [x] 建立持倉追蹤 (`holdings.json`)
- [x] 建立投資組合總覽 (`PORTFOLIO.md`)
- [x] 整合 USD/TWD 匯率
- [ ] 用戶提供 MSFT 持倉細節 (股數、成本)
- [ ] 用戶提供 GOOGL 持倉細節 (股數、成本)
- [ ] 計算未實現損益
- [ ] 建立資產配置圖表

## 📎 相關檔案

- `projects/portfolio/PORTFOLIO.md`
- `projects/portfolio/holdings.json`
- `projects/portfolio/fetch_all.js`
- `meetings/2026/2026-03-06_portfolio-update.md`

## 🏷️ 標籤

#投資組合 #MSFT #GOOGL #006208 #美股 #台股

---

**優先級：** Medium  
**預計完成：** 2026-03-10  
**狀態：** 🟡 進行中 (等待用戶提供持倉細節)
