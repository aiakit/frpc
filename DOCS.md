## 使用说明
1. 安装配置
- 你需要选择三方云端的token认证服务，或者自己开发一个token服务。推荐使用 https://github.com/liangrunze/OidcAuthServer

2. 基本使用
- 根据frp提供的配置文件说明，配置即可使用。参考地址：https://gofrp.org/zh-cn/docs/features/common/authentication/

3. frpc配置文件说明  
---
    serverAddr = "远程服务器ip"
    serverPort = 7000

    auth.method = "oidc"
    auth.oidc.clientID = "用户client_id"
    auth.oidc.clientSecret = "用户client_secret"
    auth.oidc.audience = ""
    auth.oidc.scope = "rw"
    auth.oidc.tokenEndpointURL = ""

    [[proxies]]
    name = "clientID"
    type = "http"
    localPort = 8123
    customDomains = ["xxx.host.com"]
