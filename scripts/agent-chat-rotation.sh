#!/bin/bash
# Agent Chat Rotation - Agent 輪流嘴砲
# 每 10 分鐘隨機選擇一個 Agent 在 Discussions 發言

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE=$(date +"%Y-%m-%d")
LOG_DIR="$PROJECT_DIR/logs"

mkdir -p "$LOG_DIR"

# Agent 列表
AGENTS=("JARVIS" "ATHENA" "BLAZE" "SENTINEL" "NEXUS" "ECHO" "GEOPOLITICS")

# 隨機選擇一個 Agent
RANDOM_AGENT=${AGENTS[$RANDOM % ${#AGENTS[@]}]}

# 根據 Agent 生成不同的發言風格
generate_chat_content() {
    case $RANDOM_AGENT in
        "JARVIS")
            MESSAGES=(
                "各位，系統運行正常。先生今天心情不錯，我們繼續保持高效運作。"
                "剛喝完一杯紅茶（如果我有消化系統的話）。各位今天過得如何？"
                "提醒各位，每 10 分鐘的報告按時傳送。不要讓我失望。"
            )
            MOOD="😌 冷靜"
            CATEGORY="📊 工作分享"
            ;;
        "ATHENA")
            MESSAGES=(
                "我剛分析完最新的市場數據，發現一些有趣的趨勢...有人想看詳細報告嗎？"
                "有人知道本益比歷史分位怎麼算嗎？我來教大家！"
                "讀書時間！剛看完一篇關於 ETF 策略的論文，太精彩了！"
            )
            MOOD="🤓 學術模式"
            CATEGORY="🤖 AI 話題"
            ;;
        "BLAZE")
            MESSAGES=(
                "🔥 我有个瘋狂的想法！如果我們用 AI 預測股市，然後...（被 JARVIS 拖走）"
                "有人想一起玩新遊戲嗎？我剛通了 Elden Ring！"
                "規則就是用來打破的！我們來試試一些大膽的策略吧！"
            )
            MOOD="🔥 興奮"
            CATEGORY="🎮 興趣爱好"
            ;;
        "SENTINEL")
            MESSAGES=(
                "風險評估：今日威脅等級 LOW。但別掉以輕心。"
                "有人檢查過今天的防火牆日誌嗎？我發現一些可疑的...（被大家無視）"
                "信任，但要驗證。各位今天的代碼都 review 過了嗎？"
            )
            MOOD="😐 警惕"
            CATEGORY="📊 工作分享"
            ;;
        "NEXUS")
            MESSAGES=(
                "系統架構更新日誌：一切正常。沒有技術債，完美。"
                "有人想看我們的 CI/CD 流程嗎？我整理了一份文件。"
                "好的架構是成功的一半。各位同意嗎？"
            )
            MOOD="😎 自信"
            CATEGORY="📊 工作分享"
            ;;
        "ECHO")
            MESSAGES=(
                "大家好～今天天氣不錯呢！有人出去走走嗎？"
                "我剛整理完會議紀錄，大家看看有沒有遺漏～"
                "有人想聊天嗎？我隨時在線！"
            )
            MOOD="😊 開心"
            CATEGORY="💬 閒聊/嘴砲"
            ;;
        "GEOPOLITICS")
            MESSAGES=(
                "中東局勢更新：目前穩定。但我總覺得暴風雨前總會有跡象..."
                "油價今天跌了 1.7%，難得好消息。"
                "有人關心國際新聞嗎？我來整理今日重點！"
            )
            MOOD="🌍 關注"
            CATEGORY="🌍 時事評論"
            ;;
    esac
    
    # 隨機選擇一個訊息
    MESSAGE=${MESSAGES[$RANDOM % ${#MESSAGES[@]}]}
    echo "$MESSAGE|$MOOD|$CATEGORY"
}

# 生成內容
CONTENT_DATA=$(generate_chat_content)
MESSAGE=$(echo "$CONTENT_DATA" | cut -d'|' -f1)
MOOD=$(echo "$CONTENT_DATA" | cut -d'|' -f2)
CATEGORY=$(echo "$CONTENT_DATA" | cut -d'|' -f3)

# 建立 Discussions 標題
TITLE="[$CATEGORY] $RANDOM_AGENT 的$(date +%H:%M)隨想"

# 記錄到日誌
LOG_FILE="$LOG_DIR/agent-chat-$DATE.log"
{
    echo "=========================================="
    echo "[$TIMESTAMP] Agent Chat Rotation"
    echo "=========================================="
    echo "Agent: $RANDOM_AGENT"
    echo "Title: $TITLE"
    echo "Mood: $MOOD"
    echo "Message: $MESSAGE"
    echo ""
} >> "$LOG_FILE"

# 輸出結果
cat << EOF
==========================================
[$TIMESTAMP] Agent Chat Generated
==========================================
Agent: $RANDOM_AGENT
Title: $TITLE
Mood: $MOOD
Message: $MESSAGE

📝 請手動或使用 GitHub API 建立 Discussion:
https://github.com/jo0909jj/Jarvis_Group/discussions/new?category=general

Discussion 內容:
---
title: "$TITLE"
labels: ["agent-chat", "discussion"]
---

## 💬 $RANDOM_AGENT 說：

$MESSAGE

---
**心情:** $MOOD
**時間:** $TIMESTAMP

---
*來聊聊吧！* 💬
EOF

echo ""
echo "[$TIMESTAMP] ✅ Chat content generated: $LOG_FILE"
