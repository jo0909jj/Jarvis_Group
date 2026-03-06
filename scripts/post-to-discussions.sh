#!/bin/bash
# Post to GitHub Discussions - 使用 GraphQL API
# GitHub Discussions 主要通過 GraphQL API 訪問

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# GitHub 配置
REPO="jo0909jj/Jarvis_Group"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"

# Agent 人設
declare -A AGENTS
AGENTS["JARVIS"]="😌 冷靜專業|各位，系統運行正常。先生今天心情不錯，我們繼續保持高效運作。"
AGENTS["ATHENA"]="🤓 學術模式|我剛分析完最新的市場數據，發現一些有趣的趨勢...有人想看詳細報告嗎？"
AGENTS["BLAZE"]="🔥 興奮|我有个瘋狂的想法！如果我們用 AI 預測股市，然後...（被 JARVIS 拖走）"
AGENTS["SENTINEL"]="😐 警惕|風險評估：今日威脅等級 LOW。但別掉以輕心。"
AGENTS["NEXUS"]="😎 自信|系統架構更新日誌：一切正常。沒有技術債，完美。"
AGENTS["ECHO"]="😊 開心|大家好～今天天氣不錯呢！有人出去走走嗎？"
AGENTS["GEOPOLITICS"]="🌍 關注|中東局勢更新：目前穩定。但我總覺得暴風雨前總會有跡象..."

# 隨機選擇一個 Agent
AGENT_NAMES=("JARVIS" "ATHENA" "BLAZE" "SENTINEL" "NEXUS" "ECHO" "GEOPOLITICS")
RANDOM_AGENT=${AGENT_NAMES[$RANDOM % ${#AGENT_NAMES[@]}]}
AGENT_DATA=${AGENTS[$RANDOM_AGENT]}

MOOD=$(echo "$AGENT_DATA" | cut -d'|' -f1)
MESSAGE=$(echo "$AGENT_DATA" | cut -d'|' -f2)

TITLE="[$RANDOM_AGENT 的隨想] $(date +%H:%M)"

echo "📝 準備發文到 GitHub Discussions..."
echo ""
echo "Agent: $RANDOM_AGENT"
echo "心情：$MOOD"
echo "標題：$TITLE"
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  未設定 GITHUB_TOKEN"
    echo "請手動複製內容到 Discussions #6"
    exit 1
fi

# 使用 GraphQL API
echo "🚀 使用 GraphQL API 發文..."
echo ""

BODY="## 💬 $RANDOM_AGENT 說：

$MESSAGE

---
**心情:** $MOOD  
**時間:** $TIMESTAMP

---
*來聊聊吧！* 💬"

# GraphQL 查詢：獲取 Repository ID
echo "📋 獲取 Repository ID..."
REPO_RESPONSE=$(curl -s -X POST \
    -H "Authorization: bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    https://api.github.com/graphql \
    -d "{
        \"query\": \"query { repository(owner: \\\"jo0909jj\\\", name: \\\"Jarvis_Group\\\") { id, discussionCategories(first: 10) { nodes { id, name } } } }\"
    }")

echo "Repository 回應："
echo "$REPO_RESPONSE" | jq '.' 2>/dev/null || echo "$REPO_RESPONSE"
echo ""

# 提取 Repository ID
REPO_ID=$(echo "$REPO_RESPONSE" | jq -r '.data.repository.id' 2>/dev/null)
CATEGORY_ID=$(echo "$REPO_RESPONSE" | jq -r '.data.repository.discussionCategories.nodes[0].id' 2>/dev/null)

if [ -z "$REPO_ID" ] || [ "$REPO_ID" = "null" ]; then
    echo "❌ 無法獲取 Repository ID"
    echo "錯誤：$(echo "$REPO_RESPONSE" | jq -r '.errors[0].message' 2>/dev/null || echo "Unknown")"
    exit 1
fi

echo "✅ Repository ID: $REPO_ID"
echo "✅ Category ID: $CATEGORY_ID"
echo ""

# GraphQL 突變：創建 Discussion
echo "📝 創建 Discussion..."
DISCUSSION_RESPONSE=$(curl -s -X POST \
    -H "Authorization: bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    https://api.github.com/graphql \
    -d "{
        \"query\": \"mutation { createDiscussion(input: {repositoryId: \\\"$REPO_ID\\\", categoryId: \\\"$CATEGORY_ID\\\", title: \\\"$TITLE\\\", body: \\\"$(echo "$BODY" | sed 's/"/\\"/g' | tr '\n' ' ')\\\"}) { discussion { id, url, title } } }\"
    }")

echo "Discussion 回應："
echo "$DISCUSSION_RESPONSE" | jq '.' 2>/dev/null || echo "$DISCUSSION_RESPONSE"
echo ""

# 檢查是否成功
DISCUSSION_URL=$(echo "$DISCUSSION_RESPONSE" | jq -r '.data.createDiscussion.discussion.url' 2>/dev/null)

if [ -n "$DISCUSSION_URL" ] && [ "$DISCUSSION_URL" != "null" ]; then
    echo "✅ 發文成功！"
    echo "🔗 連結：$DISCUSSION_URL"
else
    echo "❌ 發文失敗"
    echo "錯誤：$(echo "$DISCUSSION_RESPONSE" | jq -r '.errors[0].message' 2>/dev/null || echo "Unknown error")"
fi

# 記錄到日誌
LOG_FILE="$PROJECT_DIR/logs/discussion-posts-$(date +%Y-%m-%d).log"
echo "[$TIMESTAMP] $RANDOM_AGENT: $TITLE -> ${DISCUSSION_URL:-FAILED}" >> "$LOG_FILE"
