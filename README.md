# XunLei

使用迅雷极速版下载的时候突然提示任务出错，可以通过修改hosts文件的方法绕过迅雷的解析服务器，继续使用极速版。

1、首先找到文件 C:\Windows\System32\drivers\etc\hosts，以记事本方式打开，复制以下代码直接粘贴进去，保存退出：
```
# ThunderSpeed DNS Verification Cheat 
127.0.0.1 hub5btmain.sandai.net
127.0.0.1 hub5emu.sandai.net
127.0.0.1 upgrade.xl9.xunlei.com
```
2、退出迅雷极速版并清掉后台残余进程。

3、最后使用快捷键win+R并输入cmd，然后回车，在命令行中执行ipconfig /flushdns刷新DNS解析缓存，提示成功后，再重新打开迅雷，发现问题解决了！
