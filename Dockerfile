# syntax=docker/dockerfile:1.2
FROM --platform=linux/amd64 jenkins/jenkins:lts

# 设置环境变量
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/latest/bin"

# 安装Android SDK所需的工具
USER root
RUN apt-get update && \
    apt-get install -y wget unzip && \
    # 下载并解压Android SDK命令行工具
    mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O /tmp/android-sdk.zip && \
    unzip /tmp/android-sdk.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/android-sdk.zip && \
    # 安装Android SDK的必要组件
    yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "platforms;android-30" "build-tools;30.0.3"

# 切换回jenkins用户
USER jenkins

# 暴露端口
EXPOSE 8080 50000

# 启动Jenkins
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
