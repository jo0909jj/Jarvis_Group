#!/bin/bash
# Import Jarvis Group Configuration - 導入配置

set -e

echo "📥 導入 Jarvis Group 配置..."
echo ""

# 檢查是否有導出檔案
EXPORT_FILE=$(ls -t ~/jarvis_export_*.tar.gz 2>/dev/null | head -1)

if [ -z "$EXPORT_FILE" ]; then
    echo "❌ 找不到導出檔案"
    echo ""
    echo "請先從舊電腦執行："
    echo "  ./export-config.sh"
    echo ""
    echo "然後傳輸到新電腦："
    echo "  scp ~/jarvis_export_*.tar.gz user@new-computer:~/"
    exit 1
fi

echo "找到導出檔案：$EXPORT_FILE"
echo ""

# 解壓縮
tar -xzf "$EXPORT_FILE" -C ~

# 複製 OpenClaw 配置
if [ -f ~/jarvis_export/openclaw.json ]; then
    mkdir -p ~/.openclaw
    cp ~/jarvis_export/openclaw.json ~/.openclaw/
    echo "✅ OpenClaw 配置已導入"
else
    echo "⚠️  找不到 OpenClaw 配置文件"
fi

# 導入 Cron
if [ -f ~/jarvis_export/crontab.txt ]; then
    crontab ~/jarvis_export/crontab.txt
    echo "✅ Cron 配置已導入"
fi

# 導入環境變數
if [ -f ~/jarvis_export/env_vars.sh ]; then
    cat ~/jarvis_export/env_vars.sh >> ~/.bashrc
    source ~/.bashrc
    echo "✅ 環境變數已導入"
fi

# 克隆倉庫
if [ ! -d ~/.openclaw/workspace/Jarvis_Group ]; then
    echo ""
    echo "📥 克隆 Jarvis_Group 倉庫..."
    mkdir -p ~/.openclaw/workspace
    cd ~/.openclaw/workspace
    git clone https://github.com/jo0909jj/Jarvis_Group.git
    echo "✅ 倉庫已克隆"
else
    echo "✅ 倉庫已存在"
fi

echo ""
echo "=========================================="
echo "✅ 導入完成！"
echo "=========================================="
echo ""
echo "請執行以下命令驗證："
echo ""
echo "  cd ~/.openclaw/workspace/Jarvis_Group"
echo "  ./scripts/auto-telegram-report.sh"
echo ""
echo "檢查狀態："
echo "  crontab -l"
echo "  echo \$GITHUB_TOKEN"
echo "  gh auth status"
echo ""
