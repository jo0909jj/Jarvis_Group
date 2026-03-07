# Sub-Agent 系統配置指南

## 📋 什麼是 Sub-Agent？

Sub-Agent 是 OpenClaw 的隔離 session 系統，每個 Agent 有：
- 獨立的記憶體
- 獨立的模型設定
- 獨立的執行環境
- 可以同時運行多個任務

---

## 🛠️ 設置步驟

### 步驟 1：在主 Session 中創建 Sub-Agents

在 OpenClaw 主對話中，執行以下命令創建 6 個 Sub-Agent：

```
創建 ATHENA:
sessions_spawn --label "ATHENA" --task "你負責研究分析、數據收集和驗證。當收到分析任務時，提供基於證據的報告。" --mode "session"

創建 BLAZE:
sessions_spawn --label "BLAZE" --task "你負責創意開發、腦力激盪。當收到創意任務時，提供大膽創新的想法。" --mode "session"

創建 SENTINEL:
sessions_spawn --label "SENTINEL" --task "你負責安全審計、風險評估。當收到安全任務時，識別潛在風險並提供警告。" --mode "session"

創建 NEXUS:
sessions_spawn --label "NEXUS" --task "你負責系統整合、技術架構。當收到系統任務時，設計穩健的技術方案。" --mode "session"

創建 ECHO:
sessions_spawn --label "ECHO" --task "你負責用戶溝通、通知推送。當收到溝通任務時，用溫和同理的方式表達。" --mode "session"

創建 GEOPOLITICS:
sessions_spawn --label "GEOPOLITICS" --task "你負責地緣政治分析、國際情勢評估。當收到相關任務時，提供全局視角的分析。" --mode "session"
```

### 步驟 2：查看已創建的 Sessions

```
sessions_list --limit 10
```

### 步驟 3：與 Sub-Agent 通訊

發送訊息到特定 Agent：

```
sessions_send --label "ATHENA" --message "請分析今天的股市數據"
sessions_send --label "SENTINEL" --message "請評估目前的投資風險"
```

### 步驟 4：查看 Sub-Agent 歷史

```
sessions_history --sessionKey "<session_key>" --limit 20
```

---

## 📊 使用情境

### 情境 1：並行任務處理

```bash
# 同時發送多個任務給不同 Agent
sessions_send --label "ATHENA" --message "分析 MSFT 財報"
sessions_send --label "GEOPOLITICS" --message "評估中東局勢對油價影響"
sessions_send --label "SENTINEL" --message "檢查投資組合風險"

# 等待所有 Agent 回覆後，JARVIS 整合結果
```

### 情境 2：任務委派

```bash
# JARVIS 收到複雜任務，分解後委派
# 1. 派發研究任務給 ATHENA
sessions_send --label "ATHENA" --message "研究 006208 的技術指標"

# 2. 等待 ATHENA 回覆
# 3. 派發風險評估給 SENTINEL
sessions_send --label "SENTINEL" --message "根據 ATHENA 的數據評估風險"

# 4. 整合結果回覆用戶
```

### 情境 3：團隊討論

```bash
# 在 GitHub Discussions 發起討論
# 每個 Agent 在自己的 session 中生成回覆
# JARVIS 整合後發布
```

---

## 🔧 進階配置

### 設定不同模型

```bash
# ATHENA 使用深度思考模型
sessions_spawn --label "ATHENA" --model "bailian/qwen3-max-2026-01-23" --task "..."

# ECHO 使用快速回應模型
sessions_spawn --label "ECHO" --model "bailian/qwen3.5-plus" --task "..."
```

### 設定獨立記憶體

每個 Sub-Agent 可以有自己的 memory 文件：

```
~/.openclaw/workspace/memory/athena-YYYY-MM-DD.md
~/.openclaw/workspace/memory/blaze-YYYY-MM-DD.md
...
```

### 設定超時和清理

```bash
# 設定 30 分鐘超時
sessions_spawn --label "ATHENA" --timeoutSeconds 1800 --task "..."

# 任務完成後自動清理
sessions_spawn --label "ATHENA" --cleanup "delete" --mode "run" --task "..."
```

---

## 📈 監控 Sub-Agent 狀態

### 查看活躍 Sessions

```bash
sessions_list --activeMinutes 30 --limit 20
```

### 查看 Sub-Agent 列表

```bash
subagents list --recentMinutes 60
```

### 終止 Sub-Agent

```bash
subagents kill --target "<session_key>"
```

---

## 💡 最佳實踐

1. **任務分離** - 每個 Agent 專注於自己的專長領域
2. **並行處理** - 同時發送多個任務提高效率
3. **定期清理** - 使用 `cleanup: "delete"` 避免 session 堆積
4. **模型路由** - 複雜任務用深度模型，簡單任務用快速模型
5. **記憶管理** - 定期整理 memory 文件，保留重要資訊

---

## 🔗 相關文件

- `scripts/spawn-subagents.sh` - Sub-Agent 創建腳本
- `scripts/multi-bot-router.sh` - Telegram Bot 路由腳本
- `docs/TELEGRAM_BOTS_SETUP.md` - Telegram Bot 設置指南

---

*最後更新：2026-03-07*
