#!/bin/bash
# Auto Telegram Report v2 - 支持多 Bot 路由
# 根據時間自動判斷台股/美股，並路由到對應 Bot

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
HOUR=$(date +%H)
LOG_DIR="$PROJECT_DIR/logs"

# 載入環境變數
if [ -f "$PROJECT_DIR/.env" ]; then
    source "$PROJECT_DIR/.env"
fi

# 載入路由腳本
ROUTER_SCRIPT="$PROJECT_DIR/scripts/multi-bot-router.sh"
if [ ! -f "$ROUTER_SCRIPT" ]; then
    echo "❌ 路由腳本不存在：$ROUTER_SCRIPT"
    exit 1
fi
source "$ROUTER_SCRIPT"

mkdir -p "$LOG_DIR"

# 判斷是台股還是美股時段
if [ "$HOUR" -ge 9 ] && [ "$HOUR" -lt 14 ]; then
    MARKET_TYPE="台股"
    MARKET_EMOJI="🇹🇼"
elif [ "$HOUR" -ge 22 ] || [ "$HOUR" -lt 6 ]; then
    MARKET_TYPE="美股"
    MARKET_EMOJI="🇺🇸"
else
    MARKET_TYPE="混合"
    MARKET_EMOJI="🌏"
fi

echo "[$TIMESTAMP] 🚀 Generating $MARKET_TYPE report (Multi-Bot)..."

# 先檢查網路狀態
OFFLINE_HANDLER="$PROJECT_DIR/scripts/offline-handler.sh"
if [ -x "$OFFLINE_HANDLER" ]; then
    NETWORK_STATUS=$("$OFFLINE_HANDLER" 2>/dev/null | tail -1)
    echo "[$TIMESTAMP] 🌐 Network Status: $NETWORK_STATUS"
else
    NETWORK_STATUS="online"
fi

# 查詢投資組合
cd "$PROJECT_DIR/projects/portfolio"
PORTFOLIO_FILE="/tmp/portfolio_$$_.json"
node fetch_all.js 2>&1 | grep -v "survey\|bit.ly\|github.com" > "$PORTFOLIO_FILE" || echo "{}" > "$PORTFOLIO_FILE"

# 查詢能源
cd "$PROJECT_DIR/projects/geopolitical_risk"
ENERGY_FILE="/tmp/energy_$$_.json"
node monitor_energy.js 2>&1 | grep -v "survey\|bit.ly\|github.com" > "$ENERGY_FILE" || echo "{}" > "$ENERGY_FILE"

# 提取關鍵數據
TW_PRICE=$(jq -r '.holdings | .["006208.TW"] | .price' "$PORTFOLIO_FILE" 2>/dev/null || echo "N/A")
TW_CHANGE=$(jq -r '.holdings | .["006208.TW"] | .changePercent' "$PORTFOLIO_FILE" 2>/dev/null || echo "N/A")
MSFT_PRICE=$(jq -r '.holdings.MSFT.price' "$PORTFOLIO_FILE" 2>/dev/null || echo "N/A")
MSFT_CHANGE=$(jq -r '.holdings.MSFT.changePercent' "$PORTFOLIO_FILE" 2>/dev/null || echo "N/A")
GOOGL_PRICE=$(jq -r '.holdings.GOOGL.price' "$PORTFOLIO_FILE" 2>/dev/null || echo "N/A")
GOOGL_CHANGE=$(jq -r '.holdings.GOOGL.changePercent' "$PORTFOLIO_FILE" 2>/dev/null || echo "N/A")

WTI_PRICE=$(jq -r '.crude_oil.wti.price' "$ENERGY_FILE" 2>/dev/null || echo "N/A")
WTI_CHANGE=$(jq -r '.crude_oil.wti.changePercent' "$ENERGY_FILE" 2>/dev/null || echo "N/A")
RISK_LEVEL=$(jq -r '.risk_level.level' "$ENERGY_FILE" 2>/dev/null || echo "N/A")

# 清理臨時檔案
rm -f "$PORTFOLIO_FILE" "$ENERGY_FILE"

# 建立結論
if [ "$RISK_LEVEL" = "GREEN" ]; then
    CONCLUSION="✅ 市場穩定，可按計劃執行建倉"
elif [ "$RISK_LEVEL" = "YELLOW" ]; then
    CONCLUSION="⚠️ 風險升高，建議觀察"
elif [ "$RISK_LEVEL" = "ORANGE" ]; then
    CONCLUSION="🟠 風險高，暫緩建倉"
else
    CONCLUSION="🔴 風險極高，保護本金優先"
fi

# ====================
# 主報告 (JARVIS)
# ====================
MAIN_REPORT="📊 **Jarvis Group 快速報告** [$TIMESTAMP]

**持股概況:**
• 006208: $TW_PRICE TWD ($TW_CHANGE%)
• MSFT: $MSFT_PRICE USD ($MSFT_CHANGE%)
• GOOGL: $GOOGL_PRICE USD ($GOOGL_CHANGE%)

**能源價格:**
• WTI 原油：$WTI_PRICE USD ($WTI_CHANGE%)
• 風險等級：$RISK_LEVEL

**建倉狀態:**
• 006208 第 1 批：待確認 (市價 ~179 TWD)
• 第 2 批觸發價：169.01 TWD (-5%)

**結論:**
$CONCLUSION

---
*下次更新：10 分鐘後*"

# ====================
# ATHENA 分析報告
# ====================
ATHENA_REPORT="📈 **ATHENA 數據分析** [$TIMESTAMP]

**市場數據摘要:**

| 標的 | 價格 | 漲跌幅 |
|------|------|--------|
| 006208 | $TW_PRICE TWD | $TW_CHANGE% |
| MSFT | $MSFT_PRICE USD | $MSFT_CHANGE% |
| GOOGL | $GOOGL_PRICE USD | $GOOGL_CHANGE% |
| WTI | $WTI_PRICE USD | $WTI_CHANGE% |

**數據解讀:**
根據當前數據，市場波動在正常範圍內。
建議持續監控能源價格變化。

---
*數據來源：Yahoo Finance, EIA*"

# ====================
# SENTINEL 風險報告
# ====================
SENTINEL_REPORT="🛡️ **SENTINEL 風險評估** [$TIMESTAMP]

**風險等級:** $RISK_LEVEL

**監控項目:**
• 能源價格波動：$([ "$WTI_CHANGE" != "N/A" ] && echo "WTI $WTI_CHANGE%" || echo "數據缺失")
• 市場整體風險：$RISK_LEVEL

**建議措施:**
$([ "$RISK_LEVEL" = "GREEN" ] && echo "✅ 維持常規監控" || echo "⚠️ 提高警覺，縮小倉位")

---
*信任，但要驗證。*"

# 輸出報告
echo "$MAIN_REPORT"

# 記錄到日誌
LOG_FILE="$LOG_DIR/telegram-report-$(date +%Y-%m-%d).log"
{
    echo "=========================================="
    echo "[$TIMESTAMP] Multi-Bot Report Run"
    echo "=========================================="
    echo "$MAIN_REPORT"
    echo ""
} >> "$LOG_FILE"

echo ""
echo "[$TIMESTAMP] ✅ Report saved to: $LOG_FILE"
echo "[$TIMESTAMP] 📤 Sending to Telegram Bots..."

# 發送報告到對應 Bot
route_message "investment_report" "$MAIN_REPORT"
route_message "analysis" "$ATHENA_REPORT"
route_message "security" "$SENTINEL_REPORT"

# 發送到群組（如果配置了群組 ID）
if [ -n "$TELEGRAM_GROUP_ID" ]; then
    echo "[$TIMESTAMP] 📤 Sending to Group ($TELEGRAM_GROUP_ID)..."
    bash "$SCRIPT_DIR/send-to-all.sh" JARVIS "$MAIN_REPORT" 2>/dev/null || true
fi

echo "[$TIMESTAMP] ✅ All messages sent"

# 自動推送變更到 GitHub
GIT_PUSH_SCRIPT="$PROJECT_DIR/scripts/auto-git-push.sh"
if [ -x "$GIT_PUSH_SCRIPT" ]; then
    echo "[$TIMESTAMP] 🔄 Checking for Git updates..."
    "$GIT_PUSH_SCRIPT" 2>&1 | tail -5
fi

# 在 Discussion #6 回覆 (Agent 互相討論)
DISCUSSION_REPLY_SCRIPT="$PROJECT_DIR/scripts/reply-to-discussion.sh"
if [ -x "$DISCUSSION_REPLY_SCRIPT" ]; then
    if [ -n "$GITHUB_TOKEN" ]; then
        echo "[$TIMESTAMP] 💬 Posting Agent reply to Discussion #6..."
        GITHUB_TOKEN="$GITHUB_TOKEN" "$DISCUSSION_REPLY_SCRIPT" 6 2>&1 | tail -10
    else
        echo "[$TIMESTAMP] ⚠️  GITHUB_TOKEN not set, skipping Discussion reply"
    fi
fi

echo ""
echo "[$TIMESTAMP] ✅ Multi-Bot report completed."
