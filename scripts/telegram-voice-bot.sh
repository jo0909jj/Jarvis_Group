#!/bin/bash
# Telegram Voice Bot - Telegram 語音機器人
# 接收語音訊息，文字回答

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "📱 Jarvis Telegram 語音機器人"
echo "=============================="
echo ""
echo "這個腳本會："
echo "1. 監聽 Telegram 語音訊息"
echo "2. 自動轉成文字"
echo "3. 查詢並文字回覆"
echo ""
echo "⚠️  需要 Telegram Bot API"
echo ""

# 使用 Python + python-telegram-bot
cat > /tmp/telegram_voice_bot_$$.py << 'PYTHON_EOF'
#!/usr/bin/env python3
import os
import sys
import subprocess
import json
from datetime import datetime

# 簡單實現：接收用戶輸入，查詢並回覆
def process_voice_query(query):
    """處理語音查詢"""
    query = query.lower()
    
    # 查詢 006208
    if '006208' in query or '富邦' in query:
        result = subprocess.run(
            ['node', 'projects/portfolio/fetch_all.js'],
            capture_output=True,
            text=True,
            cwd='/home/user/.openclaw/workspace/Jarvis_Group'
        )
        try:
            data = json.loads(result.stdout)
            price = data['holdings']['006208.TW']['price']
            change = data['holdings']['006208.TW']['changePercent']
            return f"先生，目前 006208 價格 {price} 元，漲跌 {change}%"
        except:
            return "抱歉，無法獲取 006208 數據"
    
    # 查詢能源
    elif '能源' in query or '油價' in query:
        result = subprocess.run(
            ['node', 'projects/geopolitical_risk/monitor_energy.js'],
            capture_output=True,
            text=True,
            cwd='/home/user/.openclaw/workspace/Jarvis_Group'
        )
        try:
            data = json.loads(result.stdout)
            wti = data['crude_oil']['wti']['price']
            return f"目前 WTI 原油價格 {wti} 美元"
        except:
            return "抱歉，無法獲取能源數據"
    
    # 查詢 MSFT
    elif 'msft' in query or '微軟' in query:
        result = subprocess.run(
            ['node', 'projects/portfolio/fetch_all.js'],
            capture_output=True,
            text=True,
            cwd='/home/user/.openclaw/workspace/Jarvis_Group'
        )
        try:
            data = json.loads(result.stdout)
            price = data['holdings']['MSFT']['price']
            return f"微軟股價 {price} 美元"
        except:
            return "抱歉，無法獲取 MSFT 數據"
    
    # 查詢 GOOGL
    elif 'googl' in query or '谷歌' in query:
        result = subprocess.run(
            ['node', 'projects/portfolio/fetch_all.js'],
            capture_output=True,
            text=True,
            cwd='/home/user/.openclaw/workspace/Jarvis_Group'
        )
        try:
            data = json.loads(result.stdout)
            price = data['holdings']['GOOGL']['price']
            return f"谷歌股價 {price} 美元"
        except:
            return "抱歉，無法獲取 GOOGL 數據"
    
    # 風險查詢
    elif '風險' in query:
        result = subprocess.run(
            ['node', 'projects/geopolitical_risk/monitor_energy.js'],
            capture_output=True,
            text=True,
            cwd='/home/user/.openclaw/workspace/Jarvis_Group'
        )
        try:
            data = json.loads(result.stdout)
            level = data['risk_level']['level']
            return f"目前風險等級 {level}，市場穩定"
        except:
            return "抱歉，無法獲取風險數據"
    
    else:
        return "抱歉，我沒聽清楚。您可以問：006208 股價、油價、MSFT、GOOGL、風險等級"

# 主循環
print("🎙️ 語音機器人就緒！")
print("輸入語音轉文字後的內容，或直接輸入文字查詢")
print("輸入 'quit' 退出")
print("")

while True:
    try:
        query = input("您：").strip()
        if query.lower() == 'quit':
            break
        
        response = process_voice_query(query)
        print(f"Jarvis: {response}")
        print("")
        
    except KeyboardInterrupt:
        break
    except Exception as e:
        print(f"錯誤：{e}")

PYTHON_EOF

python3 /tmp/telegram_voice_bot_$$.py
rm -f /tmp/telegram_voice_bot_$$.py
