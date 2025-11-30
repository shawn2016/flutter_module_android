#!/bin/bash

# 构建 Flutter iOS Framework 脚本
# 使用方法: ./build_framework.sh [debug|release|profile]

set -e

BUILD_TYPE=${1:-release}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_MODULE_DIR="$PROJECT_ROOT/../rs-booking"

echo "📦 开始构建 Flutter iOS Framework ($BUILD_TYPE)..."
echo ""

# 检查 Flutter 模块目录
if [ ! -d "$FLUTTER_MODULE_DIR" ]; then
    echo "❌ 错误: Flutter 模块目录不存在: $FLUTTER_MODULE_DIR"
    exit 1
fi

cd "$FLUTTER_MODULE_DIR"

# 构建 Framework
echo "正在构建 Framework..."
case $BUILD_TYPE in
    debug)
        flutter build ios-framework --debug
        FRAMEWORK_DIR="build/ios/framework/Debug"
        ;;
    profile)
        flutter build ios-framework --profile
        FRAMEWORK_DIR="build/ios/framework/Profile"
        ;;
    release)
        flutter build ios-framework --release
        FRAMEWORK_DIR="build/ios/framework/Release"
        ;;
    *)
        echo "❌ 错误: 无效的构建类型: $BUILD_TYPE"
        echo "使用方法: ./build_framework.sh [debug|release|profile]"
        exit 1
        ;;
esac

# 检查 Framework 是否构建成功
# 注意：flutter build ios-framework 生成的是 .xcframework 文件
if [ -d "$FRAMEWORK_DIR/App.xcframework" ] || [ -d "$FRAMEWORK_DIR/Flutter.xcframework" ]; then
    echo ""
    echo "✅ Framework 构建成功！"
    echo ""
    echo "Framework 位置:"
    echo "  $FLUTTER_MODULE_DIR/$FRAMEWORK_DIR/"
    echo ""
    echo "生成的 Framework 文件："
    find "$FRAMEWORK_DIR" -name "*.xcframework" -type d 2>/dev/null | while read framework; do
        echo "  - $framework"
        du -sh "$framework" 2>/dev/null | awk '{print "    大小: " $1}'
    done
    echo ""
    echo "下一步："
    echo "1. 如果使用 Framework 方式，在 Xcode 中手动添加 Framework"
    echo "2. 如果使用 CocoaPods 方式，运行 pod install 更新依赖"
    echo ""
else
    echo "❌ Framework 构建失败，未找到 Framework 文件"
    echo "检查目录: $FRAMEWORK_DIR"
    exit 1
fi

