# 部署 SS + V2Ray Plugin

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

---

---

从https://github.com/ygcaicn/ss-heroku 叉出来的
去掉了网页内容 wwwroot.tar.gz 只在网页根目录放了 index.html 和 robots.txt
去掉了二维码生成部分代码
修改默认加密方式为"aes-128-gcm"，默认 path 为/shadow，修改内网端口为 10000
修改 v2ray plugin 的路径为绝对路径
修改 caddy config 的路径为绝对路径
感谢前面的大佬们的贡献

## 1. 验证

服务端部署后，点 open app,能正常显示网页，地址补上 path 后(例如：<https://test.herokuapp.com/static>)访问显示 Bad Request，表示部署成功。

## 2. 客户端配置

手动配置：
以下下信息可以在 app 的 Settings 标签页点击 Reveal Config Vars 查看

```
Server: test.herokuapp.com （test换为你的app名称）
Port: 443
Password: 部署时填写的密码
Encry Method： aes-128-gcm （或者你填写的其它方式）
Plugin: v2ray
Plugin Transport mode: websocket-tls
Hostname: 同Server
Path： 你部署时填写的路径
```

电脑 ss 加 v2ray plugin 设置方法

```
Server Addr: yourapp.herokuapp.com
Server Port: 443
Password:
Encryption: 'aes-128-gcm'
Plugin Program: path to your plugin.exe
Plugin Options: tls;mode=websocket;path=path;host=yourapp.herokuapp.com
```

## 3. 更新

更新 v2ray-plugin 版本，访问 https://dashboard.heroku.com/apps 选择部署好的 app，如果 VER 变量为 latest。直接选择 More --> Restart all dynos, 程序自动重启，可通过 view Logs 确认进度。（更新指定版本： Settings --> Reveal Config Varsapp -->VER，修改成需要的版本号，例如 1.2）

2019/11/01 当前版本使用正常：
shadowsocks-libev：3.3.2+ds-1(debian apt)
v2ray-plugin:v1.2.0

# 参考

https://github.com/xiangrui120/v2ray-heroku-undone

https://hub.docker.com/r/shadowsocks/shadowsocks-libev

https://github.com/shadowsocks/v2ray-plugin

https://github.com/ygcaicn/ss-heroku
