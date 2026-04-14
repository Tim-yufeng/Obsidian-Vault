cd /d "D:\Obsidian\Vault"
git add .
git commit -m "Auto-backup %date:~0,10% %time:~0,8%"
git push origin main