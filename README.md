# LuaPlugins
IOTQQ -- Lua插件
## TimeReport.sh的使用
将该文件放置任意文件夹下，并且授予777权限
然后添加定时任务crontab -e
0 * * * * /xxx/xxx/iotbot_3.0.1_linux_amd64/Plugins/TimeReport.sh >> /xxx/TimeReport.txt
若crontab -e失败，请自行安装cron
