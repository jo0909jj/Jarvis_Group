#!/bin/bash
# Setup Cron Schedule - 設定分時 Cron 任務

set -e

echo "📅 設定 Jarvis Group Cron 任務..."
echo ""

# 清除舊的 Jarvis cron
(crontab -l 2>/dev/null | grep -v "auto-telegram-report.sh" | grep -v "reply-to-discussion.sh" | grep -v "Jarvis Group") > /tmp/cron_new.txt || true

# 添加新的 Cron 設定
cat >> /tmp/cron_new.txt << 'EOF'

# ===========================================
# Jarvis Group - 分時任務設定
# ===========================================

# Discussion 回覆 - 每天 24 小時，每週 7 天（每 10 分鐘）
*/10 * * * * /home/user/.openclaw/workspace/Jarvis_Group/scripts/reply-to-discussion.sh 6 >> /home/user/.openclaw/workspace/Jarvis_Group/logs/discussion-cron.log 2>&1

# 台股監控 - 週一至週五 09:00-13:30（每 10 分鐘）
*/10 9-13 * * 1-5 /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-telegram-report.sh >> /home/user/.openclaw/workspace/Jarvis_Group/logs/telegram-cron.log 2>&1

# 美股監控 - 週一至週五 22:30-05:00（台灣時間）
*/10 22-23,0-5 * * 1-5 /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-telegram-report.sh >> /home/user/.openclaw/workspace/Jarvis_Group/logs/telegram-cron.log 2>&1

EOF

# 安裝新的 crontab
crontab /tmp/cron_new.txt

# 清理
rm -f /tmp/cron_new.txt

echo "✅ Cron 設定已完成！"
echo ""
echo "=========================================="
echo "📊 當前 Cron 設定："
echo "=========================================="
crontab -l
echo ""
echo "=========================================="
echo "📋 任務說明："
echo "=========================================="
echo ""
echo "1️⃣  Discussion 回覆"
echo "   ⏰ 每天 24 小時，每週 7 天"
echo "   📝 每 10 分鐘自動在 Discussion #6 回覆"
echo ""
echo "2️⃣  台股監控"
echo "   ⏰ 週一至週五 09:00-13:30"
echo "   📝 每 10 分鐘推送台股報告"
echo ""
echo "3️⃣  美股監控"
echo "   ⏰ 週一至週五 22:30-05:00（台灣時間）"
echo "   📝 每 10 分鐘推送美股報告"
echo ""
echo "=========================================="
echo ""
