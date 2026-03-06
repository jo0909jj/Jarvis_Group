#!/bin/bash
# Create GitHub Issues for Jarvis Group
# Usage: ./scripts/create-issues.sh

set -e

REPO="jo0909jj/Jarvis_Group"
ISSUES_DIR=".github/issues"

echo "🚀 Creating GitHub Issues for $REPO..."

# Issue 1: 006208 Accumulation
echo "📝 Creating Issue #1: 006208 Accumulation Plan..."
gh issue create \
  --title "[FEATURE] 006208 富邦台 50 建倉計劃 - 400 萬資金分批進場" \
  --body-file "$ISSUES_DIR/issue-001-006208-accumulation.md" \
  --label "enhancement,006208,investment" \
  --assignee jo0909jj \
  --repo $REPO

# Issue 2: Geopolitics Monitor
echo "📝 Creating Issue #2: Geopolitics Risk Monitor..."
gh issue create \
  --title "[FEATURE] 地緣政治風險監控系統 - GEOPOLITICS Agent" \
  --body-file "$ISSUES_DIR/issue-002-geopolitics-monitor.md" \
  --label "enhancement,geopolitics,risk-monitoring" \
  --assignee jo0909jj \
  --repo $REPO

# Issue 3: Portfolio Integration
echo "📝 Creating Issue #3: Portfolio Integration..."
gh issue create \
  --title "[FEATURE] 投資組合整合 - 006208/MSFT/GOOGL 統一監控" \
  --body-file "$ISSUES_DIR/issue-003-portfolio-integration.md" \
  --label "enhancement,portfolio,tracking" \
  --assignee jo0909jj \
  --repo $REPO

# Issue 4: Meeting Records
echo "📝 Creating Issue #4: Meeting Records System..."
gh issue create \
  --title "[FEATURE] 會議紀錄系統 - 完整保存 Agent 討論與決策" \
  --body-file "$ISSUES_DIR/issue-004-meeting-records.md" \
  --label "enhancement,documentation,meeting-records" \
  --assignee jo0909jj \
  --repo $REPO

# Issue 5: Automation Monitoring
echo "📝 Creating Issue #5: Automation Monitoring..."
gh issue create \
  --title "[FEATURE] 自動化監控系統 - 股價/能源價格定時查詢" \
  --body-file "$ISSUES_DIR/issue-005-automation-monitoring.md" \
  --label "enhancement,automation,monitoring" \
  --assignee jo0909jj \
  --repo $REPO

echo "✅ All issues created successfully!"
echo ""
echo "📊 View issues at: https://github.com/$REPO/issues"
