#!/usr/bin/env python3
"""
簡單測試版本 - Telegram 語音轉文字查詢
"""

import subprocess
import json
import sys

def query_stock(symbol: str) -> str:
    """查詢股價"""
    try:
        result = subprocess.run(
            ['node', 'projects/portfolio/fetch_all.js'],
            capture_output=True,
            text=True,
            cwd='/home/user/.openclaw/workspace/Jarvis_Group',
            timeout=10
        )
        
        # 過濾 notice 訊息
        lines = result.stdout.split('\n')
        json_lines = [l for l in lines if l.strip().startswith('{') or l.strip().startswith('}')]
        json_str = '\n'.join(json_lines)
        
        data = json.loads(json_str)
        
        if symbol == '006208':
            info = data['holdings']['006208.TW']
            return f"📊 **006208 富邦台 50**\n\n當前價格：{info['price']} TWD\n漲跌：{info['changePercent']}%"
        elif symbol == 'MSFT':
            info = data['holdings']['MSFT']
            return f"💻 **Microsoft**\n\n當前價格：{info['price']} USD\n漲跌：{info['changePercent']}%"
        elif symbol == 'GOOGL':
            info = data['holdings']['GOOGL']
            return f"🔍 **Alphabet**\n\n當前價格：{info['price']} USD\n漲跌：{info['changePercent']}%"
    
    except Exception as e:
        return f"❌ 查詢失敗：{e}"
    
    return "❓ 未知股票代號"

def main():
    """主函數"""
    print("=" * 50)
    print("🎙️ 語音查詢測試 (文字模式)")
    print("=" * 50)
    print("")
    print("輸入查詢關鍵字：")
    print("  - 006208 / 富邦")
    print("  - MSFT / 微軟")
    print("  - GOOGL / 谷歌")
    print("  - quit 退出")
    print("")
    
    while True:
        try:
            query = input("您：").strip()
            
            if query.lower() == 'quit':
                break
            
            # 簡單關鍵詞匹配
            if '006208' in query or '富邦' in query:
                print(f"Jarvis: {query_stock('006208')}\n")
            elif 'msft' in query.lower() or '微軟' in query:
                print(f"Jarvis: {query_stock('MSFT')}\n")
            elif 'googl' in query.lower() or '谷歌' in query:
                print(f"Jarvis: {query_stock('GOOGL')}\n")
            else:
                print("Jarvis: ❓ 抱歉，我沒聽清楚。可以問 006208、MSFT、GOOGL\n")
        
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(f"❌ 錯誤：{e}")

if __name__ == "__main__":
    main()
