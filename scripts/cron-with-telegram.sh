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
# 注意：這需要在 OpenClaw 環境中執行
if command -v openclaw &> /dev/null; then
    echo "[$TIMESTAMP] 📤 Sending to Telegram..."
    openclaw message send \
        --target "telegram:$TELEGRAM_CHAT_ID" \
        --message "$REPORT" \
        2>> "$LOG_DIR/telegram-error.log" || echo "Failed to send Telegram message"
else
    echo "[$TIMESTAMP] ⚠️  OpenClaw command not found, logging only"
fi

echo "[$TIMESTAMP] ✅ Cron completed"
