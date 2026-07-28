# 使用 Python 官方镜像作为基础
FROM python:3.13-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件并安装 Python 包
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install pymysql --no-cache-dir

# 安装 Playwright 并下载 Firefox
RUN pip install playwright --no-cache-dir && \
    playwright install firefox

# 复制项目所有文件
COPY . .

# 【关键】创建 config.yaml，让应用能正确加载数据库配置
RUN echo 'db: ${DATABASE_URL}' > /app/config.yaml && \
    echo 'port: 8001' >> /app/config.yaml && \
    echo 'host: 0.0.0.0' >> /app/config.yaml && \
    echo 'enable_redis: false' >> /app/config.yaml && \
    echo 'log_level: INFO' >> /app/config.yaml

# 创建数据目录（SQLite 文件存放位置）
RUN mkdir -p /data

# 暴露端口
EXPOSE 8001

# 启动应用
CMD ["python", "main.py", "-job", "True", "-init", "True"]
