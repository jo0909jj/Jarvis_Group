#!/usr/bin/env python3
"""
Telegram Auto Voice Bot - 全自動語音機器人
監聽語音訊息 → 自動下載 → Whisper 轉文字 → 查詢 → 回覆
"""

import os
import sys
import json
import subprocess
import tempfile
import logging
from pathlib import Path
from datetime import datetime

# 嘗試導入 python-telegram-bot
try:
    from telegram import Update
    from telegram.ext import (
        Application,
        CommandHandler,
        MessageHandler,
        filters,
        ContextTypes,
    )
    HAS_TELEGRAM = True
except ImportError:
    HAS_TELEGRAM = False
    print("⚠️  python-telegram-bot 未安裝")
    print("請執行：pip install python-telegram-bot")

# 日誌設定
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
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

# 從配置文件讀取 Token
def get_bot_token():
    """從 openclaw.json 讀取 Telegram Bot Token"""
    config_file = Path.home() / ".openclaw" / "openclaw.json"
    if config_file.exists():
        with open(config_file, 'r', encoding='utf-8') as f:
            config = json.load(f)
            return config.get('channels', {}).get('telegram', {}).get('botToken', '')
    return ''

BOT_TOKEN = get_bot_token()

def speech_to_text(audio_file: str) -> str:
    """語音轉文字 (使用 whisper)"""
    logger.info(f"語音轉文字：{audio_file}")
    
    try:
        # 使用 whisper 命令行
        result = subprocess.run(
            ['whisper', audio_file, '--model', 'tiny', '--language', 'zh', '--output_format', 'txt'],
            capture_output=True,
            text=True,
            cwd=str(PROJECT_DIR),
            timeout=60
        )
        
        if result.returncode == 0:
            # 讀取轉寫結果
            txt_file = audio_file.rsplit('.', 1)[0] + '.txt'
            if os.path.exists(txt_file):
                with open(txt_file, 'r', encoding='utf-8') as f:
                    text = f.read().strip()
                return text
            return result.stdout.strip()
        else:
            logger.error(f"whisper 錯誤：{result.stderr}")
            return ""
    
    except subprocess.TimeoutExpired:
        logger.error("whisper 超時")
        return ""
    except FileNotFoundError:
        logger.error("whisper 未安裝")
        return ""
    except Exception as e:
        logger.error(f"語音轉文字錯誤：{e}")
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
            # 過濾 notice 訊息
            lines = result.stdout.split('\n')
            json_lines = [l for l in lines if l.strip().startswith('{') or l.strip().startswith('}')]
            json_str = '\n'.join(json_lines)
            data = json.loads(json_str)
            
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
            lines = result.stdout.split('\n')
            json_lines = [l for l in lines if l.strip().startswith('{') or l.strip().startswith('}')]
            json_str = '\n'.join(json_lines)
            data = json.loads(json_str)
            
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
            lines = result.stdout.split('\n')
            json_lines = [l for l in lines if l.strip().startswith('{') or l.strip().startswith('}')]
            json_str = '\n'.join(json_lines)
            data = json.loads(json_str)
            
            price = data['holdings']['GOOGL']['price']
            change = data['holdings']['GOOGL']['changePercent']
            return f"🔍 **Alphabet (Google)**\n\n當前價格：{price} USD\n漲跌：{change}%"
        
        # 查詢能源價格
        elif '油價' in query or '能源' in query or '原油' in query or 'wti' in query:
            result = subprocess.run(
                ['node', 'projects/geopolitical_risk/monitor_energy.js'],
                capture_output=True,
                text=True,
                cwd=str(PROJECT_DIR),
                timeout=10
            )
            lines = result.stdout.split('\n')
            json_lines = [l for l in lines if l.strip().startswith('{') or l.strip().startswith('}')]
            json_str = '\n'.join(json_lines)
            data = json.loads(json_str)
            
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
            lines = result.stdout.split('\n')
            json_lines = [l for l in lines if l.strip().startswith('{') or l.strip().startswith('}')]
            json_str = '\n'.join(json_lines)
            data = json.loads(json_str)
            
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
            lines = result.stdout.split('\n')
            json_lines = [l for l in lines if l.strip().startswith('{') or l.strip().startswith('}')]
            json_str = '\n'.join(json_lines)
            data = json.loads(json_str)
            
            holdings = data['holdings']
            response = "📊 **投資組合**\n\n"
            for symbol, info in holdings.items():
                price = info['price']
                change = info['changePercent']
                response += f"{symbol}: {price} ({change}%)\n"
            return response
        
        # 幫助訊息
        elif '幫助' in query or 'help' in query or 'start' in query:
            return """📖 **可用指令**

📊 股價查詢：
- 006208 / 富邦台 50
- MSFT / 微軟
- GOOGL / 谷歌

⛽ 能源價格：
- 油價 / 原油 / 能源 / WTI

⚠️ 風險評估：
- 風險等級

📊 投資組合：
- 投資組合 / 持倉

💬 **語音輸入即可，我會自動識別並回覆！**"""
        
        else:
            return """❓ 抱歉，我沒聽清楚

您可以問：
- 006208 股價
- MSFT / GOOGL 股價
- 油價
- 風險等級
- 投資組合

輸入 "/help" 查看更多指令"""
    
    except subprocess.TimeoutExpired:
        return "⚠️ 查詢超時，請稍後再試"
    except json.JSONDecodeError:
        return "⚠️ 數據解析錯誤，請稍後再試"
    except Exception as e:
        logger.error(f"查詢錯誤：{e}")
        return f"⚠️ 發生錯誤：{str(e)}"

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """處理 /start 命令"""
    await update.message.reply_text(
        "🎙️ **Jarvis 語音機器人已就緒！**\n\n"
        "您可以：\n"
        "1. 🎤 發送語音訊息查詢股價\n"
        "2. 💬 發送文字訊息查詢\n"
        "3. 📖 輸入 /help 查看指令\n\n"
        "支援查詢：\n"
        "- 006208 / MSFT / GOOGL 股價\n"
        "- 油價 / 能源價格\n"
        "- 風險等級\n"
        "- 投資組合\n\n"
        "*請開始說話或輸入查詢* 👇",
        parse_mode='Markdown'
    )

async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """處理 /help 命令"""
    await update.message.reply_text(
        process_query("幫助"),
        parse_mode='Markdown'
    )

async def handle_voice(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """處理語音訊息"""
    voice = update.message.voice
    file_id = voice.file_id
    
    logger.info(f"收到語音訊息：{file_id}")
    
    # 發送「處理中」訊息
    status_msg = await update.message.reply_text("🎙️ 正在識別語音...")
    
    try:
        # 下載語音檔案
        file = await context.bot.get_file(file_id)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        audio_file = AUDIO_DIR / f"voice_{timestamp}.ogg"
        
        await file.download_to_drive(str(audio_file))
        logger.info(f"語音檔案已下載：{audio_file}")
        
        # 語音轉文字
        await status_msg.edit_text("📝 正在轉寫文字...")
        text = speech_to_text(str(audio_file))
        
        if not text:
            await status_msg.edit_text("❌ 抱歉，無法識別語音內容")
            return
        
        logger.info(f"識別結果：{text}")
        
        # 處理查詢
        await status_msg.edit_text("🤖 正在查詢...")
        response = process_query(text)
        
        # 回覆結果
        await status_msg.edit_text(response, parse_mode='Markdown')
        
        # 記錄日誌
        log_file = LOG_DIR / f"voice-{datetime.now().strftime('%Y-%m-%d')}.log"
        with open(log_file, 'a', encoding='utf-8') as f:
            f.write(f"[{datetime.now()}] Voice: {text} | Response: {response}\n")
        
        logger.info("處理完成")
    
    except Exception as e:
        logger.error(f"處理語音錯誤：{e}")
        await status_msg.edit_text(f"❌ 處理失敗：{str(e)}")

async def handle_text(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """處理文字訊息"""
    text = update.message.text
    logger.info(f"收到文字訊息：{text}")
    
    # 處理查詢
    response = process_query(text)
    await update.message.reply_text(response, parse_mode='Markdown')

async def error_handler(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """錯誤處理"""
    logger.error(f"更新 {update} 導致錯誤：{context.error}")

def main():
    """主函數"""
    if not HAS_TELEGRAM:
        print("❌ python-telegram-bot 未安裝")
        print("請執行：pip install python-telegram-bot")
        sys.exit(1)
    
    if not BOT_TOKEN:
        print("❌ 找不到 Telegram Bot Token")
        print("請在 ~/.openclaw/openclaw.json 中設定 botToken")
        sys.exit(1)
    
    print("=" * 60)
    print("🎙️ Jarvis Telegram 全自動語音機器人")
    print("=" * 60)
    print("")
    print("✅ 已啟動監聽")
    print("📱 Bot Token: " + BOT_TOKEN[:20] + "...")
    print("")
    print("功能：")
    print("  - 自動接收語音訊息")
    print("  - 自動轉成文字")
    print("  - 自動查詢並回覆")
    print("")
    print("按 Ctrl+C 退出")
    print("")
    
    # 建立應用程式
    application = Application.builder().token(BOT_TOKEN).build()
    
    # 添加處理器
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("help", help_command))
    application.add_handler(MessageHandler(filters.VOICE, handle_voice))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_text))
    
    # 錯誤處理
    application.add_error_handler(error_handler)
    
    # 啟動輪詢
    application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == "__main__":
    main()
