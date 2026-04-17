@REM cd /d "D:\Obsidian\Vault"
@REM git add .
@REM git commit -m "Auto-backup %date:~0,10% %time:~0,8%"
@REM git push origin main

@echo off
:: 进入仓库目录（极其重要）
cd /d "D:\Obsidian\Vault"

:: 记录运行时间
echo %date% %time% 开始推送 >> sync_log.txt

:: 执行 Git 指令并记录输出与错误
git add . >> sync_log.txt 2>&1
git commit -m "Auto sync %date% %time%" >> sync_log.txt 2>&1
git push origin main >> sync_log.txt 2>&1

echo 完成推送 >> sync_log.txt