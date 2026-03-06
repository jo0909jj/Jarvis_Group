#!/bin/bash
# Voice Query - 語音對話查詢
# 使用 whisper + TTS 實現語音互動

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
AUDIO_DIR="$PROJECT_DIR/audio"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

mkdir -p "$AUDIO_DIR"

echo "🎙️ Jarvis 語音對話系統"
echo "========================"
echo ""

# 錄音 (使用 arecord 或系統默認麥克風)
echo "📍 請說話... (5 秒)"
arecord -d 5 -f cd -r 44100 "$AUDIO_DIR/input_${TIMESTAMP//:/-}.wav" 2>/dev/null || {
    echo "⚠️  找不到 arecord，請安裝：sudo apt install alsa-utils"
    echo "或使用手機錄音後上傳"
    exit 1
}

INPUT_FILE="$AUDIO_DIR/input_${TIMESTAMP//:/-}.wav"
OUTPUT_FILE="$AUDIO_DIR/output_${TIMESTAMP//:/-}.wav"

echo "✅ 錄音完成：$INPUT_FILE"
echo ""

# 語音轉文字 (使用 whisper)
echo "🔄 語音轉文字中..."
if command -v whisper &>/dev/null; then
    TRANSCRIPTION=$(whisper "$INPUT_FILE" --model tiny --language zh --output_format txt 2>/dev/null | tail -1)
else
    # 使用 openai-whisper Python 套件
    TRANSCRIPTION=$(python3 -c "
import whisper
model = whisper.load_model('tiny')
result = model.transcribe('$INPUT_FILE', language='zh')
print(result['text'])
" 2>/dev/null)
fi

echo "📝 識別結果：$TRANSCRIPTION"
echo ""

# 理解意圖並查詢
echo "🤖 處理查詢..."
QUERY="$TRANSCRIPTION"

# 簡單關鍵詞匹配
if [[ "$QUERY" == *"006208"* ]] || [[ "$QUERY" == *"富邦"* ]]; then
    # 查詢 006208
    cd "$PROJECT_DIR/projects/portfolio"
    DATA=$(node fetch_all.js 2>/dev/null)
    PRICE=$(echo "$DATA" | jq -r '.holdings | .["006208.TW"] | .price')
    CHANGE=$(echo "$DATA" | jq -r '.holdings | .["006208.TW"] | .changePercent')
    RESPONSE="先生，目前 006208 價格 $PRICE 元，漲跌 $CHANGE 百分比"
    
elif [[ "$QUERY" == *"能源"* ]] || [[ "$QUERY" == *"油價"* ]]; then
    # 查詢能源價格
    cd "$PROJECT_DIR/projects/geopolitical_risk"
    DATA=$(node monitor_energy.js 2>/dev/null)
    WTI=$(echo "$DATA" | jq -r '.crude_oil.wti.price')
    RESPONSE="目前 WTI 原油價格 $WTI 美元"
    
elif [[ "$QUERY" == *"MSFT"* ]] || [[ "$QUERY" == *"微軟"* ]]; then
    cd "$PROJECT_DIR/projects/portfolio"
    DATA=$(node fetch_all.js 2>/dev/null)
    PRICE=$(echo "$DATA" | jq -r '.holdings.MSFT.price')
    RESPONSE="微軟股價 $PRICE 美元"
    
elif [[ "$QUERY" == *"GOOGL"* ]] || [[ "$QUERY" == *"谷歌"* ]]; then
    cd "$PROJECT_DIR/projects/portfolio"
    DATA=$(node fetch_all.js 2>/dev/null)
    PRICE=$(echo "$DATA" | jq -r '.holdings.GOOGL.price')
    RESPONSE="谷歌股價 $PRICE 美元"
    
elif [[ "$QUERY" == *"風險"* ]]; then
    cd "$PROJECT_DIR/projects/geopolitical_risk"
    DATA=$(node monitor_energy.js 2>/dev/null)
    LEVEL=$(echo "$DATA" | jq -r '.risk_level.level')
    RESPONSE="目前風險等級 $LEVEL，市場穩定"
    
else
    RESPONSE="抱歉，我沒聽清楚。您可以問：006208 股價、油價、風險等級"
fi

echo "💬 回答：$RESPONSE"
echo ""

# 文字轉語音 (使用 sag / ElevenLabs)
echo "🔊 生成語音回答..."
if command -v sag &>/dev/null; then
    sag --text "$RESPONSE" --output "$OUTPUT_FILE" 2>/dev/null || {
        echo "⚠️  sag 不可用，使用備用方案"
        # 使用 sherpa-onnx-tts
        echo "$RESPONSE" | sherpa-onnx-tts --output="$OUTPUT_FILE" 2>/dev/null
    }
else
    # 使用 sherpa-onnx-tts
    echo "$RESPONSE" | sherpa-onnx-tts --output="$OUTPUT_FILE" 2>/dev/null || {
        echo "⚠️  沒有可用的 TTS，使用文字輸出"
        echo "$RESPONSE"
        exit 0
    }
fi

echo "✅ 語音生成完成：$OUTPUT_FILE"
echo ""

# 播放回答
echo "🔊 播放回答..."
if command -v ffplay &>/dev/null; then
    ffplay -nodisp -autoexit "$OUTPUT_FILE" 2>/dev/null
elif command -v aplay &>/dev/null; then
    aplay "$OUTPUT_FILE" 2>/dev/null
else
    echo "⚠️  沒有可用的播放器，請手動播放：$OUTPUT_FILE"
fi

echo ""
echo "========================"
echo "✅ 對話完成！"

# 記錄到日誌
LOG_FILE="$PROJECT_DIR/logs/voice-queries-$(date +%Y-%m-%d).log"
echo "[$TIMESTAMP] 用戶：$QUERY | Jarvis: $RESPONSE" >> "$LOG_FILE"
