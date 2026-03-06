#!/bin/bash
# Jarvis Group Auto Monitor - 自動監控腳本
# 每 10 分鐘執行一次，查詢股價、能源價格並記錄

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE=$(date +"%Y-%m-%d")

# 建立日誌目錄
mkdir -p "$LOG_DIR"

echo "[$TIMESTAMP] 🚀 Starting auto monitor..."

# 查詢投資組合價格
echo "[$TIMESTAMP] 📊 Fetching portfolio prices..."
cd "$PROJECT_DIR/projects/portfolio"
PORTFOLIO_DATA=$(node fetch_all.js 2>/dev/null) || echo "Error fetching portfolio"

# 查詢能源價格
echo "[$TIMESTAMP] ⛽ Fetching energy prices..."
cd "$PROJECT_DIR/projects/geopolitical_risk"
ENERGY_DATA=$(node monitor_energy.js 2>/dev/null) || echo "Error fetching energy"

# 查詢 006208 價格
echo "[$TIMESTAMP] 💰 Fetching 006208 price..."
cd "$PROJECT_DIR/projects/006208_accumulation"
TW_DATA=$(node fetch_price.js 2>/dev/null) || echo "Error fetching 006208"

# 記錄到日誌
LOG_FILE="$LOG_DIR/monitor-$DATE.log"
{
    echo "=========================================="
    echo "[$TIMESTAMP] Auto Monitor Run"
    echo "=========================================="
    echo ""
    echo "📊 Portfolio:"
    echo "$PORTFOLIO_DATA" | jq -r '.holdings | to_entries[] | "  \(.key): \(.value.price) \(.value.currency) (\(.value.changePercent | tostring)%)"' 2>/dev/null || echo "  Error parsing"
    echo ""
    echo "⛽ Energy:"
    echo "$ENERGY_DATA" | jq -r '.crude_oil.wti | "  WTI: \(.price) USD (\(.changePercent | tostring)%)"' 2>/dev/null || echo "  Error parsing"
    echo "$ENERGY_DATA" | jq -r '.natural_gas.henry_hub | "  NG: \(.price) USD (\(.changePercent | tostring)%)"' 2>/dev/null || echo "  Error parsing"
    echo "$ENERGY_DATA" | jq -r '"  Risk Level: \(.risk_level.level) (Score: \(.risk_level.score))"' 2>/dev/null || echo "  Error parsing"
    echo ""
    echo "💰 006208:"
    echo "$TW_DATA" | jq -r '"  Price: \(.price) TWD (\(.changePercent | tostring)%)"' 2>/dev/null || echo "  Error parsing"
    echo ""
} >> "$LOG_FILE"

# 檢查風險等級
RISK_LEVEL=$(echo "$ENERGY_DATA" | jq -r '.risk_level.level' 2>/dev/null || echo "UNKNOWN")

if [ "$RISK_LEVEL" = "ORANGE" ] || [ "$RISK_LEVEL" = "RED" ]; then
    echo "[$TIMESTAMP] ⚠️  WARNING: Risk level is $RISK_LEVEL!" | tee -a "$LOG_FILE"
    # 可以在這裡添加 Telegram 通知
fi

echo "[$TIMESTAMP] ✅ Auto monitor completed."
echo ""
