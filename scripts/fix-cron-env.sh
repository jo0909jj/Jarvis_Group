#!/bin/bash
# Fix Cron Environment - 修復 Cron 環境變數

echo "🔧 修復 Cron 環境變數..."

# 清除舊的 Jarvis cron
(crontab -l 2>/dev/null | grep -v "reply-to-discussion.sh" | grep -v "auto-telegram-report.sh" | grep -v "Jarvis Group") > /tmp/cron_fix.txt || true

# 添加新的 Cron 設定（包含環境變數）
cat >> /tmp/cron_fix.txt << 'EOF'

# ===========================================
# Jarvis Group - 分時任務設定
# ===========================================

# Discussion 回覆 - 每天 24 小時，每週 7 天（每 10 分鐘）
*/10 * * * * bash -c 'source ~/.bashrc && /home/user/.openclaw/workspace/Jarvis_Group/scripts/reply-to-discussion.sh 6' >> /home/user/.openclaw/workspace/Jarvis_Group/logs/discussion-cron.log 2>&1

# 台股監控 - 週一至週五 09:00-13:30（每 10 分鐘）
*/10 9-13 * * 1-5 bash -c 'source ~/.bashrc && /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-telegram-report.sh' >> /home/user/.openclaw/workspace/Jarvis_Group/logs/telegram-cron.log 2>&1

# 美股監控 - 週一至週五 22:30-05:00（台灣時間）
*/10 22-23,0-5 * * 1-5 bash -c 'source ~/.bashrc && /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-telegram-report.sh' >> /home/user/.openclaw/workspace/Jarvis_Group/logs/telegram-cron.log 2>&1

EOF

# 安裝新的 crontab
crontab /tmp/cron_fix.txt
rm /tmp/cron_fix.txt

echo "✅ Cron 環境變數已修復！"
echo ""
crontab -l
