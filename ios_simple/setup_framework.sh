#!/bin/bash

# Framework 方式完整设置脚本

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_MODULE_DIR="$PROJECT_ROOT/../rs-booking"
IOS_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 开始设置 Framework 方式集成..."
echo ""

# 步骤 1: 构建 Framework
echo "步骤 1: 构建 Flutter Framework..."
cd "$FLUTTER_MODULE_DIR"
flutter build ios-framework --release

# 检查 Framework 是否构建成功
FRAMEWORK_DIR="$FLUTTER_MODULE_DIR/build/ios/framework"
if [ -d "$FRAMEWORK_DIR/Release/App.xcframework" ] || [ -d "$FRAMEWORK_DIR/Release/Flutter.xcframework" ]; then
    echo "✅ Framework 构建成功"
    echo "Framework 位置: $FRAMEWORK_DIR"
    echo ""
    echo "生成的 Framework 文件："
    find "$FRAMEWORK_DIR/Release" -name "*.xcframework" -type d 2>/dev/null | head -5
    echo ""
else
    echo "⚠️  Framework 可能未完全构建，但继续使用 .ios 模块方式"
    echo "检查目录: $FRAMEWORK_DIR"
    echo ""
fi

# 步骤 2: 安装 Pods
echo "步骤 2: 安装 CocoaPods 依赖..."
cd "$IOS_PROJECT_DIR"
pod install

if [ ! -d "ios_simple.xcworkspace" ]; then
    echo "❌ pod install 失败"
    exit 1
fi

echo "✅ Pods 安装成功"
echo ""

echo "✅ 设置完成！"
echo ""
echo "下一步："
echo "1. 打开工作空间: open ios_simple.xcworkspace"
echo "2. 在 Xcode 中添加 AppDelegate.swift 和 FlutterManager.swift（如果还没有）"
echo "3. 运行项目 (⌘R)"
echo ""

