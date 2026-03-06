#!/bin/bash
# Update Cron for Telegram Reports - 更新 Cron 設定

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TELEGRAM_SCRIPT="$PROJECT_DIR/scripts/auto-telegram-report.sh"

echo "🔧 Updating cron job for Telegram reports..."

# 移除舊的 cron job
(crontab -l 2>/dev/null || echo "") | grep -v "auto-monitor.sh" | grep -v "auto-telegram" > /tmp/cron_backup.tmp

# 添加新的 cron job - 每 10 分鐘執行
CRON_JOB="*/10 9-13 * * 1-5 $TELEGRAM_SCRIPT >> $PROJECT_DIR/logs/telegram-cron.log 2>&1"

echo "📝 Adding cron job:"
echo "  $CRON_JOB"
echo ""

# 添加新的 cron job
echo "$CRON_JOB" >> /tmp/cron_backup.tmp

# 安裝新的 crontab
crontab /tmp/cron_backup.tmp

# 清理
rm -f /tmp/cron_backup.tmp

echo "✅ Cron job updated successfully!"
echo ""
echo "📋 Current crontab:"
crontab -l
echo ""
echo "⏰ Schedule: Every 10 minutes, Mon-Fri, 09:00-13:30 (Taiwan market hours)"
echo "📝 Log file: $PROJECT_DIR/logs/telegram-cron.log"
