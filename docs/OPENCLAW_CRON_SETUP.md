# OpenClaw Cron Setup - OpenClaw 定時任務設定

**最後更新：** 2026-03-06 10:46

---

## 🎯 目標

在 OpenClaw 中建立定時任務，每 10 分鐘：
1. 更新 Jarvis Group 數據
2. 生成快速結論
3. 透過 Telegram 傳送給用戶

---

## 📁 已建立腳本

| 腳本 | 路徑 | 說明 |
|------|------|------|
| **auto-monitor.sh** | `scripts/auto-monitor.sh` | 數據監控 |
| **quick-report.sh** | `scripts/quick-report.sh` | 快速結論報告 |
| **setup-cron.sh** | `scripts/setup-cron.sh` | Cron 安裝 |

---

## ⚙️ OpenClaw 定時任務選項

### 選項 1: 使用 OpenClaw HEARTBEAT.md

在 `~/.openclaw/workspace/HEARTBEAT.md` 添加：

```markdown
# Jarvis Group 定時檢查
- 每 10 分鐘檢查股價和能源價格
- 傳送快速結論到 Telegram
- 異常時立即警告
```

### 選項 2: 使用系統 Cron (已安裝)

當前 Cron 設定：
```bash
*/10 9-13 * * 1-5 /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-monitor.sh
```

### 選項 3: 使用 OpenClaw sessions_spawn

建立定時任務會話：
```javascript
// 在 OpenClaw 中執行
sessions_spawn({
  task: "每 10 分鐘更新 Jarvis Group 並傳送報告",
  runtime: "subagent",
  mode: "session"
})
```

---

## 📝 快速結論格式

```
📊 **Jarvis Group 快速報告** [時間]

**持股概況:**
• 006208: XXX TWD (X.XX%)
• MSFT: XXX USD (X.XX%)
• GOOGL: XXX USD (X.XX%)

**能源價格:**
• WTI 原油：XXX USD (X.XX%)
• 風險等級：GREEN/YELLOW/ORANGE/RED

**建倉狀態:**
• 006208 第 1 批：待確認
• 第 2 批觸發價：XXX TWD

**結論:**
✅ 市場穩定，可按計劃執行建倉

---
*下次更新：10 分鐘後*
```

---

## 🔧 建議實作方式

### 方法 A: 使用 OpenClaw 內建定時 (推薦)

在 OpenClaw 配置中添加定時任務：

1. 編輯 `~/.openclaw/openclaw.json`
2. 添加 cron 配置
3. 指定執行腳本和目標 channel

### 方法 B: 使用現有 Cron + Message 工具

修改 `quick-report.sh` 使用 OpenClaw message 工具：

```bash
# 在腳本末尾添加
openclaw message send \
  --target "telegram:5826922658" \
  --message "$REPORT"
```

### 方法 C: 使用 HEARTBEAT 機制

在 `HEARTBEAT.md` 添加檢查項目，讓 OpenClaw 定期執行。

---

## 📋 當前狀態

| 項目 | 狀態 |
|------|------|
| 監控腳本 | ✅ 已完成 |
| 快速報告腳本 | ✅ 已完成 |
| Cron 定時 | ✅ 已安裝 (系統層級) |
| OpenClaw 整合 | ⏳ 待配置 |
| Telegram 推送 | ⏳ 待配置 |

---

## 🚀 下一步

請選擇實作方式：

**A. OpenClaw 內建定時** - 需要修改 OpenClaw 配置
**B. Cron + Message 工具** - 需要配置 message 命令
**C. HEARTBEAT 機制** - 需要編輯 HEARTBEAT.md

---

*維護者：JARVIS | 建議：使用方法 B 或 C*
