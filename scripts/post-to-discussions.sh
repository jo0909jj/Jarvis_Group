#!/bin/bash
# Post to GitHub Discussions - 實際發文到 Discussions
# 使用 GitHub API 創建討論

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
echo "內容：$MESSAGE"
echo ""

# 如果沒有 GitHub Token，提供手動選項
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  未設定 GITHUB_TOKEN"
    echo ""
    echo "請選擇："
    echo "1. 手動複製內容到 GitHub"
    echo "2. 設定 GITHUB_TOKEN 環境變數自動發文"
    echo ""
    
    # 顯示複製內容
    echo "=========================================="
    echo "📋 請複製以下內容到 Discussions #6:"
    echo "=========================================="
    echo ""
    echo "**標題：** $TITLE"
    echo ""
    echo "**內容：**"
    echo '```markdown'
    echo "## 💬 $RANDOM_AGENT 說："
    echo ""
    echo "$MESSAGE"
    echo ""
    echo "---"
    echo "**心情:** $MOOD"
    echo "**時間:** $TIMESTAMP"
    echo ""
    echo "---"
    echo "*來聊聊吧！* 💬"
    echo '```'
    echo ""
    echo "=========================================="
    echo "🔗 討論區連結：https://github.com/jo0909jj/Jarvis_Group/discussions/6"
    echo "=========================================="
else
    # 使用 GitHub API 發文
    echo "🚀 使用 GitHub API 發文..."
    
    BODY="## 💬 $RANDOM_AGENT 說：

$MESSAGE

---
**心情:** $MOOD  
**時間:** $TIMESTAMP

---
*來聊聊吧！* 💬"

    # 創建 Discussion (需要 Repository 權限)
    RESPONSE=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/repos/$REPO/discussions \
        -d "{
            \"title\": \"$TITLE\",
            \"body\": \"$BODY\",
            \"category_id\": \"DIC_kwDO...\"  # 需要查詢 category ID
        }")
    
    echo "$RESPONSE" | jq '.'
fi

# 記錄到日誌
LOG_FILE="$PROJECT_DIR/logs/discussion-posts-$(date +%Y-%m-%d).log"
echo "[$TIMESTAMP] $RANDOM_AGENT: $TITLE" >> "$LOG_FILE"
