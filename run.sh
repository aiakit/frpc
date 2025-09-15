#!/usr/bin/with-contenv bashio

set -e

# 定义配置文件路径
CONFIG_PATH=/data/frpc.toml
LOG_FILE="/data/frpc.log"
APP_PATH="/usr/src"
WAIT_PIDS=()

function stop_frpc() {
    bashio::log.info "Stop frpc oidc "
    kill -15 "${WAIT_PIDS[@]}"
}

if [ -f "${CONFIG_PATH}" ]; then
    bashio::log.info "Removing old configuration file..."
    rm -f "${CONFIG_PATH}"
fi

# 显示欢迎信息
ALL_CONFIG=$(bashio::config --all)
bashio::log.info "Starting FRP Client...${ALL_CONFIG}"

cat /data/options.json

# 检查 frpc 是否存在
if [ ! -f "${APP_PATH}/frpc" ]; then
    bashio::log.error "FRP Client binary not found at ${APP_PATH}/frpc"
    exit 1
fi

# 确保二进制文件可执行
chmod +x "${APP_PATH}/frpc"

# 从 Home Assistant 配置中获取值
SERVER_ADDR=$(bashio::config 'server_addr')
SERVER_PORT=$(bashio::config 'server_port')
AUTH_TOKEN=$(bashio::config 'auth_token')

# 获取代理配置
PROXY_NAME=$(bashio::config 'name')
CUSTOM_DOMAIN=$(bashio::config 'custom_domains')

bashio::log.info "Creating FRP Client configuration..."
bashio::log.info "Configuration created with following settings:"
bashio::log.info "Server: ${SERVER_ADDR}:${SERVER_PORT}"
bashio::log.info "Proxy Name: ${PROXY_NAME}"
bashio::log.info "Custom Domain: ${CUSTOM_DOMAIN}"

# 创建 TOML 配置文件
cat > "${CONFIG_PATH}" << EOL
serverAddr = "${SERVER_ADDR}"
serverPort = ${SERVER_PORT}

auth.method = "token"
auth.token = "${AUTH_TOKEN}"

[[proxies]]
name = "${PROXY_NAME}"
type = "http"
localIP = "127.0.0.1"
localPort = 8123
customDomains = ["${CUSTOM_DOMAIN}"]
EOL

cat $CONFIG_PATH

# 检查配置文件是否存在
if [ ! -f "${CONFIG_PATH}" ]; then
    bashio::log.error "Configuration file not found at ${CONFIG_PATH}"
    exit 1
fi

# 启动 frpc
bashio::log.info "Starting FRP Client with configuration at ${CONFIG_PATH}"
cd /usr/src
./frpc -c $CONFIG_PATH > "${LOG_FILE}" 2>&1 & WAIT_PIDS+=($!) & tail -f ${LOG_FILE}

trap "stop_frpc" SIGTERM SIGHUP

wait "${WAIT_PIDS[@]}"
