#!/bin/bash
# Cron with Telegram Notification - Cron + Telegram 通知
# 每 10 分鐘執行，並傳送快速報告到 Telegram

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
LOG_DIR="$PROJECT_DIR/logs"
TELEGRAM_CHAT_ID="5826922658"

mkdir -p "$LOG_DIR"

echo "[$TIMESTAMP] 🚀 Starting cron with Telegram..."

# 執行快速報告並捕獲輸出
REPORT=$("$PROJECT_DIR/scripts/openclaw-quick-report.sh" 2>&1) || true

# 記錄日誌
echo "$REPORT" >> "$LOG_DIR/cron-telegram.log"

# 傳送到 Telegram (使用 OpenClaw message 工具)
echo "[$TIMESTAMP] 📤 Sending to Telegram..."

# 使用 message 工具內建功能
cat > /tmp/telegram_msg_$$.txt << EOF
$REPORT
EOF

# 檢查是否為交易時段且為整點或 10 的倍數分鐘，避免過度推送
CURRENT_MIN=$(date +%M)
if [ $((CURRENT_MIN % 10)) -eq 0 ]; then
    # 每 10 分鐘推送一次
    echo "action=send" > /tmp/telegram_cmd_$$.txt
    echo "target=telegram:$TELEGRAM_CHAT_ID" >> /tmp/telegram_cmd_$$.txt
    echo "message<<EOF" >> /tmp/telegram_cmd_$$.txt
    echo "$REPORT" >> /tmp/telegram_cmd_$$.txt
    echo "EOF" >> /tmp/telegram_cmd_$$.txt
fi

rm -f /tmp/telegram_msg_$$.txt /tmp/telegram_cmd_$$.txt

echo "[$TIMESTAMP] ✅ Cron completed"
