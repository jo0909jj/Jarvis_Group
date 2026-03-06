#!/bin/bash
# 006208 股價監控腳本
# 使用方法：./monitor.sh [股價]

SYMBOL="006208"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

if [ -z "$1" ]; then
    echo "用法：./monitor.sh [股價]"
    echo "範例：./monitor.sh 95.5"
    exit 1
fi

PRICE=$1
LOG_FILE="price_log.json"
PROJECT_DIR="$(dirname "$0")"

echo "[$DATE $TIME] $SYMBOL 股價：$PRICE"

# 讀取基準價格
BASELINE=$(jq -r '.baseline_price' "$PROJECT_DIR/$LOG_FILE")

if [ "$BASELINE" == "null" ]; then
    echo "設定基準價格：$PRICE"
    jq --arg price "$PRICE" --arg date "$DATE" '.baseline_price = ($price | tonumber) | .tracking_start = $date' "$PROJECT_DIR/$LOG_FILE" > "$PROJECT_DIR/$LOG_FILE.tmp"
    mv "$PROJECT_DIR/$LOG_FILE.tmp" "$PROJECT_DIR/$LOG_FILE"
    BASELINE=$PRICE
fi

# 計算跌幅百分比
DROP_PERCENT=$(echo "scale=2; (1 - $PRICE / $BASELINE) * 100" | bc)

echo "基準價格：$BASELINE"
echo "目前跌幅：$DROP_PERCENT%"

# 檢查是否觸發買入條件
if (( $(echo "$DROP_PERCENT <= -5" | bc -l) )); then
    echo "⚠️ 觸發第2批買入條件 (跌幅 >= 5%)"
fi

if (( $(echo "$DROP_PERCENT <= -10" | bc -l) )); then
    echo "⚠️ 觸發第3批買入條件 (跌幅 >= 10%)"
fi

if (( $(echo "$DROP_PERCENT <= -15" | bc -l) )); then
    echo "⚠️ 觸發第4批買入條件 (跌幅 >= 15%)"
fi

if (( $(echo "$DROP_PERCENT <= -20" | bc -l) )); then
    echo "⚠️ 觸發第5批買入條件 (跌幅 >= 20%)"
fi

# 記錄價格
jq --arg price "$PRICE" --arg date "$DATE" --arg time "$TIME" --arg drop "$DROP_PERCENT" \
   '.price_history += [{"date": $date, "time": $time, "price": ($price | tonumber), "drop_percent": ($drop | tonumber)}]' \
   "$PROJECT_DIR/$LOG_FILE" > "$PROJECT_DIR/$LOG_FILE.tmp"
mv "$PROJECT_DIR/$LOG_FILE.tmp" "$PROJECT_DIR/$LOG_FILE"

echo "價格已記錄"
