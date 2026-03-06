# GitHub Issues Batch - 批量建立 Issues

**執行指令：**
```bash
cd /home/user/.openclaw/workspace/Jarvis_Group

# Issue 1: 006208 建倉計劃
gh issue create \
  --title "[FEATURE] 006208 富邦台 50 建倉計劃 - 400 萬資金分批進場" \
  --body-file .github/issues/issue-001-006208-accumulation.md \
  --label "enhancement,006208,investment" \
  --assignee jo0909jj

# Issue 2: 地緣政治風險監控
gh issue create \
  --title "[FEATURE] 地緣政治風險監控系統 - GEOPOLITICS Agent" \
  --body-file .github/issues/issue-002-geopolitics-monitor.md \
  --label "enhancement,geopolitics,risk-monitoring" \
  --assignee jo0909jj

# Issue 3: 投資組合整合
gh issue create \
  --title "[FEATURE] 投資組合整合 - 006208/MSFT/GOOGL 統一監控" \
  --body-file .github/issues/issue-003-portfolio-integration.md \
  --label "enhancement,portfolio,tracking" \
  --assignee jo0909jj

# Issue 4: 會議紀錄系統
gh issue create \
  --title "[FEATURE] 會議紀錄系統 - 完整保存 Agent 討論與決策" \
  --body-file .github/issues/issue-004-meeting-records.md \
  --label "enhancement,documentation,meeting-records" \
  --assignee jo0909jj

# Issue 5: 自動化監控
gh issue create \
  --title "[FEATURE] 自動化監控系統 - 股價/能源價格定時查詢" \
  --body-file .github/issues/issue-005-automation-monitoring.md \
  --label "enhancement,automation,monitoring" \
  --assignee jo0909jj
```

---

## 📊 Issues 清單

| 編號 | 標題 | 標籤 | 優先級 |
|------|------|------|--------|
| #1 | 006208 建倉計劃 | enhancement, 006208 | High |
| #2 | 地緣政治風險監控 | enhancement, risk | High |
| #3 | 投資組合整合 | enhancement, portfolio | Medium |
| #4 | 會議紀錄系統 | documentation | Medium |
| #5 | 自動化監控 | automation | Medium |

---

*建立日期：2026-03-06*
