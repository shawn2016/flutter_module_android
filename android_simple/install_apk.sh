#!/bin/bash

# 直接安装已构建的 APK

APK_PATH="app/build/outputs/apk/debug/app-debug.apk"

if [ ! -f "$APK_PATH" ]; then
    echo "❌ APK 文件不存在: $APK_PATH"
    echo "请先构建项目"
    exit 1
fi

echo "📱 安装 APK 到设备..."
adb install -r "$APK_PATH"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 安装成功！"
    echo ""
    echo "启动应用："
    echo "  adb shell am start -n com.simple.app/.MainActivity"
else
    echo ""
    echo "❌ 安装失败"
    exit 1
fi

