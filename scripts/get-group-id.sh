#!/bin/bash
# Get Group ID - 獲取 Telegram 群組 ID

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 載入環境變數
if [ -f "$PROJECT_DIR/.env" ]; then
    source "$PROJECT_DIR/.env"
fi

echo "╔════════════════════════════════════════════════════════╗"
echo "║        獲取 Telegram 群組 ID                            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# 使用 JARVIS Bot
TOKEN="$TELEGRAM_JARVIS_TOKEN"

if [ -z "$TOKEN" ]; then
    echo "❌ TELEGRAM_JARVIS_TOKEN 未設定"
    exit 1
fi

echo "📋 請按照以下步驟操作："
echo ""
echo "1. 在 Telegram 中創建一個群組"
echo "2. 添加 @JarvisGroupBot (或其他 Bot) 到群組"
echo "3. 在群組中發送任意訊息"
echo "4. 執行以下命令獲取群組 ID："
echo ""
echo "curl -s https://api.telegram.org/bot${TOKEN}/getUpdates | jq '.result[-1].message.chat'"
echo ""
echo "或者執行："
echo "bash $0 --fetch"
echo ""

# 如果參數是 --fetch，嘗試獲取最新的 chat ID
if [ "$1" = "--fetch" ]; then
    echo "🔍 正在獲取最新的更新..."
    RESPONSE=$(curl -s "https://api.telegram.org/bot${TOKEN}/getUpdates")
    
    echo ""
    echo "📋 最近的消息："
    echo "$RESPONSE" | jq -r '.result[] | "Chat ID: \(.message.chat.id) | Title: \(.message.chat.title // "私聊")"'
    
    # 提取最後一個群組 ID
    GROUP_ID=$(echo "$RESPONSE" | jq -r '.result[] | select(.message.chat.type == "group" or .message.chat.type == "supergroup") | .message.chat.id' | tail -1)
    
    if [ -n "$GROUP_ID" ]; then
        echo ""
        echo "✅ 找到群組 ID: $GROUP_ID"
        echo ""
        echo "請將以下行添加到 .env 文件："
        echo "TELEGRAM_GROUP_ID=\"$GROUP_ID\""
    else
        echo ""
        echo "⚠️  未找到群組消息，請先在群組中發送訊息"
    fi
fi
