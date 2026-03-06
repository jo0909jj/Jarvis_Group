# Jarvis Group 遷移指南

**最後更新：** 2026-03-06 14:33

---

## 🎯 目標

將 Jarvis Group 完整配置遷移到另一台電腦

---

## 📦 遷移內容

### 1. GitHub 倉庫 (已同步)

**倉庫：** https://github.com/jo0909jj/Jarvis_Group

**包含：**
- ✅ 所有腳本和配置
- ✅ 會議紀錄
- ✅ 專案文件
- ✅ Agent 設定
- ✅ 投資組合配置

### 2. OpenClaw 配置

**路徑：** `~/.openclaw/`

**包含：**
- `openclaw.json` - 主配置 (含 Telegram Token、模型配置)
- `workspace/` - 工作區

### 3. 環境變數

**GITHUB_TOKEN** - GitHub API 訪問權限

---

## 🚀 遷移步驟

### 步驟 1: 在新電腦安裝 OpenClaw

```bash
# 安裝 OpenClaw
npm install -g openclaw

# 驗證安裝
openclaw --version
```

### 步驟 2: 克隆 Jarvis Group 倉庫

```bash
# 创建工作目錄
mkdir -p ~/.openclaw/workspace
cd ~/.openclaw/workspace

# 克隆倉庫
git clone https://github.com/jo0909jj/Jarvis_Group.git
cd Jarvis_Group
```

### 步驟 3: 複製配置文件

**在舊電腦執行：**

```bash
# 備份配置
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup
cp -r ~/.openclaw/workspace ~/.openclaw/workspace.backup

# 導出配置 (可選)
cat ~/.openclaw/openclaw.json | jq '.channels.telegram.botToken' > telegram_token.txt
cat ~/.openclaw/openclaw.json | jq '.models.providers' > models_config.json
```

**傳輸到新電腦：**

```bash
# 方法 1: 使用 scp
scp ~/.openclaw/openclaw.json user@new-computer:~/.openclaw/

# 方法 2: 手動複製
# 將 openclaw.json 內容複製到新電腦的 ~/.openclaw/openclaw.json
```

### 步驟 4: 設定環境變數

**在新電腦執行：**

```bash
# 設定 GITHUB_TOKEN (替換為您的 token)
echo 'export GITHUB_TOKEN="ghp_您的token"' >> ~/.bashrc

# 設定 Telegram Bot Token (如果需要)
echo 'export TELEGRAM_BOT_TOKEN="您的:telegram_token"' >> ~/.bashrc

# 重新載入
source ~/.bashrc

# 驗證
echo $GITHUB_TOKEN
echo $TELEGRAM_BOT_TOKEN
```

### 步驟 5: 安裝依賴

```bash
cd ~/.openclaw/workspace/Jarvis_Group

# 安裝 Node.js 依賴 (如果有 package.json)
npm install

# 安裝系統依賴
sudo apt update
sudo apt install -y jq curl git nodejs npm

# 安裝可選工具
sudo apt install -y flameshot xclip libnotify-bin
```

### 步驟 6: 設定 Cron 定時任務

```bash
# 匯出舊電腦的 Cron
crontab -l > cron_backup.txt

# 在新電腦導入
crontab cron_backup.txt

# 或手動設定
crontab -e

# 添加：
*/10 9-13 * * 1-5 /home/user/.openclaw/workspace/Jarvis_Group/scripts/auto-telegram-report.sh >> /home/user/.openclaw/workspace/Jarvis_Group/logs/telegram-cron.log 2>&1
```

### 步驟 7: 測試驗證

```bash
# 測試腳本執行
cd ~/.openclaw/workspace/Jarvis_Group
./scripts/auto-telegram-report.sh

# 測試 GitHub Token
gh auth status

# 測試 Telegram 推送
openclaw message send --target "telegram:5826922658" --message "測試訊息 - 新電腦"

# 檢查 Cron 狀態
crontab -l
```

---

## 📋 快速遷移腳本

### 在舊電腦執行

```bash
#!/bin/bash
# export_jarvis_config.sh

echo "📦 導出 Jarvis Group 配置..."

# 建立導出目錄
mkdir -p ~/jarvis_export

# 導出配置
cp ~/.openclaw/openclaw.json ~/jarvis_export/
crontab -l > ~/jarvis_export/crontab.txt
grep -E "GITHUB_TOKEN|TELEGRAM_BOT_TOKEN" ~/.bashrc > ~/jarvis_export/env_vars.sh

# 壓縮
cd ~
tar -czf jarvis_export_$(date +%Y%m%d).tar.gz jarvis_export/

echo "✅ 導出完成：~/jarvis_export_$(date +%Y%m%d).tar.gz"
echo ""
echo "請將此檔案傳輸到新電腦並執行 import_jarvis_config.sh"
```

### 在新電腦執行

```bash
#!/bin/bash
# import_jarvis_config.sh

echo "📥 導入 Jarvis Group 配置..."

# 解壓縮
tar -xzf ~/jarvis_export_*.tar.gz -C ~

# 複製配置
cp ~/jarvis_export/openclaw.json ~/.openclaw/
cat ~/jarvis_export/env_vars.sh >> ~/.bashrc
source ~/.bashrc

# 導入 Cron
crontab ~/jarvis_export/crontab.txt

# 克隆倉庫
cd ~/.openclaw/workspace
git clone https://github.com/jo0909jj/Jarvis_Group.git

echo "✅ 導入完成！"
echo ""
echo "請執行以下命令驗證："
echo "  cd ~/.openclaw/workspace/Jarvis_Group"
echo "  ./scripts/auto-telegram-report.sh"
```

---

## 🔐 安全注意事項

### 敏感資訊

| 項目 | 位置 | 建議 |
|------|------|------|
| **Telegram Bot Token** | `openclaw.json` | ✅ 可複製 |
| **GitHub Token** | `~/.bashrc` | ✅ 可複製 |
| **API Keys** | `openclaw.json` | ✅ 可複製 |
| **SSH Keys** | `~/.ssh/` | ⚠️ 建議重新生成 |

### 建議操作

1. **GitHub Token** - 可以複製，或為新電腦生成新的
2. **Telegram Bot** - 可以直接使用同一個
3. **SSH Keys** - 建議為新電腦生成新的 SSH Key

---

## 📊 遷移檢查清單

### 舊電腦

- [ ] 備份 `~/.openclaw/openclaw.json`
- [ ] 導出 Cron 配置
- [ ] 記錄環境變數
- [ ] 確認 GitHub 已推送最新代碼

### 新電腦

- [ ] 安裝 OpenClaw
- [ ] 克隆 Jarvis_Group 倉庫
- [ ] 複製配置文件
- [ ] 設定環境變數
- [ ] 安裝依賴
- [ ] 設定 Cron
- [ ] 測試腳本執行
- [ ] 測試 Telegram 推送
- [ ] 測試 GitHub 整合

---

## 🛠️ 常見問題

### Q: Telegram 推送失敗？

**A:** 檢查 Token 是否正確複製：
```bash
grep botToken ~/.openclaw/openclaw.json
```

### Q: GitHub Token 無效？

**A:** 重新設定：
```bash
export GITHUB_TOKEN="ghp_您的 token"
gh auth status
```

### Q: Cron 沒有執行？

**A:** 檢查 Cron 服務：
```bash
systemctl status cron
crontab -l
```

### Q: 腳本權限問題？

**A:** 設定執行權限：
```bash
chmod +x scripts/*.sh
```

---

## 📞 需要協助？

如果遇到問題，請檢查：

1. **日誌檔案** - `~/.openclaw/workspace/Jarvis_Group/logs/`
2. **Cron 日誌** - `tail -f /var/log/syslog | grep cron`
3. **OpenClaw 狀態** - `openclaw status`

---

*維護者：JARVIS | 遷移完成後請刪除備份檔案*
