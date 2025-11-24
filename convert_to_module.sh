#!/bin/bash

# Flutter App 转 Module 转换脚本
# 使用方法: ./convert_to_module.sh [项目目录]

PROJECT_DIR=${1:-flutter_demo}
MODULE_NAME="${PROJECT_DIR}_module"

echo "开始将 $PROJECT_DIR 转换为 Flutter Module..."

# 检查项目是否存在
if [ ! -d "$PROJECT_DIR" ]; then
    echo "错误: 项目目录 $PROJECT_DIR 不存在"
    exit 1
fi

# 检查是否是Flutter项目
if [ ! -f "$PROJECT_DIR/pubspec.yaml" ]; then
    echo "错误: $PROJECT_DIR 不是Flutter项目"
    exit 1
fi

# 创建新的Module项目
echo "1. 创建新的Flutter Module项目: $MODULE_NAME"
flutter create --template=module "$MODULE_NAME"

# 复制代码
echo "2. 复制代码文件..."
cp -r "$PROJECT_DIR/lib/"* "$MODULE_NAME/lib/" 2>/dev/null || true

# 复制资源文件（如果有）
if [ -d "$PROJECT_DIR/assets" ]; then
    echo "3. 复制资源文件..."
    cp -r "$PROJECT_DIR/assets" "$MODULE_NAME/" 2>/dev/null || true
fi

# 合并pubspec.yaml的依赖
echo "4. 合并依赖配置..."
# 这里可以添加更复杂的合并逻辑

echo "✅ 转换完成！"
echo ""
echo "下一步："
echo "1. cd $MODULE_NAME"
echo "2. 检查并更新 pubspec.yaml 中的依赖"
echo "3. 运行 flutter pub get"
echo "4. 运行 flutter build aar 构建AAR"
