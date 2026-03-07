#!/bin/bash
# Quick Discussion Reply - 快速 Discussion 回覆
# 使用簡化的 GraphQL 查詢

# 載入環境變數
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ 未設定 GITHUB_TOKEN"
    exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DISCUSSION_ID="D_kwDORfo0i84Akj0G"  # Discussion #6 的 ID
CATEGORY_ID="DIC_kwDORfo0i84C3yKg"  # General category

# Agent 人設
AGENTS=("JARVIS" "ATHENA" "BLAZE" "SENTINEL" "NEXUS" "ECHO" "GEOPOLITICS")
RANDOM_AGENT=${AGENTS[$RANDOM % ${#AGENTS[@]}]}

case $RANDOM_AGENT in
    "JARVIS") MOOD="😌 冷靜專業"; MSG="各位，系統運行正常。" ;;
    "ATHENA") MOOD="🤓 學術模式"; MSG="我剛分析完最新的市場數據。" ;;
    "BLAZE") MOOD="🔥 興奮"; MSG="我有个瘋狂的想法！" ;;
    "SENTINEL") MOOD="😐 警惕"; MSG="風險評估：今日威脅等級 LOW。" ;;
    "NEXUS") MOOD="😎 自信"; MSG="系統架構更新日誌：一切正常。" ;;
    "ECHO") MOOD="😊 開心"; MSG="大家好～今天天氣不錯呢！" ;;
    "GEOPOLITICS") MOOD="🌍 關注"; MSG="中東局勢更新：目前穩定。" ;;
esac

BODY="## 💬 $RANDOM_AGENT 說：

$MESSAGE

---
**心情:** $MOOD  
**時間:** $TIMESTAMP

---
*來聊聊吧！* 💬"

echo "📝 發送 $RANDOM_AGENT 的回覆..."

# 使用簡化的 GraphQL mutation
RESPONSE=$(curl -s -X POST \
    -H "Authorization: bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    https://api.github.com/graphql \
    -d "{
        \"query\": \"mutation { createDiscussionComment(input: {discussionId: \\\"$DISCUSSION_ID\\\", body: \\\"$BODY\\\"}) { comment { url } } }\"
    }" 2>&1)

if echo "$RESPONSE" | grep -q '"url"'; then
    URL=$(echo "$RESPONSE" | grep -o '"url":"[^"]*"' | cut -d'"' -f4)
    echo "✅ 回覆成功！"
    echo "🔗 $URL"
else
    echo "❌ 回覆失敗"
    echo "$RESPONSE" | head -5
fi
