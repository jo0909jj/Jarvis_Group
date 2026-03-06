#!/bin/bash
# Enable Advanced Features - 啟用進階功能
# 啟用瀏覽器控制和網路搜尋

set -e

echo "🚀 啟用 Jarvis Group 進階功能..."
echo ""

# 檢查 OpenClaw 配置
CONFIG_FILE="$HOME/.openclaw/openclaw.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ OpenClaw 配置文件不存在：$CONFIG_FILE"
    exit 1
fi

echo "✅ 找到配置文件：$CONFIG_FILE"
echo ""

# 步驟 1: 啟用網路搜尋
echo "📡 步驟 1: 啟用網路搜尋..."

# 備份配置文件
cp "$CONFIG_FILE" "$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
echo "✅ 配置文件已備份"

# 使用 sed 修改配置
sed -i 's/"search": { "enabled": false }/"search": { "enabled": true }/g' "$CONFIG_FILE"
sed -i 's/"fetch": { "enabled": false }/"fetch": { "enabled": true }/g' "$CONFIG_FILE"

echo "✅ 網路搜尋已啟用"
echo ""

# 步驟 2: Gateway 認證
echo "🌐 步驟 2: Gateway 認證..."
echo ""
echo "請執行以下命令："
echo ""
echo "  openclaw gateway status"
echo "  openclaw gateway restart"
echo ""
echo "如果需要更新 token，請編輯 $CONFIG_FILE"
echo "找到 gateway.auth.token 並更新為新值"
echo ""

# 完成
echo "=========================================="
echo "✅ 進階功能啟用完成！"
echo ""
echo "已啟用："
echo "  ✅ 網路搜尋 (web search/fetch)"
echo "  ⏳ 瀏覽器控制 (需重啟 gateway)"
echo ""
echo "下一步："
echo "  1. 重啟 OpenClaw 或 gateway"
echo "  2. 測試瀏覽器控制功能"
echo ""
echo "=========================================="
