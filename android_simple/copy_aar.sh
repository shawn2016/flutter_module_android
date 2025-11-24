#!/bin/bash

# 复制 Flutter AAR 文件到 libs 目录的脚本
# 使用方法: ./copy_aar.sh

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

# 定义路径（基于脚本所在目录）
AAR_SOURCE_DIR="$PROJECT_ROOT/../flutter_module_demo/build/host/outputs/repo/com/example/flutter_module_demo"
LIBS_DIR="$PROJECT_ROOT/app/libs"
FLUTTER_MODULE_DIR="$PROJECT_ROOT/../flutter_module_demo"

echo "脚本目录: $SCRIPT_DIR"
echo "开始构建 Flutter Module AAR..."

# 构建 AAR
if [ -d "$FLUTTER_MODULE_DIR" ]; then
    cd "$FLUTTER_MODULE_DIR" || exit 1
    flutter build aar
    echo "构建完成"
else
    echo "错误: Flutter Module 目录不存在: $FLUTTER_MODULE_DIR"
    exit 1
fi

# 返回到脚本目录
cd "$SCRIPT_DIR" || exit 1

echo "开始复制 Flutter AAR 文件..."

# 检查源目录是否存在
if [ ! -d "$AAR_SOURCE_DIR" ]; then
    echo "错误: Flutter Module AAR 文件不存在"
    echo "请检查路径: $AAR_SOURCE_DIR"
    echo "请先运行: cd ../flutter_module_demo && flutter build aar"
    exit 1
fi

# 创建 libs 目录
mkdir -p "$LIBS_DIR"

# 复制 AAR 文件
echo "复制 Debug AAR..."
if cp "$AAR_SOURCE_DIR/flutter_debug/1.0/flutter_debug-1.0.aar" "$LIBS_DIR/flutter_debug.aar" 2>/dev/null; then
    echo "  ✅ Debug AAR 复制成功"
else
    echo "  ❌ Debug AAR 复制失败"
fi

echo "复制 Profile AAR..."
if cp "$AAR_SOURCE_DIR/flutter_profile/1.0/flutter_profile-1.0.aar" "$LIBS_DIR/flutter_profile.aar" 2>/dev/null; then
    echo "  ✅ Profile AAR 复制成功"
else
    echo "  ❌ Profile AAR 复制失败"
fi

echo "复制 Release AAR..."
if cp "$AAR_SOURCE_DIR/flutter_release/1.0/flutter_release-1.0.aar" "$LIBS_DIR/flutter_release.aar" 2>/dev/null; then
    echo "  ✅ Release AAR 复制成功"
else
    echo "  ❌ Release AAR 复制失败"
fi

# 检查文件
if [ -f "$LIBS_DIR/flutter_debug.aar" ] && [ -f "$LIBS_DIR/flutter_release.aar" ]; then
    echo ""
    echo "✅ AAR 文件复制成功！"
    echo ""
    echo "文件位置:"
    ls -lh "$LIBS_DIR"/*.aar
    echo ""
    echo "现在可以在 Android Studio 中同步项目了"
else
    echo ""
    echo "❌ 部分 AAR 文件复制失败，请检查错误信息"
    exit 1
fi

