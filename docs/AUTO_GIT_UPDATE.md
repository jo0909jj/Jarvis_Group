# Auto Git Update - 自動 Git 更新機制

**最後更新：** 2026-03-06 12:58

---

## 🎯 目標

每 10 分鐘自動檢查並推送本地變更到 GitHub，確保：
- 日誌文件同步
- 會議紀錄同步
- 狀態文件同步
- GitHub 保持最新

---

## 🔧 實作方式

### 腳本：`scripts/auto-git-push.sh`

```bash
#!/bin/bash
# 每 10 分鐘執行
# 1. 檢查是否有變更
# 2. 如果有變更，自動 commit 並 push
# 3. 如果無變更，跳過
```

### 整合點

已整合到 `auto-telegram-report.sh`：
- 每次生成 Telegram 報告後
- 自動檢查並推送 Git 變更
- 確保 GitHub 保持最新

---

## 📊 執行流程

```
每 10 分鐘
  ↓
查詢股價和能源價格
  ↓
生成快速報告
  ↓
傳送到 Telegram
  ↓
檢查 Git 變更 ← 新增！
  ↓
推送至 GitHub
  ↓
完成
```

---

## 📝 Git 提交記錄

### 自動提交格式

```
auto: Scheduled update at YYYY-MM-DD HH:MM:SS
```

### 包含內容

- 日誌文件 (`logs/*.log`)
- 狀態文件 (`logs/.offline_state.json`)
- 會議紀錄 (`meetings/2026/*.md`)
- 其他本地變更

---

## 🔍 查看日誌

```bash
# 查看 Git 推送日誌
tail -f /home/user/.openclaw/workspace/Jarvis_Group/logs/git-push.log

# 查看最近提交
cd /home/user/.openclaw/workspace/Jarvis_Group
git log --oneline -10
```

---

## 🛡️ 錯誤處理

### 無變更時

```
✅ No changes, skip push
```

### 推送失敗時

```
⚠️ Push failed, will retry next cycle
```

### 網路離線時

```
⏸️ Offline mode, Git push paused
```

---

## 📋 當前設定

| 項目 | 設定 |
|------|------|
| **頻率** | 每 10 分鐘 |
| **時段** | 09:00-13:30 (台股交易時間) |
| **自動 Commit** | ✅ 啟用 |
| **自動 Push** | ✅ 啟用 |
| **離線保護** | ✅ 已整合 |

---

## 🎯 優勢

✅ **GitHub 保持最新** - 隨時查看最新狀態  
✅ **無需手動推送** - 完全自動化  
✅ **日誌同步** - 本地和 GitHub 一致  
✅ **錯誤容限** - 失敗不影響主流程  
✅ **離線保護** - 斷網時暫停推送  

---

## 📊 最近提交

```bash
# 查看最近 5 次自動提交
git log --oneline --grep="auto:" -5
```

---

*維護者：JARVIS | 系統已整合自動 Git 更新*
