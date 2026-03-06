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

LOG_FILE="$LOG_DIR/monitor-$DATE.log"

echo "[$TIMESTAMP] 🚀 Starting auto monitor..."

{
    echo "=========================================="
    echo "[$TIMESTAMP] Auto Monitor Run"
    echo "=========================================="
    echo ""
    
    # 查詢投資組合價格
    echo "📊 Portfolio:"
    cd "$PROJECT_DIR/projects/portfolio"
    if node fetch_all.js 2>/dev/null; then
        echo ""
    else
        echo "  (查詢失敗)"
        echo ""
    fi
    
    # 查詢能源價格
    echo "⛽ Energy:"
    cd "$PROJECT_DIR/projects/geopolitical_risk"
    if node monitor_energy.js 2>/dev/null; then
        echo ""
    else
        echo "  (查詢失敗)"
        echo ""
    fi
    
    # 查詢 006208 價格
    echo "💰 006208:"
    cd "$PROJECT_DIR/projects/006208_accumulation"
    if node fetch_price.js 2>/dev/null; then
        echo ""
    else
        echo "  (查詢失敗)"
        echo ""
    fi
    
} >> "$LOG_FILE"

echo "[$TIMESTAMP] ✅ Auto monitor completed."
echo ""
