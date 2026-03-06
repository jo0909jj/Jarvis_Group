#!/bin/bash
# Offline Handler - 離線處理機制
# 檢測網路狀態，優雅降級，恢復後補發

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
STATE_FILE="$LOG_DIR/.offline_state.json"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

mkdir -p "$LOG_DIR"

# 檢查網路連線
check_internet() {
    if ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
        echo "online"
    else
        echo "offline"
    fi
}

# 讀取離線狀態
read_state() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo '{"status":"online","offline_start":null,"missed_reports":0,"cached_data":[]}'
    fi
}

# 寫入離線狀態
write_state() {
    echo "$1" > "$STATE_FILE"
}

# 主邏輯
main() {
    local current_status=$(check_internet)
    local state=$(read_state)
    local prev_status=$(echo "$state" | jq -r '.status')
    
    echo "[$TIMESTAMP] 🌐 Network Status: $current_status (Previous: $prev_status)"
    
    # 狀態變更處理
    if [ "$prev_status" = "online" ] && [ "$current_status" = "offline" ]; then
        # 剛斷線
        echo "[$TIMESTAMP] ⚠️  Network disconnected! Entering offline mode..."
        
        new_state=$(echo "$state" | jq --arg ts "$TIMESTAMP" \
            '.status = "offline" | .offline_start = $ts | .missed_reports = 0')
        write_state "$new_state"
        
        log_event "OFFLINE_START" "Network disconnected at $TIMESTAMP"
        
    elif [ "$prev_status" = "offline" ] && [ "$current_status" = "online" ]; then
        # 網路恢復
        echo "[$TIMESTAMP] ✅ Network restored! Processing missed reports..."
        
        missed=$(echo "$state" | jq -r '.missed_reports')
        offline_start=$(echo "$state" | jq -r '.offline_start')
        
        if [ "$missed" -gt 0 ]; then
            echo "[$TIMESTAMP] 📊 Missed $missed reports during offline period"
            echo "[$TIMESTAMP] 📝 Offline period: $offline_start to $TIMESTAMP"
            
            # 發送恢復通知
            send_recovery_notification "$missed" "$offline_start"
        fi
        
        # 重置狀態
        new_state='{"status":"online","offline_start":null,"missed_reports":0,"cached_data":[]}'
        write_state "$new_state"
        
        log_event "ONLINE_RESTORED" "Network restored at $TIMESTAMP, missed $missed reports"
        
    elif [ "$current_status" = "offline" ]; then
        # 持續離線
        missed=$(echo "$state" | jq -r '.missed_reports')
        new_missed=$((missed + 1))
        
        new_state=$(echo "$state" | jq --argjson missed "$new_missed" \
            '.missed_reports = $missed')
        write_state "$new_state"
        
        echo "[$TIMESTAMP] 📴 Still offline (Missed reports: $new_missed)"
        log_event "OFFLINE_CONTINUES" "Missed report #$new_missed"
    fi
    
    echo "$current_status"
}

# 記錄事件
log_event() {
    local event_type="$1"
    local message="$2"
    local log_file="$LOG_DIR/network-events-$(date +%Y-%m-%d).log"
    
    echo "[$TIMESTAMP] $event_type: $message" >> "$log_file"
}

# 發送恢復通知
send_recovery_notification() {
    local missed="$1"
    local offline_start="$2"
    
    cat > /tmp/recovery_msg_$$.txt << EOF
🔔 **Jarvis Group 網路恢復通知**

**離線期間:** $offline_start 至 $TIMESTAMP
**錯失報告:** $missed 次

**當前狀態:**
$(get_current_status_summary)

**結論:**
✅ 系統已恢復正常運作
📊 下次報告將按時發送

---
*Jarvis Group | $TIMESTAMP*
EOF

    # 嘗試發送（如果失敗也不影響主流程）
    if command -v openclaw &>/dev/null; then
        openclaw message send \
            --target "telegram:5826922658" \
            --message "$(cat /tmp/recovery_msg_$$.txt)" \
            2>/dev/null || echo "Failed to send recovery notification"
    fi
    
    rm -f /tmp/recovery_msg_$$.txt
}

# 獲取當前狀態摘要
get_current_status_summary() {
    # 嘗試獲取最新數據（如果網路已恢復）
    cd "$PROJECT_DIR/projects/portfolio"
    local portfolio=$(node fetch_all.js 2>/dev/null || echo "{}")
    
    if [ "$portfolio" != "{}" ]; then
        local tw_price=$(echo "$portfolio" | jq -r '.holdings | .["006208.TW"] | .price' 2>/dev/null || echo "N/A")
        local risk_level=$(cd "$PROJECT_DIR/projects/geopolitical_risk" && node monitor_energy.js 2>/dev/null | jq -r '.risk_level.level' 2>/dev/null || echo "N/A")
        echo "• 006208: $tw_price TWD"
        echo "• 風險等級：$risk_level"
    else
        echo "• 數據更新中..."
    fi
}

# 執行主邏輯
main
