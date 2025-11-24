#!/bin/bash

# 复制 Flutter AAR 文件到 libs 目录的脚本
# 使用方法: ./copy_aar.sh

AAR_SOURCE_DIR="../flutter_module_demo/build/host/outputs/repo/com/example/flutter_module_demo"
LIBS_DIR="app/libs"

echo "开始复制 Flutter AAR 文件..."

# 检查源目录是否存在
if [ ! -d "$AAR_SOURCE_DIR" ]; then
    echo "错误: Flutter Module AAR 文件不存在"
    echo "请先运行: cd ../flutter_module_demo && flutter build aar"
    exit 1
fi

# 创建 libs 目录
mkdir -p "$LIBS_DIR"

# 复制 AAR 文件
echo "复制 Debug AAR..."
cp "$AAR_SOURCE_DIR/flutter_debug/1.0/flutter_debug-1.0.aar" "$LIBS_DIR/flutter_debug.aar" 2>/dev/null || echo "警告: Debug AAR 复制失败"

echo "复制 Profile AAR..."
cp "$AAR_SOURCE_DIR/flutter_profile/1.0/flutter_profile-1.0.aar" "$LIBS_DIR/flutter_profile.aar" 2>/dev/null || echo "警告: Profile AAR 复制失败"

echo "复制 Release AAR..."
cp "$AAR_SOURCE_DIR/flutter_release/1.0/flutter_release-1.0.aar" "$LIBS_DIR/flutter_release.aar" 2>/dev/null || echo "警告: Release AAR 复制失败"

# 检查文件
if [ -f "$LIBS_DIR/flutter_debug.aar" ] && [ -f "$LIBS_DIR/flutter_release.aar" ]; then
    echo "✅ AAR 文件复制成功！"
    echo ""
    echo "文件位置:"
    ls -lh "$LIBS_DIR"/*.aar
    echo ""
    echo "现在可以在 Android Studio 中同步项目了"
else
    echo "❌ 部分 AAR 文件复制失败，请检查错误信息"
    exit 1
fi

