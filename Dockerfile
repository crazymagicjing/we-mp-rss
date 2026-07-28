# 使用 Python 官方镜像作为基础
FROM python:3.13-slim

# 安装系统依赖（Playwright 需要）
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# 安装 Playwright 的 Python 包
RUN pip install playwright --no-cache-dir

# 安装 Firefox 浏览器（Playwright 会自动下载）
RUN playwright install firefox

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 安装 Python 项目依赖
RUN pip install -r requirements.txt --no-cache-dir

# 暴露端口
EXPOSE 8001

# 启动命令（沿用项目原有的 start.sh）
CMD ["bash", "start.sh"]
