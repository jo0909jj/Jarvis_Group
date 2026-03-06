#!/bin/bash
# Smart Model Router - 智能模型路由
# 根據問題複雜度自動選擇模型

set -e

# 模型配置
MODEL_SIMPLE="bailian/qwen3.5-plus"
MODEL_COMPLEX="bailian/qwen3-max-2026-01-23"

# 複雜問題關鍵詞
COMPLEX_KEYWORDS=(
    "分析"
    "策略"
    "預測"
    "評估"
    "複雜"
    "深度"
    "多步驟"
    "架構"
    "重構"
    "優化"
    "風險評估"
    "投資組合"
    "地緣政治"
    "趨勢"
    "為什麼"
    "如何實現"
    "詳細說明"
    "完整方案"
)

# 簡單問題關鍵詞
SIMPLE_KEYWORDS=(
    "查詢"
    "價格"
    "狀態"
    "更新"
    "推送"
    "發送"
    "記錄"
    "git"
    "commit"
    "push"
    "監控"
    "報告"
    "快速"
    "即時"
)

# 判斷問題複雜度
analyze_complexity() {
    local input="$1"
    local complexity_score=0
    
    # 檢查複雜關鍵詞
    for keyword in "${COMPLEX_KEYWORDS[@]}"; do
        if [[ "$input" == *"$keyword"* ]]; then
            ((complexity_score += 2))
        fi
    done
    
    # 檢查簡單關鍵詞
    for keyword in "${SIMPLE_KEYWORDS[@]}"; do
        if [[ "$input" == *"$keyword"* ]]; then
            ((complexity_score -= 1))
        fi
    done
    
    # 檢查問題長度
    local length=${#input}
    if [ $length -gt 200 ]; then
        ((complexity_score += 3))
    elif [ $length -gt 100 ]; then
        ((complexity_score += 1))
    fi
    
    # 檢查是否包含多個問題
    local question_count=$(echo "$input" | grep -o "?" | wc -l)
    ((complexity_score += question_count))
    
    # 返回結果
    if [ $complexity_score -ge 5 ]; then
        echo "complex"
    else
        echo "simple"
    fi
}

# 選擇模型
select_model() {
    local input="$1"
    local complexity=$(analyze_complexity "$input")
    
    if [ "$complexity" = "complex" ]; then
        echo "$MODEL_COMPLEX"
    else
        echo "$MODEL_SIMPLE"
    fi
}

# 主函數
main() {
    local input="$1"
    
    if [ -z "$input" ]; then
        echo "Usage: $0 \"your question or task\""
        exit 1
    fi
    
    local selected_model=$(select_model "$input")
    local complexity=$(analyze_complexity "$input")
    
    echo "📊 智能模型路由分析"
    echo ""
    echo "輸入長度：${#input} 字元"
    echo "複雜度：$complexity"
    echo "選擇模型：$selected_model"
    echo ""
    
    if [ "$complexity" = "complex" ]; then
        echo "🧠 使用 qwen3-max (深度思考)"
    else
        echo "⚡ 使用 qwen3.5-plus (快速回應)"
    fi
}

# 執行
main "$@"
