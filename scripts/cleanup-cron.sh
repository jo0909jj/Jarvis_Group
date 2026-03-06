#!/bin/bash
# Cleanup Cron - 清理重複的 Cron 設定

echo "🧹 清理 Cron 設定..."

# 移除所有 Jarvis cron
(crontab -l 2>/dev/null | grep -v "auto-telegram-report.sh" | grep -v "Jarvis Group") > /tmp/cron_clean.txt

# 添加單一乾淨的設定
echo "# Jarvis Group - 每天監控（每 10 分鐘）" >> /tmp/cron_clean.txt
echo "*/10 * * * * /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-telegram-report.sh >> /home/user/.openclaw/workspace/Jarvis_Group/logs/telegram-cron.log 2>&1" >> /tmp/cron_clean.txt

# 安裝
crontab /tmp/cron_clean.txt
rm /tmp/cron_clean.txt

echo "✅ Cron 已清理！"
crontab -l
