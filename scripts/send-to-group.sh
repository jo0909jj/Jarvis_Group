#!/bin/bash
# Send to Group - 發送訊息到 Telegram 群組

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 載入環境變數
if [ -f "$PROJECT_DIR/.env" ]; then
    source "$PROJECT_DIR/.env"
fi

# 參數檢查
if [ -z "$1" ]; then
    echo "用法：$0 <MESSAGE>"
    echo "範例：$0 \"Hello Group\""
    exit 1
fi

MESSAGE="$1"

# 檢查群組 ID
if [ -z "$TELEGRAM_GROUP_ID" ]; then
    echo "❌ TELEGRAM_GROUP_ID 未設定"
    echo ""
    echo "請先獲取群組 ID："
    echo "bash $SCRIPT_DIR/get-group-id.sh --fetch"
    exit 1
fi

# 使用 JARVIS Bot 發送
TOKEN="$TELEGRAM_JARVIS_TOKEN"

if [ -z "$TOKEN" ]; then
    echo "❌ TELEGRAM_JARVIS_TOKEN 未設定"
    exit 1
fi

echo "📤 發送訊息到群組 $TELEGRAM_GROUP_ID..."

RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_GROUP_ID}" \
    -d text="${MESSAGE}" \
    -d parse_mode="Markdown")

if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "✅ 發送成功！"
else
    echo "❌ 發送失敗"
    echo "回應：$RESPONSE"
    exit 1
fi
