ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG FRPC_VERSION

ENV APP_PATH="/usr/src"

# 先检查本地是否有frpc.tar.gz，存在则使用本地文件，否则从远程下载
RUN \
    if [ -f /frpc.tar.gz ]; then \
        echo "Using local frpc.tar.gz"; \
        mkdir -p /tmp/frpc && \
        tar xzf /frpc.tar.gz -C /tmp/frpc && \
        # 查找解压后的frpc可执行文件（处理可能的目录层级）
        find /tmp/frpc -name "frpc" -exec cp {} ${APP_PATH}/ \; && \
        rm -rf /tmp/frpc /frpc.tar.gz; \
    else \
        echo "No local frpc.tar.gz found, downloading from remote"; \
        case "$BUILD_ARCH" in \
            "aarch64") MACHINE="arm64" ;; \
            "amd64")   MACHINE="amd64" ;; \
            "armhf")   MACHINE="arm" ;; \
            "armv7")   MACHINE="arm" ;; \
            "i386")    MACHINE="386" ;; \
            *) echo "Unsupported architecture: $BUILD_ARCH" && exit 1 ;; \
        esac && \
        echo "Architecture: $BUILD_ARCH, Machine: $MACHINE" && \
        FILE_NAME="frp_${FRPC_VERSION}_linux_${MACHINE}.tar.gz" && \
        FILE_DIR="frp_${FRPC_VERSION}_linux_${MACHINE}" && \
        echo "Downloading: https://github.com/fatedier/frp/releases/download/v${FRPC_VERSION}/${FILE_NAME}" && \
        curl -L -o /tmp/${FILE_NAME} \
            "https://github.com/fatedier/frp/releases/download/v${FRPC_VERSION}/${FILE_NAME}" || exit 1 && \
        mkdir -p ${APP_PATH} && \
        tar xzf /tmp/${FILE_NAME} -C /tmp || exit 1 && \
        cp -f /tmp/${FILE_DIR}/frpc ${APP_PATH}/ || exit 1 && \
        rm -rf /tmp/${FILE_NAME} /tmp/${FILE_DIR}; \
    fi

# 复制启动脚本
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
