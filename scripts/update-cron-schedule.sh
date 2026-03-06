#!/bin/bash
# Update Cron Schedule - 更新 Cron 時間設定

echo "🔄 更新 Cron 設定..."
echo ""

# 備份當前設定
crontab -l > /tmp/cron_backup_$$.txt 2>/dev/null || true

# 移除舊的 Jarvis cron
(crontab -l 2>/dev/null | grep -v "auto-telegram-report.sh") > /tmp/cron_new_$$.txt || true

# 添加新的 Cron 設定（全天運行，每 10 分鐘）
echo "# Jarvis Group - 全天監控（每 10 分鐘）" >> /tmp/cron_new_$$.txt
echo "*/10 * * * 1-5 /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-telegram-report.sh >> /home/user/.openclaw/workspace/Jarvis_Group/logs/telegram-cron.log 2>&1" >> /tmp/cron_new_$$.txt

# 安裝新的 crontab
crontab /tmp/cron_new_$$.txt

# 清理
rm -f /tmp/cron_new_$$.txt /tmp/cron_backup_$$.txt

echo "✅ Cron 設定已更新！"
echo ""
echo "新設定："
crontab -l
echo ""
echo "📊 運行時間：週一至週五 全天（每 10 分鐘）"
echo "📝 日誌位置：~/openclaw/workspace/Jarvis_Group/logs/telegram-cron.log"
