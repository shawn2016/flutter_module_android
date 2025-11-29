#!/bin/bash

# 安装 Android 应用到真机

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📱 开始安装 Android 应用到真机..."
echo ""

# 检查设备连接
echo "步骤 1: 检查设备连接..."
DEVICES=$(adb devices | grep -v "List" | grep "device" | wc -l | tr -d ' ')

if [ "$DEVICES" -eq "0" ]; then
    echo "❌ 错误: 没有检测到已连接的设备"
    echo ""
    echo "请确保："
    echo "1. 设备已通过 USB 连接到电脑"
    echo "2. 设备已启用 USB 调试"
    echo "3. 已授权电脑调试权限"
    echo ""
    echo "运行 'adb devices' 查看设备列表"
    exit 1
fi

echo "✅ 检测到 $DEVICES 个设备"
adb devices
echo ""

# 进入项目目录
cd "$PROJECT_DIR"

# 检查 gradlew
if [ ! -f "gradlew" ]; then
    echo "❌ 错误: gradlew 不存在"
    exit 1
fi

# 添加执行权限
chmod +x gradlew

# 安装应用
echo "步骤 2: 构建并安装应用..."
echo ""

./gradlew installDebug

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 安装成功！"
    echo ""
    echo "应用已安装到设备，可以在设备上找到并运行。"
    echo ""
    echo "或者运行以下命令启动应用："
    echo "  adb shell am start -n com.simple.app/.MainActivity"
else
    echo ""
    echo "❌ 安装失败，请查看上面的错误信息"
    exit 1
fi

