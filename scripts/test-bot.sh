#!/bin/bash
# Test Bot - 測試 Telegram Bot 連接

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 載入環境變數
if [ -f "$PROJECT_DIR/.env" ]; then
    source "$PROJECT_DIR/.env"
fi

# 參數檢查
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "用法：$0 <AGENT_NAME> <MESSAGE>"
    echo "範例：$0 JARVIS \"Hello World\""
    echo ""
    echo "可用的 AGENT_NAME:"
    echo "  JARVIS, ATHENA, BLAZE, SENTINEL, NEXUS, ECHO, GEOPOLITICS"
    exit 1
fi

AGENT_NAME="$1"
MESSAGE="$2"

# 根據 Agent 名稱選擇 Token
case "$AGENT_NAME" in
    JARVIS)
        TOKEN="$TELEGRAM_JARVIS_TOKEN"
        ;;
    ATHENA)
        TOKEN="$TELEGRAM_ATHENA_TOKEN"
        ;;
    BLAZE)
        TOKEN="$TELEGRAM_BLAZE_TOKEN"
        ;;
    SENTINEL)
        TOKEN="$TELEGRAM_SENTINEL_TOKEN"
        ;;
    NEXUS)
        TOKEN="$TELEGRAM_NEXUS_TOKEN"
        ;;
    ECHO)
        TOKEN="$TELEGRAM_ECHO_TOKEN"
        ;;
    GEOPOLITICS)
        TOKEN="$TELEGRAM_GEOPOLITICS_TOKEN"
        ;;
    *)
        echo "❌ 未知的 Agent: $AGENT_NAME"
        exit 1
        ;;
esac

# 檢查 Token
if [ -z "$TOKEN" ]; then
    echo "❌ Token 未設定：TELEGRAM_${AGENT_NAME}_TOKEN"
    echo "請編輯 .env 文件並填入對應的 Bot Token"
    exit 1
fi

# 檢查 User ID
if [ -z "$TELEGRAM_USER_ID" ]; then
    echo "❌ TELEGRAM_USER_ID 未設定"
    exit 1
fi

echo "📤 發送測試訊息到 @${AGENT_NAME} Bot..."
echo "訊息：$MESSAGE"

# 發送訊息
RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_USER_ID}" \
    -d text="${MESSAGE}" \
    -d parse_mode="Markdown")

# 檢查回應
if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "✅ 發送成功！"
else
    echo "❌ 發送失敗"
    echo "回應：$RESPONSE"
    exit 1
fi
