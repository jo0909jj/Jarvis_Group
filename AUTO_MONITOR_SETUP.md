# Auto Monitor Setup - 自動監控系統設定

**最後更新：** 2026-03-06 10:40

---

## 🎯 目標

每 10 分鐘自動查詢並記錄：
- 投資組合價格 (006208、MSFT、GOOGL)
- 能源價格 (WTI 原油、Brent 原油、天然氣)
- 風險等級評估

---

## ⏰ 執行時間

| 設定 | 說明 |
|------|------|
| **頻率** | 每 10 分鐘 |
| **時段** | 週一至週五 09:00-13:30 (台股交易時間) |
| **時區** | Asia/Taipei (UTC+8) |

---

## 📁 檔案位置

| 檔案 | 路徑 | 說明 |
|------|------|------|
| **監控腳本** | `scripts/auto-monitor.sh` | 主監控腳本 |
| **Cron 設定** | `scripts/setup-cron.sh` | Cron 安裝腳本 |
| **日誌目錄** | `logs/` | 監控日誌 |
| **Cron 日誌** | `logs/cron.log` | Cron 執行日誌 |

---

## 🔧 安裝方式

### 已安裝 (2026-03-06 10:40)

```bash
./scripts/setup-cron.sh
```

**Cron 設定：**
```
*/10 9-13 * * 1-5 /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-monitor.sh >> /home/user/.openclaw/workspace/Jarvis_Group/logs/cron.log 2>&1
```

---

## 📊 監控內容

### 每次執行記錄

1. **投資組合價格**
   - 006208.TW (富邦台 50)
   - MSFT (Microsoft)
   - GOOGL (Alphabet Inc A)
   - USD/TWD 匯率

2. **能源價格**
   - WTI 原油 (CL=F)
   - Brent 原油 (BZ=F)
   - 天然氣 (NG=F)
   - 風險等級 (GREEN/YELLOW/ORANGE/RED)

3. **006208 詳細資訊**
   - 當前價格
   - 漲跌幅
   - 成交量

---

## 📝 日誌格式

```
==========================================
[2026-03-06 10:40:14] Auto Monitor Run
==========================================

📊 Portfolio:
  006208.TW: 178.00 TWD (-0.75272155%)
  MSFT: 410.68 USD (1.35241%)
  GOOGL: 300.88 USD (-0.742256%)

⛽ Energy:
  WTI: 79.33 USD (-2.0738184%)
  NG: 2.99 USD (-0.43290082%)
  Risk Level: GREEN (Score: 0)

💰 006208:
  Price: 178.00 TWD (-0.75272155%)

```

---

## 🔍 查看日誌

### 即時查看
```bash
tail -f /home/user/.openclaw/workspace/Jarvis_Group/logs/cron.log
```

### 查看今日日誌
```bash
cat /home/user/.openclaw/workspace/Jarvis_Group/logs/monitor-$(date +%Y-%m-%d).log
```

### 查看所有日誌
```bash
ls -la /home/user/.openclaw/workspace/Jarvis_Group/logs/
```

---

## ⚙️ 管理 Cron

### 查看當前設定
```bash
crontab -l
```

### 編輯 Cron
```bash
crontab -e
```

### 移除 Cron
```bash
crontab -r
```

### 暫停 Cron (註解)
```bash
crontab -e
# 在行首添加 # 註解
# */10 9-13 * * 1-5 /path/to/auto-monitor.sh
```

### 重新啟動 Cron
```bash
./scripts/setup-cron.sh
```

---

## ⚠️ 風險警告

當風險等級達到 **ORANGE** 或 **RED** 時，系統會記錄警告訊息。

未來可整合：
- [ ] Telegram 即時通知
- [ ] Email 警告
- [ ] Line 通知

---

## 📊 數據用途

收集的數據用於：

1. **006208 建倉計劃**
   - 追蹤是否達到買入條件
   - 記錄每次價格波動

2. **地緣政治風險評估**
   - 能源價格趨勢分析
   - 風險等級變化追蹤

3. **投資組合績效**
   - 即時損益計算
   - 資產配置分析

4. **會議紀錄**
   - 重要價格變動記錄
   - 決策依據追溯

---

## 🚨 異常處理

### 腳本執行失敗

檢查日誌：
```bash
tail -50 /home/user/.openclaw/workspace/Jarvis_Group/logs/cron.log
```

常見問題：
- Node.js 未安裝 → `node --version`
- 網路問題 → 檢查連線
- API 限制 → 等待重置

### 手動執行測試

```bash
./scripts/auto-monitor.sh
```

---

## 📈 未來擴展

- [ ] 整合 Telegram 通知
- [ ] 建立儀表板 (Dashboard)
- [ ] 數據可視化 (圖表)
- [ ] 異常偵測 (AI)
- [ ] 自動交易建議

---

*維護者：JARVIS | 下次檢視：2026-03-13*
