# 使用官方 Playwright 镜像作为基础（已包含 Firefox 和所有依赖）
FROM mcr.microsoft.com/playwright:v1.45.0-focal AS runtime

ENV PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple
ENV PLANT_PATH=/app/env

WORKDIR /app
RUN echo "1.0.$(date +%Y%m%d.%H%M)">>docker_version.txt
COPY requirements.txt install.sh ./
RUN bash install.sh

COPY . .

# 确保 Playwright 浏览器已安装
RUN playwright install firefox

EXPOSE 8001
CMD ["bash", "start.sh"]
