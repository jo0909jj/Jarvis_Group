# GitHub Projects Setup - 專案看板設定

---

## 📋 建立 Projects 看板

### Project 1: Jarvis Group Roadmap

**看板連結：** https://github.com/jo0909jj/Jarvis_Group/projects/1

**欄位設定：**
| Backlog | In Progress | Review | Done |
|---------|-------------|--------|------|

**卡片：**
- [ ] #1 006208 建倉計劃 → In Progress
- [ ] #2 地緣政治風險監控 → Done
- [ ] #3 投資組合整合 → In Progress
- [ ] #4 會議紀錄系統 → Done
- [ ] #5 自動化監控 → In Progress

---

## 🔧 建立指令

```bash
# 需要使用 GitHub UI 或 gh CLI
# gh project create --owner jo0909jj --title "Jarvis Group Roadmap"

# 添加卡片到看板
# gh project item-add <PROJECT_ID> --url <ISSUE_URL>
```

---

## 📊 看板視圖

### 待辦事項 (Backlog)
- 自動化監控系統 (#5)
- 新聞 API 整合 (待建立)

### 進行中 (In Progress)
- 006208 建倉計劃 (#1) - 等待用戶確認第 1 批買入
- 投資組合整合 (#3) - 等待用戶提供持倉細節

### 審查中 (Review)
- (無)

### 已完成 (Done)
- 地緣政治風險監控 (#2)
- 會議紀錄系統 (#4)

---

*建立日期：2026-03-06*
