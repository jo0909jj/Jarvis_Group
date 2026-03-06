#!/bin/bash
# Setup Cron Job for Auto Monitor
# 每 10 分鐘執行一次監控腳本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
MONITOR_SCRIPT="$PROJECT_DIR/scripts/auto-monitor.sh"

echo "🔧 Setting up cron job for auto monitor..."

# 檢查 crontab 是否已存在
EXISTING_CRON=$(crontab -l 2>/dev/null | grep "auto-monitor.sh" || true)

if [ -n "$EXISTING_CRON" ]; then
    echo "⚠️  Cron job already exists:"
    echo "$EXISTING_CRON"
    echo ""
    echo "To remove existing cron job, run:"
    echo "  crontab -e  # 然後刪除相關行"
    exit 0
fi

# 建立新的 cron job
# 每 10 分鐘執行一次：*/10 * * * *
CRON_JOB="*/10 9-13 * * 1-5 $MONITOR_SCRIPT >> $PROJECT_DIR/logs/cron.log 2>&1"

echo "📝 Adding cron job:"
echo "  $CRON_JOB"
echo ""

# 備份現有 crontab
(crontab -l 2>/dev/null || echo "") | grep -v "auto-monitor.sh" > /tmp/cron_backup.tmp

# 添加新的 cron job
echo "$CRON_JOB" >> /tmp/cron_backup.tmp

# 安裝新的 crontab
crontab /tmp/cron_backup.tmp

# 清理
rm -f /tmp/cron_backup.tmp

echo "✅ Cron job installed successfully!"
echo ""
echo "📋 Current crontab:"
crontab -l
echo ""
echo "📝 Log file: $PROJECT_DIR/logs/cron.log"
echo ""
echo "⏰ Schedule: Every 10 minutes, Mon-Fri, 09:00-13:30 (Taiwan market hours)"
echo ""
echo "To view logs: tail -f $PROJECT_DIR/logs/cron.log"
echo "To edit cron: crontab -e"
echo "To remove cron: crontab -r"
