## 使用说明
1. 安装配置
- 下载配置即用

2. 基本使用
- 根据frp提供的配置文件说明，配置即可使用。参考地址：https://gofrp.org/zh-cn/docs/features/common/authentication/

3. frpc配置文件说明  
---
    serverAddr = "远程服务器ip"
    serverPort = 7000

    auth.token = "token"

    [[proxies]]
    name = "clientID"
    customDomains = ["xxx.host.com"]
