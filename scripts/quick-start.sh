#!/bin/bash
# Quick Start - Jarvis Group 多帳號系統快速啟動

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "╔════════════════════════════════════════════════════════╗"
echo "║     Jarvis Group 多帳號系統 - 快速啟動指南            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# 檢查 .env 文件
if [ ! -f "$PROJECT_DIR/.env" ]; then
    echo "❌ .env 文件不存在"
    echo "請執行：cp $PROJECT_DIR/.env.example $PROJECT_DIR/.env"
    exit 1
fi

# 步驟 1：檢查 Telegram Bot Token
echo "📋 步驟 1：檢查 Telegram Bot 配置"
echo "─────────────────────────────────────"

TOKEN_COUNT=0
for agent in JARVIS ATHENA BLAZE SENTINEL NEXUS ECHO GEOPOLITICS; do
    var_name="TELEGRAM_${agent}_TOKEN"
    token="${!var_name}"
    if [ -n "$token" ]; then
        echo "✅ $agent Bot: 已配置"
        ((TOKEN_COUNT++))
    else
        echo "⚠️  $agent Bot: 未配置"
    fi
done

echo ""
echo "已配置：$TOKEN_COUNT / 7 個 Bot"
echo ""

if [ "$TOKEN_COUNT" -lt 7 ]; then
    echo "📝 請按照以下步驟配置 Bot："
    echo "   1. 打開 Telegram，搜尋 @BotFather"
    echo "   2. 發送 /newbot 創建 Bot"
    echo "   3. 將 Token 填入 $PROJECT_DIR/.env"
    echo ""
    echo "詳細指南：$PROJECT_DIR/docs/TELEGRAM_BOTS_SETUP.md"
    echo ""
fi

# 步驟 2：檢查腳本權限
echo "📋 步驟 2：檢查腳本權限"
echo "─────────────────────────────────────"

chmod +x "$PROJECT_DIR/scripts/"*.sh 2>/dev/null || true

for script in test-bot.sh multi-bot-router.sh auto-telegram-report-v2.sh; do
    if [ -x "$PROJECT_DIR/scripts/$script" ]; then
        echo "✅ $script: 可執行"
    else
        echo "⚠️  $script: 權限不足"
        chmod +x "$PROJECT_DIR/scripts/$script" 2>/dev/null && echo "   已修復"
    fi
done

echo ""

# 步驟 3：測試 Bot 連接（如果有配置）
if [ "$TOKEN_COUNT" -gt 0 ]; then
    echo "📋 步驟 3：測試 Bot 連接"
    echo "─────────────────────────────────────"
    
    # 測試第一個已配置的 Bot
    for agent in JARVIS ATHENA BLAZE SENTINEL NEXUS ECHO GEOPOLITICS; do
        var_name="TELEGRAM_${agent}_TOKEN"
        token="${!var_name}"
        if [ -n "$token" ]; then
            echo "測試 $agent Bot..."
            "$PROJECT_DIR/scripts/test-bot.sh" "$agent" "🤖 Jarvis Group 多帳號系統測試" && \
                echo "✅ $agent Bot 測試成功" || \
                echo "❌ $agent Bot 測試失敗"
            break
        fi
    done
    
    echo ""
fi

# 步驟 4：Sub-Agent 系統
echo "📋 步驟 4：Sub-Agent 系統"
echo "─────────────────────────────────────"
echo "✅ Sub-Agent 配置文件已就緒"
echo "   文檔：$PROJECT_DIR/docs/SUBAGENT_SETUP.md"
echo ""
echo "在 OpenClaw 主對話中執行以下命令創建 Sub-Agents："
echo ""
echo '  sessions_spawn --label "ATHENA" --task "負責研究分析任務" --mode "session"'
echo '  sessions_spawn --label "BLAZE" --task "負責創意開發任務" --mode "session"'
echo '  sessions_spawn --label "SENTINEL" --task "負責安全審計任務" --mode "session"'
echo '  sessions_spawn --label "NEXUS" --task "負責系統整合任務" --mode "session"'
echo '  sessions_spawn --label "ECHO" --task "負責用戶溝通任務" --mode "session"'
echo '  sessions_spawn --label "GEOPOLITICS" --task "負責地緣政治任務" --mode "session"'
echo ""

# 步驟 5：更新 Cron（可選）
echo "📋 步驟 5：更新 Cron 配置（可選）"
echo "─────────────────────────────────────"
echo "如果要使用新版多 Bot 報告腳本，更新 Cron："
echo ""
echo "crontab -e"
echo ""
echo "添加或修改："
echo "*/10 9-13 * * 1-5 bash -c 'source ~/.bashrc && $PROJECT_DIR/scripts/auto-telegram-report-v2.sh'"
echo ""

# 完成
echo "╔════════════════════════════════════════════════════════╗"
echo "║                    快速啟動完成                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📚 相關文檔："
echo "   • Telegram Bot 設置：$PROJECT_DIR/docs/TELEGRAM_BOTS_SETUP.md"
echo "   • Sub-Agent 配置：$PROJECT_DIR/docs/SUBAGENT_SETUP.md"
echo "   • 腳本目錄：$PROJECT_DIR/scripts/"
echo ""
echo "🎯 下一步："
echo "   1. 配置 Telegram Bot Tokens（如果還未配置）"
echo "   2. 在 OpenClaw 中創建 Sub-Agent Sessions"
echo "   3. 測試多 Bot 報告系統"
echo ""
