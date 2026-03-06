# Telegram 語音轉文字設定指南

**最後更新：** 2026-03-06 15:55

---

## 🎯 功能說明

```
Telegram 語音訊息
    ↓
自動下載語音檔案
    ↓
Whisper 轉文字
    ↓
AI 理解並查詢
    ↓
文字回覆到 Telegram
```

---

## 📦 需要的環境

| 項目 | 用途 | 安裝 |
|------|------|------|
| **Telegram Bot** | 接收語音訊息 | [@BotFather](https://t.me/BotFather) |
| **openai-whisper** | 語音轉文字 | `pip install openai-whisper` |
| **ffmpeg** | 音頻處理 | `sudo apt install ffmpeg` |
| **Python 3.8+** | 運行腳本 | `python3 --version` |

---

## 🚀 快速開始

### 步驟 1: 安裝依賴

```bash
# 安裝 whisper (語音轉文字)
pip install openai-whisper

# 安裝 ffmpeg (音頻處理)
sudo apt install -y ffmpeg

# 驗證安裝
whisper --version
ffmpeg -version
```

### 步驟 2: 建立 Telegram Bot

1. **開啟 [@BotFather](https://t.me/BotFather)**

2. **發送指令：**
   ```
   /newbot
   ```

3. **輸入 Bot 名稱：**
   ```
   Jarvis Group Bot
   ```

4. **輸入 Bot Username：**
   ```
   jarvis_group_bot
   ```

5. **複製 Bot Token：**
   ```
   123456789:ABCdefGHIjklMNOpqrsTUVwxyz
   ```

### 步驟 3: 設定 Bot Token

```bash
# 編輯配置文件
nano ~/.openclaw/openclaw.json

# 找到 telegram 配置，更新 botToken
"channels": {
  "telegram": {
    "botToken": "你的:bot_token"
  }
}
```

### 步驟 4: 測試語音處理

```bash
cd /home/user/.openclaw/workspace/Jarvis_Group

# 測試模式 (文字輸入)
python3 scripts/telegram-voice-processor.py

# 輸入測試查詢：
語音檔案路徑或文字查詢：006208 股價
```

---

## 💡 使用方式

### 方法 1: 測試模式 (文字)

```bash
python3 scripts/telegram-voice-processor.py

# 輸入文字測試：
您：006208 股價
Jarvis: 📊 **006208 富邦台 50**
       當前價格：178.2 TWD
       漲跌：-0.64%
```

### 方法 2: 完整 Telegram 整合

需要設定 Telegram Bot 自動監聽：

```bash
# 建立自動監聽腳本
cat > ~/jarvis_telegram_bot.sh << 'EOF'
#!/bin/bash
cd /home/user/.openclaw/workspace/Jarvis_Group
python3 scripts/telegram-voice-processor.py
EOF

chmod +x ~/jarvis_telegram_bot.sh

# 加入 systemd service (可選)
# 或直接用 screen 運行
screen -S telegram_bot
~/jarvis_telegram_bot.sh
```

---

## 📊 支援的語音指令

| 語音輸入 | 查詢內容 | 回覆格式 |
|----------|----------|----------|
| 「006208 多少錢」 | 富邦台 50 股價 | 📊 價格 + 漲跌 |
| 「微軟股價」 | MSFT 股價 | 💻 價格 + 漲跌 |
| 「谷歌股價」 | GOOGL 股價 | 🔍 價格 + 漲跌 |
| 「油價怎麼樣」 | WTI 原油 | ⛽ 價格 + 漲跌 |
| 「風險等級」 | 地緣政治風險 | ⚠️ 風險等級 |
| 「投資組合」 | 完整持倉 | 📊 所有持股 |
| 「幫助」 | 使用說明 | 📖 指令列表 |

---

## 🔧 故障排除

### Q: whisper 安裝失敗？

**A:** 使用 pip 安裝：
```bash
pip install openai-whisper

# 如果失敗，嘗試：
pip install --upgrade pip
pip install openai-whisper
```

### Q: 語音識別不準確？

**A:** 使用更大的模型：
```python
# 編輯腳本，修改 model 參數
--model tiny     # 最快
--model base     # 平衡
--model small    # 較準確
```

### Q: Telegram Bot 沒有回應？

**A:** 檢查：
1. Bot Token 是否正確
2. Bot 是否已加入對話
3. 查看日誌：`logs/voice-*.log`

### Q: 語音檔案無法下載？

**A:** 檢查權限：
```bash
# 確保 audio 目錄可寫
chmod 755 ~/openclaw/workspace/Jarvis_Group/audio
```

---

## 📝 日誌位置

```bash
# 語音處理日誌
tail -f ~/openclaw/workspace/Jarvis_Group/logs/voice-$(date +%Y-%m-%d).log

# 系統日誌
journalctl -u telegram_bot -f  # 如果使用 systemd
```

---

## 🎯 進階設定

### 1. 自動啟動 (systemd)

```bash
# 建立 service 檔案
sudo nano /etc/systemd/system/jarvis-telegram.service

[Unit]
Description=Jarvis Telegram Voice Bot
After=network.target

[Service]
Type=simple
User=user
WorkingDirectory=/home/user/.openclaw/workspace/Jarvis_Group
ExecStart=/usr/bin/python3 scripts/telegram-voice-processor.py
Restart=always

[Install]
WantedBy=multi-user.target

# 啟用服務
sudo systemctl enable jarvis-telegram
sudo systemctl start jarvis-telegram
sudo systemctl status jarvis-telegram
```

### 2. 語音回覆 (可選)

添加 TTS 功能：

```python
# 在回覆前添加語音生成
import subprocess

def text_to_speech(text: str) -> str:
    """文字轉語音"""
    output_file = f"/tmp/response_{datetime.now().timestamp()}.wav"
    subprocess.run(['sag', '--text', text, '--output', output_file])
    return output_file
```

### 3. 多用戶支援

```python
# 記錄用戶偏好
user_preferences = {}

def get_user_preference(chat_id: str):
    if chat_id not in user_preferences:
        user_preferences[chat_id] = {
            'language': 'zh',
            'model': 'tiny'
        }
    return user_preferences[chat_id]
```

---

## 🔐 安全提醒

- ⚠️ 不要公開 Bot Token
- ⚠️ 限制可訪問的用戶
- ⚠️ 定期清理語音檔案
- ⚠️ 使用 HTTPS 連接

---

## 📞 需要協助？

1. **查看日誌** - `logs/voice-*.log`
2. **測試模式** - `python3 scripts/telegram-voice-processor.py`
3. **查看文檔** - `docs/TELEGRAM_VOICE_SETUP.md`

---

*維護者：JARVIS | 語音處理器已就緒*
