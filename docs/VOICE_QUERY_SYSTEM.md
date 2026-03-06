# Voice Query System - 語音對話查詢系統

**最後更新：** 2026-03-06 15:51

---

## 🎯 功能說明

```
用戶說：「006208 現在多少錢？」
    ↓
語音轉文字 (whisper)
    ↓
AI 理解並查詢
    ↓
文字轉語音 (TTS)
    ↓
語音回答：「先生，目前 006208 價格 178.2 元，跌幅 0.64%」
```

---

## 📦 需要的技能

| 技能 | 用途 | 安裝 |
|------|------|------|
| **openai-whisper** | 語音轉文字 | `pip install openai-whisper` |
| **sag** (ElevenLabs) | 高品質 TTS | `npm install -g sag` |
| **sherpa-onnx-tts** | 本地 TTS (備用) | `pip install sherpa-onnx` |
| **voice-call** | 語音通話整合 | OpenClaw 內建 |
| **ffmpeg** | 音頻處理 | `sudo apt install ffmpeg` |

---

## 🚀 安裝步驟

### 步驟 1: 安裝依賴

```bash
# 安裝 whisper
pip install openai-whisper

# 安裝 ElevenLabs TTS (sag)
npm install -g sag

# 安裝音頻工具
sudo apt install -y ffmpeg alsa-utils
```

### 步驟 2: 設定 API Key (如果使用 ElevenLabs)

```bash
# 獲取 API Key: https://elevenlabs.io
export ELEVENLABS_API_KEY="your_api_key"
echo 'export ELEVENLABS_API_KEY="your_api_key"' >> ~/.bashrc
```

### 步驟 3: 測試錄音

```bash
# 測試麥克風
arecord -d 3 -f cd -r 44100 test.wav
aplay test.wav
```

---

## 💡 使用方式

### 方法 1: 本地語音查詢 (完整功能)

```bash
cd /home/user/.openclaw/workspace/Jarvis_Group
./scripts/voice-query.sh
```

**流程：**
1. 對著麥克風說話 (5 秒)
2. 自動轉成文字
3. 自動查詢並生成語音回答
4. 播放回答

**支援查詢：**
- 「006208 現在多少錢？」
- 「微軟股價」
- 「谷歌股價」
- 「油價怎麼樣？」
- 「風險等級」

---

### 方法 2: Telegram 語音機器人 (推薦)

```bash
cd /home/user/.openclaw/workspace/Jarvis_Group
./scripts/telegram-voice-bot.sh
```

**流程：**
1. 在 Telegram 發送語音訊息給 Bot
2. Bot 自動轉成文字
3. 查詢並文字回覆
4. (可選) 發送語音回覆

**優點：**
- ✅ 不需要本地麥克風
- ✅ 可以遠程使用
- ✅ 有文字記錄

---

### 方法 3: 文字輸入測試 (快速測試)

```bash
# 直接運行查詢腳本
cd /home/user/.openclaw/workspace/Jarvis_Group

# 測試 006208 查詢
node projects/portfolio/fetch_all.js | jq '.holdings["006208.TW"]'

# 測試能源查詢
node projects/geopolitical_risk/monitor_energy.js | jq '.crude_oil.wti'
```

---

## 🔧 自定義查詢

編輯 `scripts/voice-query.sh`，添加新的查詢關鍵詞：

```bash
# 在文件中找到這個部分
if [[ "$QUERY" == *"006208"* ]] || [[ "$QUERY" == *"富邦"* ]]; then
    # 添加你的查詢邏輯
    ...
fi
```

**範例：添加台股大盤查詢**

```bash
elif [[ "$QUERY" == *"大盤"* ]] || [[ "$QUERY" == *"加權"* ]]; then
    # 查詢台股大盤
    RESPONSE="台股加權指數 XXXX 點，漲跌 X.XX%"
fi
```

---

## 📊 查詢指令對照表

| 語音輸入 | 查詢內容 | 回答範例 |
|----------|----------|----------|
| 「006208 多少錢」 | 富邦台 50 股價 | 「目前 006208 價格 178.2 元」 |
| 「微軟股價」 | MSFT 股價 | 「微軟股價 410.68 美元」 |
| 「谷歌股價」 | GOOGL 股價 | 「谷歌股價 300.88 美元」 |
| 「油價怎麼樣」 | WTI 原油 | 「WTI 原油 80.55 美元」 |
| 「風險等級」 | 地緣政治風險 | 「風險等級 GREEN，市場穩定」 |
| 「投資組合」 | 完整持倉 | 「006208...MSFT...GOOGL...」 |

---

## 🛠️ 故障排除

### Q: 錄音失敗？

**A:** 檢查麥克風：
```bash
# 列出錄音設備
arecord -l

# 測試錄音
arecord -d 3 test.wav
```

### Q: whisper 識別不準確？

**A:** 使用更大的模型：
```bash
# 在腳本中修改 --model 參數
--model tiny     # 最快，準確度一般
--model base     # 平衡
--model small    # 較準確
--model medium   # 很準確
--model large    # 最準確，最慢
```

### Q: TTS 聲音不自然？

**A:** 使用 ElevenLabs (sag)：
```bash
# 設定 API Key
export ELEVENLABS_API_KEY="your_key"

# 選擇聲音
sag --text "Hello" --voice "Rachel" --output output.wav
```

### Q: 沒有聲音輸出？

**A:** 檢查播放器：
```bash
# 安裝播放器
sudo apt install -y ffmpeg alsa-utils

# 測試播放
aplay test.wav
```

---

## 🎯 進階功能

### 1. 連續對話模式

```bash
# 修改腳本，支持多輪對話
while true; do
    # 錄音 → 識別 → 查詢 → 回答
    # 直到用戶說「再見」
done
```

### 2. 語音控制建倉

```bash
# 添加語音指令
if [[ "$QUERY" == *"買入"* ]] || [[ "$QUERY" == *"建倉"* ]]; then
    # 確認指令
    RESPONSE="確認買入 006208 嗎？請說確認或取消"
    # 等待確認...
fi
```

### 3. 多語言支援

```bash
# whisper 支持多語言
whisper audio.wav --language en  # 英語
whisper audio.wav --language zh  # 中文
whisper audio.wav --language ja  # 日語
```

---

## 📈 效能優化

| 優化項目 | 方法 | 效果 |
|----------|------|------|
| **識別速度** | 使用 tiny 模型 | 快 5 倍 |
| **TTS 品質** | 使用 ElevenLabs | 更自然 |
| **響應時間** | 預熱模型 | 減少延遲 |
| **準確度** | 使用 base 模型 | 提升 20% |

---

## 🔐 安全提醒

- ⚠️ 不要在語音中說出敏感資訊
- ⚠️ 錄音檔案定期清理
- ⚠️ API Key 妥善保存

---

## 📞 需要協助？

如果遇到問題：

1. **檢查日誌** - `logs/voice-queries-*.log`
2. **測試依賴** - `which whisper`, `which sag`
3. **查看文檔** - `docs/VOICE_QUERY_SYSTEM.md`

---

*維護者：JARVIS | 語音系統已就緒*
