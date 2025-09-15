# frpc

## 关于

一个使用frp客户端让homeassistant暴露到外网的插件

## 项目简介

本项目用于配置和管理 frpc（frp 客户端），帮助用户实现内网穿透功能.

## 主要功能

- 提供简单的 frpc 客户端配置
- 支持内网服务的远程访问
- 便捷的连接管理

## 使用说明
* 下载安装插件
* 到homeassistant的configuration.yaml配置文件中增加以下内容：
```shell
http:
use_x_forwarded_for: true
trusted_proxies:
- 0.0.0.0/0
```
* 添加配置启动即可


## 贡献指南

欢迎提交 Issue 和 Pull Request
