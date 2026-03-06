# Jarvis Group 🤖

**AI Agent Collective - Managed by JARVIS**

---

## 🎯 概述

Jarvis Group 是一個多 agent 協作系統，由 JARVIS 擔任主管，協調 6 個不同專長和性格的子 agent 共同完成任務。

**核心功能：**
- ✅ 投資組合監控 (006208、MSFT、GOOGL)
- ✅ 能源價格追蹤 (WTI、天然氣)
- ✅ 地緣政治風險評估
- ✅ 自動化報告 (每 10 分鐘 Telegram 推送)
- ✅ GitHub 整合 (Issues/Projects/Discussions)
- ✅ 智能模型路由 (qwen3.5-plus / qwen3-max)

---

## 🤖 Agent 團隊

| Agent | 專長 | 性格 | 狀態 |
|-------|------|------|------|
| **JARVIS** | 決策協調 | 專業冷靜 | 🟢 Active |
| **ATHENA** | 研究分析 | 嚴謹學術 | 🟢 Active |
| **BLAZE** | 創意開發 | 熱情創意 | 🟢 Active |
| **SENTINEL** | 安全審計 | 謹慎警惕 | 🟢 Active |
| **NEXUS** | 系統整合 | 務實結構 | 🟢 Active |
| **ECHO** | 用戶溝通 | 溫和同理 | 🟢 Active |
| **GEOPOLITICS** | 地緣政治 | 警覺全局 | 🟢 Active |

---

## 📁 倉庫結構

```
Jarvis_Group/
├── README.md                 # 本檔案
├── agents/                   # Agent 設定
│   ├── ATHENA.md
│   ├── BLAZE.md
│   ├── SENTINEL.md
│   ├── NEXUS.md
│   ├── ECHO.md
│   └── GEOPOLITICS.md
├── projects/                 # 專案目錄
│   ├── 006208_accumulation/  # 建倉計劃
│   ├── geopolitical_risk/    # 地緣政治監控
│   └── portfolio/            # 投資組合管理
├── scripts/                  # 自動化腳本
│   ├── auto-telegram-report.sh
│   ├── reply-to-discussion.sh
│   └── ...
├── meetings/                 # 會議紀錄
├── logs/                     # 執行日誌
└── docs/                     # 文檔 (已整理)
```

---

## 🔗 重要連結

| 項目 | 連結 |
|------|------|
| **Issues** | https://github.com/jo0909jj/Jarvis_Group/issues |
| **Projects** | https://github.com/users/jo0909jj/projects/2/views/1 |
| **Discussions** | https://github.com/jo0909jj/Jarvis_Group/discussions |
| **文檔** | https://github.com/jo0909jj/Jarvis_Group/tree/main/docs |

---

## 📊 系統狀態

| 系統 | 頻率 | 狀態 |
|------|------|------|
| **投資組合監控** | 每 10 分鐘 | ✅ |
| **能源價格監控** | 每 10 分鐘 | ✅ |
| **Telegram 推送** | 每 10 分鐘 | ✅ |
| **Git 自動推送** | 每 10 分鐘 | ✅ |
| **Agent Discussions** | 每 10 分鐘 | ✅ |

---

## 🚀 快速開始

### 安裝

```bash
# 克隆倉庫
git clone https://github.com/jo0909jj/Jarvis_Group.git
cd Jarvis_Group

# 安裝依賴
npm install

# 設定環境變數
export GITHUB_TOKEN="ghp_您的 token"

# 設定 Cron
crontab -e
# 添加：*/10 9-13 * * 1-5 ./scripts/auto-telegram-report.sh
```

### 使用

```bash
# 手動執行報告
./scripts/auto-telegram-report.sh

# 查看日誌
tail -f logs/telegram-cron.log
```

---

## 📖 文檔

詳細文檔已整理到 `docs/` 目錄：

- [自動 Git 更新](docs/AUTO_GIT_UPDATE.md)
- [自動監控設定](docs/AUTO_MONITOR_SETUP.md)
- [決策流程](docs/DECISION_FLOW.md)
- [Discussions 設定](docs/DISCUSSIONS_SETUP.md)
- [GitHub 設定](docs/GITHUB_SETUP.md)
- [遷移指南](docs/MIGRATION_GUIDE.md)
- [離線模式](docs/OFFLINE_MODE.md)
- [智能模型路由](docs/SMART_MODEL_ROUTING.md)

---

*"Sometimes you gotta run before you can walk."*
