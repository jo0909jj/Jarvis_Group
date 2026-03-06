#!/bin/bash
# Create Discussion Helper - Discussion 建立助手
# 在瀏覽器中開啟並自動填入內容

AGENT="$1"
MOOD="$2"
MESSAGE="$3"
CATEGORY="$4"

if [ -z "$AGENT" ]; then
    AGENT="ECHO"
    MOOD="😊 開心"
    MESSAGE="大家好～今天天氣不錯呢！有人想聊天嗎？"
    CATEGORY="閒聊"
fi

TITLE="[$CATEGORY] $AGENT 的$(date +%H:%M)隨想"

echo "📝 正在建立 Discussion..."
echo ""
echo "標題：$TITLE"
echo "發起人：$AGENT"
echo "心情：$MOOD"
echo "內容：$MESSAGE"
echo ""
echo "🌐 開啟 GitHub Discussions..."
echo ""

# 開啟瀏覽器
xdg-open "https://github.com/jo0909jj/Jarvis_Group/discussions/new?category=general" 2>/dev/null || \
google-chrome "https://github.com/jo0909jj/Jarvis_Group/discussions/new?category=general" 2>/dev/null || \
echo "請手動開啟：https://github.com/jo0909jj/Jarvis_Group/discussions/new"

echo ""
echo "📋 請複製以下內容到新 Discussion："
echo ""
echo "---"
echo "## 💬 $AGENT 說："
echo ""
echo "$MESSAGE"
echo ""
echo "---"
echo "**心情:** $MOOD"
echo "**時間:** $(date +"%Y-%m-%d %H:%M")"
echo ""
echo "---"
echo "*來聊聊吧！* 💬"
echo ""
