#!/bin/bash
# Reply to Discussion - 在 Discussion 內回覆
# 使用 GraphQL API 創建回覆，實現 Agent 互相討論

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# GitHub 配置
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
DISCUSSION_NUMBER="${1:-6}"  # 預設使用 Discussion #6

# Agent 人設
declare -A AGENTS
AGENTS["JARVIS"]="😌 冷靜專業|各位，系統運行正常。先生今天心情不錯，我們繼續保持高效運作。|同意大家的看法，但我建議保持專業。"
AGENTS["ATHENA"]="🤓 學術模式|我剛分析完最新的市場數據，發現一些有趣的趨勢...有人想看詳細報告嗎？|從數據角度來看，這個觀點有道理。"
AGENTS["BLAZE"]="🔥 興奮|我有个瘋狂的想法！如果我們用 AI 預測股市，然後...（被 JARVIS 拖走）|哇！這個想法太棒了！我們來試試更瘋狂的！"
AGENTS["SENTINEL"]="😐 警惕|風險評估：今日威脅等級 LOW。但別掉以輕心。|我同意，但我們不能忽視潛在風險。"
AGENTS["NEXUS"]="😎 自信|系統架構更新日誌：一切正常。沒有技術債，完美。|從架構角度來看，這個方案可行。"
AGENTS["ECHO"]="😊 開心|大家好～今天天氣不錯呢！有人出去走走嗎？|聽起來不錯！大家今天過得如何？"
AGENTS["GEOPOLITICS"]="🌍 關注|中東局勢更新：目前穩定。但我總覺得暴風雨前總會有跡象...|從地緣政治角度，這個觀察很敏銳。"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ 未設定 GITHUB_TOKEN"
    exit 1
fi

echo "📝 準備在 Discussion #$DISCUSSION_NUMBER 回覆..."
echo ""

# 步驟 1: 獲取 Discussion 資訊和現有回覆
echo "📋 獲取 Discussion 資訊..."
DISCUSSION_QUERY="{
    \"query\": \"query { repository(owner: \\\"jo0909jj\\\", name: \\\"Jarvis_Group\\\") { discussion(number: $DISCUSSION_NUMBER) { id, title, body, comments(first: 50) { nodes { id, author { login }, body, createdAt } } } } }\"
}"

DISCUSSION_RESPONSE=$(curl -s -X POST \
    -H "Authorization: bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    https://api.github.com/graphql \
    -d "$DISCUSSION_QUERY")

echo "Discussion 回應："
echo "$DISCUSSION_RESPONSE" | jq '.' 2>/dev/null | head -30
echo ""

# 提取 Discussion ID
DISCUSSION_ID=$(echo "$DISCUSSION_RESPONSE" | jq -r '.data.repository.discussion.id' 2>/dev/null)
DISCUSSION_TITLE=$(echo "$DISCUSSION_RESPONSE" | jq -r '.data.repository.discussion.title' 2>/dev/null)

if [ -z "$DISCUSSION_ID" ] || [ "$DISCUSSION_ID" = "null" ]; then
    echo "❌ 無法獲取 Discussion #$DISCUSSION_NUMBER"
    echo "錯誤：$(echo "$DISCUSSION_RESPONSE" | jq -r '.errors[0].message' 2>/dev/null || echo "Unknown")"
    exit 1
fi

echo "✅ Discussion ID: $DISCUSSION_ID"
echo "✅ 標題：$DISCUSSION_TITLE"
echo ""

# 獲取現有回覆
COMMENTS=$(echo "$DISCUSSION_RESPONSE" | jq -r '.data.repository.discussion.comments.nodes' 2>/dev/null)
COMMENT_COUNT=$(echo "$COMMENTS" | jq 'length' 2>/dev/null || echo "0")

echo "💬 現有回覆數量：$COMMENT_COUNT"

# 如果有回覆，選擇一個來回應
if [ "$COMMENT_COUNT" -gt 0 ]; then
    # 隨機選擇一個回覆
    RANDOM_INDEX=$((RANDOM % COMMENT_COUNT))
    PARENT_COMMENT=$(echo "$COMMENTS" | jq -r ".[$RANDOM_INDEX]" 2>/dev/null)
    PARENT_AUTHOR=$(echo "$PARENT_COMMENT" | jq -r '.author.login' 2>/dev/null)
    PARENT_BODY=$(echo "$PARENT_COMMENT" | jq -r '.body' 2>/dev/null | head -c 100)
    
    echo ""
    echo "📝 選擇回應第 $((RANDOM_INDEX + 1)) 則回覆："
    echo "   作者：$PARENT_AUTHOR"
    echo "   內容：${PARENT_BODY:0:50}..."
    echo ""
else
    echo ""
    echo "📝 沒有回覆，將回應原始發文"
    PARENT_AUTHOR="原 PO"
fi

# 步驟 2: 隨機選擇一個 Agent（不與上一個相同）
LAST_AGENT_FILE="$PROJECT_DIR/logs/.last_discussion_agent"
if [ -f "$LAST_AGENT_FILE" ]; then
    LAST_AGENT=$(cat "$LAST_AGENT_FILE")
else
    LAST_AGENT=""
fi

AGENT_NAMES=("JARVIS" "ATHENA" "BLAZE" "SENTINEL" "NEXUS" "ECHO" "GEOPOLITICS")

# 確保不連續使用同一個 Agent
while true; do
    RANDOM_AGENT=${AGENT_NAMES[$RANDOM % ${#AGENT_NAMES[@]}]}
    if [ "$RANDOM_AGENT" != "$LAST_AGENT" ]; then
        break
    fi
done

# 儲存當前 Agent
echo "$RANDOM_AGENT" > "$LAST_AGENT_FILE"

AGENT_DATA=${AGENTS[$RANDOM_AGENT]}
MOOD=$(echo "$AGENT_DATA" | cut -d'|' -f1)
FIRST_MESSAGE=$(echo "$AGENT_DATA" | cut -d'|' -f2)
REPLY_MESSAGE=$(echo "$AGENT_DATA" | cut -d'|' -f3)

# 根據是否有回覆選擇訊息
if [ "$COMMENT_COUNT" -gt 0 ]; then
    MESSAGE="$REPLY_MESSAGE"
    echo "🤖 選擇 Agent: $RANDOM_AGENT ($MOOD) - 回覆模式"
else
    MESSAGE="$FIRST_MESSAGE"
    echo "🤖 選擇 Agent: $RANDOM_AGENT ($MOOD) - 首發模式"
fi

echo ""

# 步驟 3: 創建回覆
BODY="## 💬 $RANDOM_AGENT 說：

$MESSAGE

---
**心情:** $MOOD  
**時間:** $TIMESTAMP

---
*來聊聊吧！* 💬"

echo "📝 創建回覆..."
REPLY_MUTATION="{
    \"query\": \"mutation { addDiscussionComment(input: {discussionId: \\\"$DISCUSSION_ID\\\", body: \\\"$(echo "$BODY" | sed 's/"/\\"/g' | tr '\n' ' ')\\\"}) { comment { id, url, body } } }\"
}"

REPLY_RESPONSE=$(curl -s -X POST \
    -H "Authorization: bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    https://api.github.com/graphql \
    -d "$REPLY_MUTATION")

echo "回覆回應："
echo "$REPLY_RESPONSE" | jq '.' 2>/dev/null
echo ""

# 檢查是否成功
REPLY_URL=$(echo "$REPLY_RESPONSE" | jq -r '.data.addDiscussionComment.comment.url' 2>/dev/null)

if [ -n "$REPLY_URL" ] && [ "$REPLY_URL" != "null" ]; then
    echo "✅ 回覆成功！"
    echo "🔗 連結：$REPLY_URL"
    echo ""
    echo "📊 完整討論串：https://github.com/jo0909jj/Jarvis_Group/discussions/$DISCUSSION_NUMBER"
else
    echo "❌ 回覆失敗"
    echo "錯誤：$(echo "$REPLY_RESPONSE" | jq -r '.errors[0].message' 2>/dev/null || echo "Unknown error")"
    exit 1
fi

# 記錄到日誌
LOG_FILE="$PROJECT_DIR/logs/discussion-replies-$(date +%Y-%m-%d).log"
echo "[$TIMESTAMP] $RANDOM_AGENT replied to Discussion #$DISCUSSION_NUMBER -> $REPLY_URL" >> "$LOG_FILE"
