#!/bin/bash
# Jarvis Group Quick Report - 快速結論報告
# 每 10 分鐘執行，傳送快速結論給用戶

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] 🚀 Generating quick report..."

# 查詢投資組合
cd "$PROJECT_DIR/projects/portfolio"
PORTFOLIO=$(node fetch_all.js 2>/dev/null)

# 查詢能源
cd "$PROJECT_DIR/projects/geopolitical_risk"
ENERGY=$(node monitor_energy.js 2>/dev/null)

# 提取關鍵數據
TW_PRICE=$(echo "$PORTFOLIO" | jq -r '.holdings["006208.TW"].price' 2>/dev/null || echo "N/A")
TW_CHANGE=$(echo "$PORTFOLIO" | jq -r '.holdings["006208.TW"].changePercent' 2>/dev/null || echo "N/A")
MSFT_PRICE=$(echo "$PORTFOLIO" | jq -r '.holdings.MSFT.price' 2>/dev/null || echo "N/A")
MSFT_CHANGE=$(echo "$PORTFOLIO" | jq -r '.holdings.MSFT.changePercent' 2>/dev/null || echo "N/A")
GOOGL_PRICE=$(echo "$PORTFOLIO" | jq -r '.holdings.GOOGL.price' 2>/dev/null || echo "N/A")
GOOGL_CHANGE=$(echo "$PORTFOLIO" | jq -r '.holdings.GOOGL.changePercent' 2>/dev/null || echo "N/A")

WTI_PRICE=$(echo "$ENERGY" | jq -r '.crude_oil.wti.price' 2>/dev/null || echo "N/A")
WTI_CHANGE=$(echo "$ENERGY" | jq -r '.crude_oil.wti.changePercent' 2>/dev/null || echo "N/A")
RISK_LEVEL=$(echo "$ENERGY" | jq -r '.risk_level.level' 2>/dev/null || echo "N/A")

# 建立快速結論
REPORT="📊 **Jarvis Group 快速報告** [$TIMESTAMP]

**持股概況:**
• 006208: $TW_PRICE TWD ($TW_CHANGE%)
• MSFT: $MSFT_PRICE USD ($MSFT_CHANGE%)
• GOOGL: $GOOGL_PRICE USD ($GOOGL_CHANGE%)

**能源價格:**
• WTI 原油: $WTI_PRICE USD ($WTI_CHANGE%)
• 風險等級: $RISK_LEVEL

**建倉狀態:**
• 006208 第 1 批：待確認 (市價 179.15 TWD)
• 第 2 批觸發價：169.01 TWD (-5%)

**結論:**
$(
if [ "$RISK_LEVEL" = "GREEN" ]; then
    echo "✅ 市場穩定，可按計劃執行建倉"
elif [ "$RISK_LEVEL" = "YELLOW" ]; then
    echo "⚠️ 風險升高，建議觀察"
elif [ "$RISK_LEVEL" = "ORANGE" ]; then
    echo "🟠 風險高，暫緩建倉"
else
    echo "🔴 風險極高，保護本金優先"
fi
)

---
*下次更新：10 分鐘後*"

# 輸出報告
echo "$REPORT"

# 如果需要傳送到 Telegram，可以使用 OpenClaw message 工具
# 這裡輸出到日誌
LOG_FILE="$PROJECT_DIR/logs/quick-report-$(date +%Y-%m-%d).log"
echo "$REPORT" >> "$LOG_FILE"

echo ""
echo "[$TIMESTAMP] ✅ Report generated: $LOG_FILE"
