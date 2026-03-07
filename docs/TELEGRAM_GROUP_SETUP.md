# Telegram 群組配置指南

## 🎯 目標

讓所有 5 個 Jarvis Group Bot 加入同一個 Telegram 群組，實現「團隊討論」效果。

---

## 📋 步驟 1：創建群組並添加 Bot

### 在 Telegram 中：

1. **創建新群組**
   - 點擊右上角選單 → New Group
   - 添加至少一個成員（可以先加朋友或另一個帳號）
   - 設定群組名稱（如 "Jarvis Group HQ"）

2. **添加 5 個 Bot**
   - 點擊群組名稱 → Add Members
   - 搜尋並添加：
     - `@JarvisGroupBot`
     - `@AthenaAnalystBot`
     - `@BlazeCreativeBot`
     - `@SentinelSecBot`
     - `@NexusSystemBot`

3. **設置管理員權限**（可選）
   - 點擊每個 Bot → 設置為管理員
   - 允許權限：發送訊息、刪除訊息

---

## 📋 步驟 2：獲取群組 ID

### 方法 A：使用腳本（推薦）

```bash
cd /home/user/.openclaw/workspace/Jarvis_Group

# 1. 在群組中發送任意訊息
# 2. 執行腳本
bash scripts/get-group-id.sh --fetch

# 3. 複製輸出的群組 ID（如：-1001234567890）
```

### 方法 B：使用 @userinfobot

1. 把群組轉發給 `@userinfobot`
2. 它會回覆群組 ID

### 方法 C：手動獲取

```bash
curl -s "https://api.telegram.org/bot8672626509:AAFLxu9Q-_taHmXrJEQjNoWhn41fBFht8a0/getUpdates" | jq '.result[-1].message.chat'
```

---

## 📋 步驟 3：配置群組 ID

編輯 `.env` 文件：

```bash
nano /home/user/.openclaw/workspace/Jarvis_Group/.env
```

添加：

```bash
TELEGRAM_GROUP_ID="-1001234567890"  # 替換為實際 ID
```

---

## 📋 步驟 4：測試群組發送

```bash
# 測試發送訊息
bash scripts/send-to-group.sh "🤖 Jarvis Group 測試訊息"
```

---

## 🔄 進階：群組自動報告

如果要讓自動報告發送到群組，修改腳本：

### 修改 `auto-telegram-report-v2.sh`

在文件中添加群組發送邏輯，或創建新的群組專用腳本。

---

## 💡 使用情境

### 情境 1：團隊討論

在群組中 @特定 Bot：
- "@AthenaBot 請分析今天的股市"
- "@SentinelBot 風險評估如何？"

### 情境 2：自動報告

設定定時任務發送報告到群組。

### 情境 3：Bot 互相回應

可以設定 Bot 監聽群組訊息並回應。

---

## ⚠️ 注意事項

1. **隱私設置**
   - 確保 Bot 隱私模式設置正確
   - 群組可以設置為私有

2. **權限管理**
   - 建議設置 Bot 為管理員
   - 限制刪除訊息權限

3. **訊息頻率**
   - 避免過於頻繁發送
   - Telegram 有速率限制

---

## 🔗 相關腳本

| 腳本 | 功能 |
|------|------|
| `get-group-id.sh` | 獲取群組 ID |
| `send-to-group.sh` | 發送訊息到群組 |

---

*最後更新：2026-03-07*
