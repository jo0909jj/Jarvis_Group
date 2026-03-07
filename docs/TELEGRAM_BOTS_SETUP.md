# Telegram Bot 設置指南

## 📋 步驟 1：透過 BotFather 創建 7 個 Bot

### 操作方式：

1. **打開 Telegram**，搜尋 `@BotFather`
2. 發送 `/start` 開始對話
3. 發送 `/newbot` 創建新 Bot

### 需要創建的 Bot 清單：

| 序號 | Bot 名稱 | Bot Username | 職責 |
|------|---------|-------------|------|
| 1 | Jarvis Group | `JarvisGroupBot` | 主 Bot，投資報告、決策協調 |
| 2 | Athena Analyst | `AthenaAnalystBot` | 研究分析、數據報告 |
| 3 | Blaze Creative | `BlazeCreativeBot` | 創意發想、腦力激盪 |
| 4 | Sentinel Security | `SentinelSecBot` | 安全警告、風險評估 |
| 5 | Nexus System | `NexusSystemBot` | 系統整合、技術支援 |
| 6 | Echo Communication | `EchoComBot` | 用戶溝通、通知推送 |
| 7 | Geopolitics Risk | `GeopoliticsRiskBot` | 地緣政治、國際情勢 |

### 創建流程（重複 7 次）：

```
你：/newbot
BotFather: Choose a name for your bot
你：Jarvis Group
BotFather: Now choose a username for your bot
你：JarvisGroupBot
BotFather: Success! Your bot token is: 1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
```

### ⚠️ 重要：
- **Username 必須以 `bot` 結尾**
- **Token 要保密**，不要公開分享
- 把每個 Bot 的 Token 記下來

---

## 📋 步驟 2：填入 Token 到 .env 文件

編輯文件：
```bash
nano /home/user/.openclaw/workspace/Jarvis_Group/.env
```

填入對應的 Token：
```bash
TELEGRAM_JARVIS_TOKEN="1234567890:ABCdefGHIjklMNOpqrsTUVwxyz"
TELEGRAM_ATHENA_TOKEN="..."
TELEGRAM_BLAZE_TOKEN="..."
...
```

---

## 📋 步驟 3：測試 Bot

發送訊息測試：
```bash
cd /home/user/.openclaw/workspace/Jarvis_Group
bash scripts/test-bot.sh JARVIS "Hello"
```

---

## 📋 步驟 4：邀請 Bot 到對話（可選）

如果你想讓 Bot 加入群組：
1. 打開群組
2. 點擊群組名稱 → 添加成員
3. 搜尋 Bot 的 Username（如 `@JarvisGroupBot`）
4. 添加並設定權限

---

## 🔧 常見問題

### Q: Bot 沒有回應？
A: 檢查 Token 是否正確填入 .env 文件

### Q: 創建 Bot 失敗？
A: Username 可能已被使用，嘗試加底線或數字（如 `Jarvis_Group_Bot`）

### Q: 如何刪除 Bot？
A: 發送 `/deletebot` 給 BotFather，選擇要刪除的 Bot

---

*最後更新：2026-03-07*
