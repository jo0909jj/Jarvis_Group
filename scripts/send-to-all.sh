#!/bin/bash
# Send to All - 發送訊息到所有 Telegram 目的地（私聊 + 群組）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 載入環境變數
if [ -f "$PROJECT_DIR/.env" ]; then
    source "$PROJECT_DIR/.env"
fi

# 參數檢查
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "用法：$0 <BOT_NAME> <MESSAGE>"
    echo "範例：$0 JARVIS \"Hello\""
    exit 1
fi

BOT_NAME="$1"
MESSAGE="$2"

# 根據 Bot 名稱選擇 Token
case "$BOT_NAME" in
    JARVIS) TOKEN="$TELEGRAM_JARVIS_TOKEN" ;;
    ATHENA) TOKEN="$TELEGRAM_ATHENA_TOKEN" ;;
    BLAZE) TOKEN="$TELEGRAM_BLAZE_TOKEN" ;;
    SENTINEL) TOKEN="$TELEGRAM_SENTINEL_TOKEN" ;;
    NEXUS) TOKEN="$TELEGRAM_NEXUS_TOKEN" ;;
    *) echo "❌ 未知 Bot: $BOT_NAME"; exit 1 ;;
esac

if [ -z "$TOKEN" ]; then
    echo "❌ Token 未設定：$BOT_NAME"
    exit 1
fi

# 發送到私聊
send_to_user() {
    curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_USER_ID}" \
        -d text="${MESSAGE}" \
        -d parse_mode="Markdown" > /dev/null
    echo "✅ 發送至 私聊"
}

# 發送到群組
send_to_group() {
    if [ -n "$TELEGRAM_GROUP_ID" ]; then
        curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
            -d chat_id="${TELEGRAM_GROUP_ID}" \
            -d text="${MESSAGE}" \
            -d parse_mode="Markdown" > /dev/null
        echo "✅ 發送至 群組 ($TELEGRAM_GROUP_ID)"
    fi
}

# 同時發送到私聊和群組
send_to_user
send_to_group
