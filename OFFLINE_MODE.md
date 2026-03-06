# Offline Mode - 離線模式說明

**最後更新：** 2026-03-06 11:28

---

## 🎯 目標

確保在網路中斷時系統穩定運作，不崩潰、不報錯，網路恢復後自動補發。

---

## 📊 系統行為

### 正常模式 (Online)

```
✅ 每 10 分鐘查詢股價
✅ 每 10 分鐘查詢能源價格
✅ 每 10 分鐘傳送 Telegram 報告
✅ 每 10 分鐘生成 Agent 嘴砲內容
✅ 記錄日誌
```

### 離線模式 (Offline)

```
⚠️ 檢測到網路斷線
⏸️ 暫停 API 查詢（避免超時）
⏸️ 暫停 Telegram 推送（避免失敗）
✅ 繼續記錄本地日誌
✅ 記錄離線開始時間
✅ 累計錯失報告次數
🔄 持續檢測網路狀態
```

### 網路恢復 (Recovery)

```
✅ 檢測到網路恢復
📊 發送恢復通知
📊 補發錯失報告摘要
✅ 恢復正常運作
✅ 重置離線狀態
```

---

## 🔧 技術實作

### 網路檢測

```bash
# 使用 ping 檢測
ping -c 1 -W 2 8.8.8.8

# 返回：online 或 offline
```

### 狀態管理

```json
{
  "status": "online/offline",
  "offline_start": "2026-03-06 11:30:00",
  "missed_reports": 3,
  "cached_data": []
}
```

### 錯誤容限

- API 查詢失敗 → 記錄錯誤，繼續執行
- Telegram 推送失敗 → 記錄錯誤，不中斷
- 腳本執行失敗 → 記錄日誌，下次重試

---

## 📁 相關檔案

| 檔案 | 說明 |
|------|------|
| `scripts/offline-handler.sh` | 離線處理主腳本 |
| `scripts/auto-telegram-report.sh` | 整合離線處理的報告腳本 |
| `logs/.offline_state.json` | 離線狀態文件 |
| `logs/network-events-*.log` | 網路事件日誌 |

---

## 📝 日誌記錄

### 離線開始

```
[2026-03-06 11:30:00] OFFLINE_START: Network disconnected at 2026-03-06 11:30:00
```

### 離線期間

```
[2026-03-06 11:40:00] OFFLINE_CONTINUES: Missed report #1
[2026-03-06 11:50:00] OFFLINE_CONTINUES: Missed report #2
```

### 網路恢復

```
[2026-03-06 12:00:00] ONLINE_RESTORED: Network restored at 2026-03-06 12:00:00, missed 3 reports
```

---

## 🔔 通知機制

### 離線時不推送

避免在離線時嘗試推送導致錯誤累積。

### 恢復時推送摘要

```
🔔 **Jarvis Group 網路恢復通知**

**離線期間:** 2026-03-06 11:30:00 至 2026-03-06 12:00:00
**錯失報告:** 3 次

**當前狀態:**
• 006208: 179.25 TWD
• 風險等級：GREEN

**結論:**
✅ 系統已恢復正常運作
📊 下次報告將按時發送
```

---

## 🛡️ 錯誤處理

### Cron 腳本錯誤

```bash
# 即使腳本失敗，Cron 會繼續執行
# 錯誤記錄到日誌，不影響下次執行
```

### API 超時

```bash
# 設定超時時間
node fetch_all.js 2>&1 | grep -v "survey\|bit.ly\|github.com" > "$PORTFOLIO_FILE" || echo "{}" > "$PORTFOLIO_FILE"

# 失敗時使用空數據，不中斷流程
```

### Telegram 推送失敗

```bash
# 推送失敗不影響主流程
openclaw message send ... 2>/dev/null || echo "Failed to send"
```

---

## 📋 用戶體驗

### 斷網期間

- ❌ 不會收到定時報告
- ❌ 不會收到錯誤訊息
- ✅ 系統持續運行（本地）
- ✅ 日誌持續記錄

### 網路恢復

- ✅ 收到恢復通知
- ✅ 得知錯失報告次數
- ✅ 看到當前最新狀態
- ✅ 系統恢復正常推送

---

## 🎯 建議設定

### Cron 設定（已配置）

```bash
*/10 9-13 * * 1-5 /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-telegram-report.sh >> /home/user/.openclaw/workspace/Jarvis_Group/logs/telegram-cron.log 2>&1
```

### 離線處理（已整合）

- 自動檢測網路狀態
- 自動進入離線模式
- 自動恢復並補發

---

## 🔍 查看離線狀態

```bash
# 查看當前離線狀態
cat /home/user/.openclaw/workspace/Jarvis_Group/logs/.offline_state.json

# 查看網路事件日誌
tail -f /home/user/.openclaw/workspace/Jarvis_Group/logs/network-events-$(date +%Y-%m-%d).log

# 查看錯失報告次數
jq '.missed_reports' /home/user/.openclaw/workspace/Jarvis_Group/logs/.offline_state.json
```

---

## 🚨 常見問題

### Q: 斷網時系統會崩潰嗎？

**A:** 不會。系統會進入離線模式，繼續本地運作。

### Q: 錯失的報告會補發嗎？

**A:** 會。網路恢復時會發送摘要通知。

### Q: 如何手動檢查離線狀態？

**A:** 查看 `.offline_state.json` 文件。

### Q: 離線模式會影響 Cron 嗎？

**A:** 不會。Cron 會繼續執行，腳本會自動檢測網路狀態。

---

*維護者：JARVIS | 系統已整合離線處理機制*
