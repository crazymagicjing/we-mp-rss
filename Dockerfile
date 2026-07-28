# 使用 Python 官方镜像作为基础
FROM python:3.13-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖（Playwright 需要）
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# 复制项目依赖文件并安装 Python 包
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 安装 Playwright 并下载 Firefox 浏览器
RUN pip install playwright --no-cache-dir && \
    playwright install firefox

# 复制项目所有文件到容器
COPY . .

# 暴露端口
EXPOSE 8001

# 【关键修改】直接启动 Python 应用，跳过 start.sh
CMD ["python", "main.py", "-job", "True", "-init", "True"]
