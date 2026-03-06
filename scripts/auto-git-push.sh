#!/bin/bash
# Auto Git Push - 自動推送 GitHub
# 每 10 分鐘檢查並推送變更到 GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
LOG_DIR="$PROJECT_DIR/logs"

mkdir -p "$LOG_DIR"

echo "[$TIMESTAMP] 🔄 Checking for Git changes..."

cd "$PROJECT_DIR"

# 檢查是否有變更
if git status --porcelain | grep -q '.'; then
    echo "[$TIMESTAMP] 📝 Changes detected, committing and pushing..."
    
    # 添加所有變更
    git add -A
    
    # 提交變更
    git commit -m "auto: Scheduled update at $TIMESTAMP" || echo "No changes to commit"
    
    # 推送到 GitHub
    git push origin main 2>&1 | tee -a "$LOG_DIR/git-push.log"
    
    echo "[$TIMESTAMP] ✅ Changes pushed to GitHub"
else
    echo "[$TIMESTAMP] ✅ No changes, skip push"
fi

# 記錄到日誌
echo "[$TIMESTAMP] Git push check completed" >> "$LOG_DIR/git-push.log"
