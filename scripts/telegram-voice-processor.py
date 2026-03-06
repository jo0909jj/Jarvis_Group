#!/usr/bin/env python3
"""
Telegram Voice Processor - Telegram 語音處理器
接收語音訊息 → 自動轉文字 → 查詢 → 回覆
"""

import os
import sys
import subprocess
import json
import tempfile
import logging
from pathlib import Path
from datetime import datetime

# 日誌設定
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Jarvis Group 路徑
SCRIPT_DIR = Path(__file__).parent
PROJECT_DIR = SCRIPT_DIR.parent
AUDIO_DIR = PROJECT_DIR / "audio"
LOG_DIR = PROJECT_DIR / "logs"

# 建立目錄
AUDIO_DIR.mkdir(exist_ok=True)
LOG_DIR.mkdir(exist_ok=True)

def download_voice_file(file_id: str) -> str:
    """下載 Telegram 語音檔案"""
    logger.info(f"下載語音檔案：{file_id}")
    
    # 使用 openclaw 下載
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = AUDIO_DIR / f"voice_{timestamp}.ogg"
    
    # 這裡需要 Telegram Bot API
    # 簡化版本：假設檔案已經下載
    return str(output_file)

def speech_to_text(audio_file: str) -> str:
    """語音轉文字 (使用 whisper)"""
    logger.info(f"語音轉文字：{audio_file}")
    
    try:
        # 方法 1: 使用 whisper 命令行
        result = subprocess.run(
            ['whisper', audio_file, '--model', 'tiny', '--language', 'zh', '--output_format', 'txt'],
            capture_output=True,
            text=True,
            cwd=str(PROJECT_DIR)
        )
        
        if result.returncode == 0:
            # 讀取轉寫結果
            txt_file = audio_file.rsplit('.', 1)[0] + '.txt'
            with open(txt_file, 'r', encoding='utf-8') as f:
                text = f.read().strip()
            return text
        else:
            logger.error(f"whisper 錯誤：{result.stderr}")
            
    except FileNotFoundError:
        logger.warning("whisper 未安裝，使用模擬模式")
        return "模擬：006208 股價查詢"
    
    return ""

def process_query(query: str) -> str:
    """處理查詢並返回結果"""
    logger.info(f"處理查詢：{query}")
    
    query = query.lower()
    
    try:
        # 查詢 006208
        if '006208' in query or '富邦' in query:
            result = subprocess.run(
                ['node', 'projects/portfolio/fetch_all.js'],
                capture_output=True,
                text=True,
                cwd=str(PROJECT_DIR),
                timeout=10
            )
            data = json.loads(result.stdout)
            price = data['holdings']['006208.TW']['price']
            change = data['holdings']['006208.TW']['changePercent']
            return f"📊 **006208 富邦台 50**\n\n當前價格：{price} TWD\n漲跌：{change}%"
        
        # 查詢 MSFT
        elif 'msft' in query or '微軟' in query:
            result = subprocess.run(
                ['node', 'projects/portfolio/fetch_all.js'],
                capture_output=True,
                text=True,
                cwd=str(PROJECT_DIR),
                timeout=10
            )
            data = json.loads(result.stdout)
            price = data['holdings']['MSFT']['price']
            change = data['holdings']['MSFT']['changePercent']
            return f"💻 **Microsoft**\n\n當前價格：{price} USD\n漲跌：{change}%"
        
        # 查詢 GOOGL
        elif 'googl' in query or '谷歌' in query or 'alphabet' in query:
            result = subprocess.run(
                ['node', 'projects/portfolio/fetch_all.js'],
                capture_output=True,
                text=True,
                cwd=str(PROJECT_DIR),
                timeout=10
            )
            data = json.loads(result.stdout)
            price = data['holdings']['GOOGL']['price']
            change = data['holdings']['GOOGL']['changePercent']
            return f"🔍 **Alphabet (Google)**\n\n當前價格：{price} USD\n漲跌：{change}%"
        
        # 查詢能源價格
        elif '油價' in query or '能源' in query or '原油' in query:
            result = subprocess.run(
                ['node', 'projects/geopolitical_risk/monitor_energy.js'],
                capture_output=True,
                text=True,
                cwd=str(PROJECT_DIR),
                timeout=10
            )
            data = json.loads(result.stdout)
            wti = data['crude_oil']['wti']['price']
            wti_change = data['crude_oil']['wti']['changePercent']
            return f"⛽ **原油價格**\n\nWTI: {wti} USD ({wti_change}%)"
        
        # 查詢風險等級
        elif '風險' in query:
            result = subprocess.run(
                ['node', 'projects/geopolitical_risk/monitor_energy.js'],
                capture_output=True,
                text=True,
                cwd=str(PROJECT_DIR),
                timeout=10
            )
            data = json.loads(result.stdout)
            level = data['risk_level']['level']
            
            emoji = {"GREEN": "🟢", "YELLOW": "🟡", "ORANGE": "🟠", "RED": "🔴"}
            return f"⚠️ **風險等級**\n\n{emoji.get(level, '⚪')} {level}"
        
        # 查詢投資組合
        elif '投資組合' in query or '持倉' in query:
            result = subprocess.run(
                ['node', 'projects/portfolio/fetch_all.js'],
                capture_output=True,
                text=True,
                cwd=str(PROJECT_DIR),
                timeout=10
            )
            data = json.loads(result.stdout)
            holdings = data['holdings']
            
            response = "📊 **投資組合**\n\n"
            for symbol, info in holdings.items():
                price = info['price']
                change = info['changePercent']
                response += f"{symbol}: {price} ({change}%)\n"
            return response
        
        # 幫助訊息
        elif '幫助' in query or 'help' in query:
            return """📖 **可用指令**

📊 股價查詢：
- 006208 / 富邦台 50
- MSFT / 微軟
- GOOGL / 谷歌

⛽ 能源價格：
- 油價 / 原油 / 能源

⚠️ 風險評估：
- 風險等級

📊 投資組合：
- 投資組合 / 持倉

💬 語音輸入即可，我會自動識別！"""
        
        else:
            return """❓ 抱歉，我沒聽清楚

您可以問：
- 006208 股價
- MSFT / GOOGL 股價
- 油價
- 風險等級
- 投資組合

輸入 "幫助" 查看更多指令"""
    
    except subprocess.TimeoutExpired:
        return "⚠️ 查詢超時，請稍後再試"
    except json.JSONDecodeError:
        return "⚠️ 數據解析錯誤，請稍後再試"
    except Exception as e:
        logger.error(f"查詢錯誤：{e}")
        return f"⚠️ 發生錯誤：{str(e)}"

def send_telegram_message(chat_id: str, text: str):
    """發送 Telegram 訊息"""
    logger.info(f"發送訊息到 Telegram: {chat_id}")
    
    # 使用 openclaw message 工具
    try:
        subprocess.run(
            ['openclaw', 'message', 'send', '--target', f'telegram:{chat_id}', '--message', text],
            capture_output=True,
            timeout=30
        )
        logger.info("訊息發送成功")
    except Exception as e:
        logger.error(f"發送失敗：{e}")

def process_voice_message(chat_id: str, voice_file: str):
    """處理語音訊息的完整流程"""
    logger.info(f"處理語音訊息：chat_id={chat_id}, file={voice_file}")
    
    # 步驟 1: 語音轉文字
    logger.info("步驟 1: 語音轉文字")
    text = speech_to_text(voice_file)
    
    if not text:
        send_telegram_message(chat_id, "❌ 抱歉，無法識別語音內容")
        return
    
    logger.info(f"識別結果：{text}")
    
    # 步驟 2: 處理查詢
    logger.info("步驟 2: 處理查詢")
    response = process_query(text)
    
    # 步驟 3: 發送回覆
    logger.info("步驟 3: 發送回覆")
    send_telegram_message(chat_id, response)
    
    # 記錄日誌
    log_file = LOG_DIR / f"voice-{datetime.now().strftime('%Y-%m-%d')}.log"
    with open(log_file, 'a', encoding='utf-8') as f:
        f.write(f"[{datetime.now()}] Chat: {chat_id} | Voice: {text} | Response: {response}\n")
    
    logger.info("處理完成")

def main():
    """主函數 - 監聽 Telegram 語音訊息"""
    print("=" * 50)
    print("🎙️ Jarvis Telegram 語音處理器")
    print("=" * 50)
    print("")
    print("這個腳本會：")
    print("1. 監聽 Telegram 語音訊息")
    print("2. 自動轉成文字")
    print("3. 查詢並回覆")
    print("")
    print("⚠️  需要設定 Telegram Bot")
    print("")
    print("測試模式：輸入語音檔案路徑")
    print("或直接輸入文字測試查詢")
    print("")
    
    while True:
        try:
            user_input = input("語音檔案路徑或文字查詢 (quit 退出): ").strip()
            
            if user_input.lower() == 'quit':
                break
            
            # 檢查是否是檔案路徑
            if os.path.exists(user_input):
                # 處理語音檔案
                process_voice_message("test_user", user_input)
            else:
                # 文字查詢測試
                response = process_query(user_input)
                print(f"\nJarvis: {response}\n")
        
        except KeyboardInterrupt:
            break
        except Exception as e:
            logger.error(f"錯誤：{e}")
            print(f"❌ 錯誤：{e}")

if __name__ == "__main__":
    main()
