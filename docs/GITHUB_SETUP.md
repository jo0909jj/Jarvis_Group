# GitHub Setup Guide - GitHub 設定指南

**最後更新：** 2026-03-06

---

## 🎯 目標

建立完整的 GitHub 專案管理系統，包括 Issues、Projects、PRs。

---

## 📋 步驟 1: GitHub CLI 認證

```bash
# 認證 GitHub
gh auth login

# 選擇 GitHub.com
# 選擇 HTTPS
# 選擇 Login with a web browser
# 複製代碼並完成認證
```

---

## 📋 步驟 2: 建立 Issues

### 方法 A: 使用腳本 (推薦)

```bash
cd /home/user/.openclaw/workspace/Jarvis_Group
./scripts/create-issues.sh
```

### 方法 B: 手動建立

```bash
cd /home/user/.openclaw/workspace/Jarvis_Group

# Issue 1
gh issue create \
  --title "[FEATURE] 006208 富邦台 50 建倉計劃 - 400 萬資金分批進場" \
  --body-file .github/issues/issue-001-006208-accumulation.md \
  --label "enhancement,006208,investment" \
  --assignee jo0909jj

# Issue 2
gh issue create \
  --title "[FEATURE] 地緣政治風險監控系統 - GEOPOLITICS Agent" \
  --body-file .github/issues/issue-002-geopolitics-monitor.md \
  --label "enhancement,geopolitics,risk-monitoring" \
  --assignee jo0909jj

# Issue 3
gh issue create \
  --title "[FEATURE] 投資組合整合 - 006208/MSFT/GOOGL 統一監控" \
  --body-file .github/issues/issue-003-portfolio-integration.md \
  --label "enhancement,portfolio,tracking" \
  --assignee jo0909jj

# Issue 4
gh issue create \
  --title "[FEATURE] 會議紀錄系統 - 完整保存 Agent 討論與決策" \
  --body-file .github/issues/issue-004-meeting-records.md \
  --label "enhancement,documentation,meeting-records" \
  --assignee jo0909jj

# Issue 5
gh issue create \
  --title "[FEATURE] 自動化監控系統 - 股價/能源價格定時查詢" \
  --body-file .github/issues/issue-005-automation-monitoring.md \
  --label "enhancement,automation,monitoring" \
  --assignee jo0909jj
```

### 方法 C: GitHub UI

1. 前往 https://github.com/jo0909jj/Jarvis_Group/issues
2. 點擊 "New issue"
3. 選擇模板或從 `.github/issues/` 複製內容

---

## 📋 步驟 3: 建立 Projects 看板

### 使用 GitHub UI (推薦)

1. 前往 https://github.com/jo0909jj/Jarvis_Group/projects
2. 點擊 "New project"
3. 選擇 "Board" 模板
4. 命名為 "Jarvis Group Roadmap"
5. 添加欄位：Backlog, In Progress, Review, Done
6. 將 Issues 添加到看板

### 使用 gh CLI

```bash
# 建立 Project
gh project create --owner jo0909jj --title "Jarvis Group Roadmap"

# 查看 Project ID
gh project list --owner jo0909jj

# 添加 Issues 到 Project (替換 <PROJECT_ID> 和 <ISSUE_NUMBER>)
gh project item-add <PROJECT_ID> --owner jo0909jj --url https://github.com/jo0909jj/Jarvis_Group/issues/<ISSUE_NUMBER>
```

---

## 📋 步驟 4: 建立 Pull Requests

當有新的功能或修復時：

```bash
# 建立新分支
git checkout -b feature/your-feature-name

# 提交變更
git add -A
git commit -m "feat: your feature description"

# 推送分支
git push origin feature/your-feature-name

# 建立 PR
gh pr create \
  --title "feat: your feature description" \
  --body "Description of your changes" \
  --base main \
  --head feature/your-feature-name
```

---

## 📊 當前 Issues 清單

| 編號 | 標題 | 標籤 | 優先級 | 狀態 |
|------|------|------|--------|------|
| #1 | 006208 建倉計劃 | enhancement, 006208 | High | 🟡 |
| #2 | 地緣政治風險監控 | enhancement, risk | High | 🟢 |
| #3 | 投資組合整合 | enhancement, portfolio | Medium | 🟡 |
| #4 | 會議紀錄系統 | documentation | Medium | 🟢 |
| #5 | 自動化監控 | automation | Medium | 🟡 |

---

## 🔗 重要連結

- **Issues:** https://github.com/jo0909jj/Jarvis_Group/issues
- **Pull Requests:** https://github.com/jo0909jj/Jarvis_Group/pulls
- **Projects:** https://github.com/jo0909jj/Jarvis_Group/projects
- **Actions:** https://github.com/jo0909jj/Jarvis_Group/actions

---

## 📝 Issue 模板位置

- 功能需求：`.github/ISSUE_TEMPLATE/feature-request.md`
- 問題回報：`.github/ISSUE_TEMPLATE/bug-report.md`
- 預建 Issues: `.github/issues/`

---

*維護者：JARVIS | 下次更新：視需要*
