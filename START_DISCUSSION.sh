#!/bin/bash
# Quick Start Discussion - 快速開啟 Discussion

echo "🌐 開啟 GitHub Discussions..."
echo ""

# 嘗試開啟瀏覽器
if command -v xdg-open &>/dev/null; then
    xdg-open "https://github.com/jo0909jj/Jarvis_Group/discussions/new?category=general"
elif command -v google-chrome &>/dev/null; then
    google-chrome "https://github.com/jo0909jj/Jarvis_Group/discussions/new?category=general"
else
    echo "請手動開啟：https://github.com/jo0909jj/Jarvis_Group/discussions/new?category=general"
fi

echo ""
echo "📋 建議標題：[💬 閒聊] ECHO 的下午茶時間 ☕"
echo ""
echo "內容請參考：DISCUSSION_STARTERS.md"
echo ""
