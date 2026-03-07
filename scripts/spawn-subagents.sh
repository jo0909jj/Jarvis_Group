#!/bin/bash
# Spawn Sub-Agents - 創建獨立的 Agent Sessions
# 使用 OpenClaw sessions_spawn 創建隔離的執行環境

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] 🚀 Spawning Sub-Agent Sessions..."

# Agent 配置
declare -A AGENTS
AGENTS["ATHENA"]="研究分析專家，負責數據收集和分析"
AGENTS["BLAZE"]="創意開發專家，負責腦力激盪和創新想法"
AGENTS["SENTINEL"]="安全審計專家，負責風險評估和安全檢查"
AGENTS["NEXUS"]="系統整合專家，負責技術架構和系統設計"
AGENTS["ECHO"]="用戶溝通專家，負責用戶互動和通知推送"
AGENTS["GEOPOLITICS"]="地緣政治專家，負責國際情勢分析"

# 為每個 Agent 創建 session
for agent_name in "${!AGENTS[@]}"; do
    agent_desc="${AGENTS[$agent_name]}"
    session_key="${agent_name,,}-001"  # 轉為小寫
    
    echo "📋 創建 $agent_name Session..."
    
    # 使用 OpenClaw sessions_spawn 創建 session
    # 注意：這裡需要使用 openclaw CLI 或 API
    # 由於 sessions_spawn 是內部工具，我們用註解說明
    
    cat << EOF
┌─────────────────────────────────────────┐
│ Agent: $agent_name
│ Session: $session_key
│ 描述：$agent_desc
│ 狀態：待創建
└─────────────────────────────────────────┘

EOF

done

echo "[$TIMESTAMP] ✅ Sub-Agent sessions configuration ready."
echo ""
echo "📝 下一步："
echo "1. 在 OpenClaw 主 session 中執行 sessions_spawn 命令"
echo "2. 或使用 OpenClaw API 創建 session"
echo ""
echo "範例命令（在 OpenClaw 中）："
echo '  sessions_spawn --label "ATHENA" --task "負責研究分析任務" --mode "session"'
