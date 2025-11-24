#!/bin/bash

# Flutter Module AAR 构建脚本
# 使用方法: ./build_aar.sh [debug|release|profile]

BUILD_TYPE=${1:-release}

echo "开始构建 Flutter Module AAR (${BUILD_TYPE})..."

# 进入android目录
cd android

# 清理之前的构建
echo "清理之前的构建..."
./gradlew clean

# 构建AAR
echo "构建 ${BUILD_TYPE} 版本的AAR..."
if [ "$BUILD_TYPE" = "debug" ]; then
    ./gradlew :app:assembleDebug
    AAR_PATH="app/build/outputs/aar/app-debug.aar"
elif [ "$BUILD_TYPE" = "profile" ]; then
    ./gradlew :app:assembleProfile
    AAR_PATH="app/build/outputs/aar/app-profile.aar"
else
    ./gradlew :app:assembleRelease
    AAR_PATH="app/build/outputs/aar/app-release.aar"
fi

# 检查AAR是否生成成功
if [ -f "$AAR_PATH" ]; then
    echo "✅ AAR构建成功!"
    echo "📦 AAR文件位置: $(pwd)/$AAR_PATH"
    echo "📊 文件大小: $(du -h $AAR_PATH | cut -f1)"
    
    # 复制到项目根目录
    cp "$AAR_PATH" "../flutter_demo-${BUILD_TYPE}.aar"
    echo "📋 已复制到: $(pwd)/../flutter_demo-${BUILD_TYPE}.aar"
else
    echo "❌ AAR构建失败，请检查错误信息"
    exit 1
fi

cd ..

