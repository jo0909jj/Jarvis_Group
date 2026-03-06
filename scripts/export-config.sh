#!/bin/bash
# Export Jarvis Group Configuration - 導出配置

set -e

echo "📦 導出 Jarvis Group 配置..."
echo ""

# 建立導出目錄
EXPORT_DIR=~/jarvis_export
mkdir -p "$EXPORT_DIR"

# 導出 OpenClaw 配置
if [ -f ~/.openclaw/openclaw.json ]; then
    cp ~/.openclaw/openclaw.json "$EXPORT_DIR/"
    echo "✅ OpenClaw 配置已導出"
else
    echo "⚠️  找不到 OpenClaw 配置文件"
fi

# 導出 Cron 配置
crontab -l > "$EXPORT_DIR/crontab.txt" 2>/dev/null || echo "# No crontab" > "$EXPORT_DIR/crontab.txt"
echo "✅ Cron 配置已導出"

# 導出環境變數 (從 bashrc 提取)
grep -E "GITHUB_TOKEN|TELEGRAM_BOT_TOKEN" ~/.bashrc > "$EXPORT_DIR/env_vars.sh" 2>/dev/null || echo "# Add your tokens here" > "$EXPORT_DIR/env_vars.sh"
echo "✅ 環境變數已導出"

# 壓縮
cd ~
tar -czf jarvis_export_$(date +%Y%m%d_%H%M%S).tar.gz jarvis_export/

echo ""
echo "=========================================="
echo "✅ 導出完成！"
echo "=========================================="
echo ""
echo "檔案位置：~/jarvis_export_$(date +%Y%m%d_%H%M%S).tar.gz"
echo ""
echo "請將此檔案傳輸到新電腦並執行："
echo "  ./import-config.sh"
echo ""
echo "或者手動複製："
echo "  scp ~/jarvis_export_*.tar.gz user@new-computer:~/"
echo ""
