#!/bin/bash
# Multi-Bot Router - 根據訊息類型路由到不同 Bot

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 載入環境變數
if [ -f "$PROJECT_DIR/.env" ]; then
    source "$PROJECT_DIR/.env"
fi

# 函數：發送訊息到指定 Bot
send_to_bot() {
    local agent="$1"
    local message="$2"
    local token
    
    case "$agent" in
        JARVIS) token="$TELEGRAM_JARVIS_TOKEN" ;;
        ATHENA) token="$TELEGRAM_ATHENA_TOKEN" ;;
        BLAZE) token="$TELEGRAM_BLAZE_TOKEN" ;;
        SENTINEL) token="$TELEGRAM_SENTINEL_TOKEN" ;;
        NEXUS) token="$TELEGRAM_NEXUS_TOKEN" ;;
        ECHO) token="$TELEGRAM_ECHO_TOKEN" ;;
        GEOPOLITICS) token="$TELEGRAM_GEOPOLITICS_TOKEN" ;;
        *) echo "❌ 未知 Agent: $agent"; return 1 ;;
    esac
    
    if [ -z "$token" ]; then
        echo "⚠️  Token 未設定：$agent，跳過發送"
        return 0
    fi
    
    curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" \
        -d chat_id="${TELEGRAM_USER_ID}" \
        -d text="${message}" \
        -d parse_mode="Markdown" > /dev/null
    
    echo "✅ 發送至 @${agent} Bot"
}

# 函數：根據內容類型路由
route_message() {
    local content_type="$1"
    local message="$2"
    
    case "$content_type" in
        "investment_report")
            # 投資報告 → JARVIS
            send_to_bot "JARVIS" "$message"
            ;;
        "analysis")
            # 研究分析 → ATHENA
            send_to_bot "ATHENA" "$message"
            ;;
        "creative")
            # 創意內容 → BLAZE
            send_to_bot "BLAZE" "$message"
            ;;
        "security")
            # 安全警告 → SENTINEL
            send_to_bot "SENTINEL" "$message"
            ;;
        "system")
            # 系統通知 → NEXUS
            send_to_bot "NEXUS" "$message"
            ;;
        "user_comms")
            # 用戶溝通 → ECHO
            send_to_bot "ECHO" "$message"
            ;;
        "geopolitics")
            # 地緣政治 → GEOPOLITICS
            send_to_bot "GEOPOLITICS" "$message"
            ;;
        "broadcast")
            # 廣播到所有 Bot
            for agent in JARVIS ATHENA BLAZE SENTINEL NEXUS ECHO GEOPOLITICS; do
                send_to_bot "$agent" "$message"
            done
            ;;
        *)
            # 預設 → JARVIS
            send_to_bot "JARVIS" "$message"
            ;;
    esac
}

# 如果直接執行腳本（測試用）
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "用法：$0 <CONTENT_TYPE> <MESSAGE>"
        echo ""
        echo "可用的 CONTENT_TYPE:"
        echo "  investment_report - 投資報告"
        echo "  analysis          - 研究分析"
        echo "  creative          - 創意內容"
        echo "  security          - 安全警告"
        echo "  system            - 系統通知"
        echo "  user_comms        - 用戶溝通"
        echo "  geopolitics       - 地緣政治"
        echo "  broadcast         - 廣播到所有 Bot"
        exit 1
    fi
    
    route_message "$1" "$2"
fi
