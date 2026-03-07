# ⚠️ Sub-Agent 創建問題說明

**時間：** 2026-03-07 09:40  
**狀態：** 🟡 部分完成

---

## 問題

嘗試創建 Sub-Agent Sessions 時遇到 Gateway 認證錯誤：

```
gateway closed (1008): unauthorized: gateway token mismatch
```

---

## 已執行的命令

```bash
sessions_spawn --label "ATHENA" --task "..." --mode "session" --thread true
sessions_spawn --label "BLAZE" --task "..." --mode "session" --thread true
sessions_spawn --label "SENTINEL" --task "..." --mode "session" --thread true
sessions_spawn --label "NEXUS" --task "..." --mode "session" --thread true
```

---

## 可能原因

1. **Gateway Token 過期** - 需要重新認證
2. **Gateway 服務未運行** - 需要重啟 Gateway
3. **配置文件問題** - `~/.openclaw/openclaw.json` 需要更新

---

## 解決方式

### 方式 1：重啟 Gateway

```bash
openclaw gateway restart
```

然後重新執行創建命令。

### 方式 2：使用 Run 模式（臨時方案）

如果只需要單次任務，可以使用 `mode: "run"`：

```bash
sessions_spawn --label "ATHENA" --task "分析 MSFT 財報" --mode "run"
```

### 方式 3：手動創建（推薦）

在 OpenClaw 主對話中直接執行：

```
/sessions_spawn --label "ATHENA" --task "你負責研究分析" --mode "session" --thread true
```

---

## 當前系統狀態

| 系統 | 狀態 |
|------|------|
| Telegram Bots | ✅ 5 個正常運行 |
| 多 Bot 路由 | ✅ 正常 |
| 自動報告 | ✅ 每 10 分鐘 |
| GitHub Push | ✅ 正常 |
| **Sub-Agent Sessions** | 🟡 **待創建** |

---

## 建議

**Sub-Agent 系統是可選功能**。目前 Telegram Bot 系統已經完全運行，可以正常接收報告。

如果你想創建 Sub-Agent Sessions：

1. **重啟 Gateway**：`openclaw gateway restart`
2. **重新執行創建命令**
3. **或使用 OpenClaw UI 直接創建**

---

*最後更新：2026-03-07 09:40*
