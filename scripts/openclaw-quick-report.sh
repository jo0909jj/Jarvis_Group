#!/bin/bash
# OpenClaw Quick Report - OpenClaw 專用快速報告
# 每 10 分鐘執行，傳送快速結論到 Telegram

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
WORKSPACE_DIR="/home/user/.openclaw/workspace"

echo "[$TIMESTAMP] 🚀 Generating OpenClaw quick report..."

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

# 建立快速結論報告
REPORT="📊 **Jarvis Group 快速報告** [$TIMESTAMP]

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

# 輸出報告 (供 OpenClaw 使用)
echo "$REPORT"

# 記錄到日誌
LOG_FILE="$PROJECT_DIR/logs/quick-report-$(date +%Y-%m-%d).log"
echo "$REPORT" >> "$LOG_FILE"

echo ""
echo "[$TIMESTAMP] ✅ Report saved to: $LOG_FILE"
