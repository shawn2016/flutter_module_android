#!/bin/bash

# Flutter 项目转模块脚本
# 功能：将 Flutter 应用程序（app）转换为 Flutter 模块（module）

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "🔄 开始将 Flutter 项目转换为模块..."
echo "项目目录: $PROJECT_DIR"
echo ""

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 步骤 1: 备份 android 目录（如果存在）
if [ -d "android" ]; then
    if [ -d "android_backup" ]; then
        echo -e "${YELLOW}⚠️  android_backup 目录已存在，跳过备份${NC}"
    else
        echo "📦 步骤 1: 备份 android 目录..."
        cp -r android android_backup
        echo -e "${GREEN}✅ android 目录已备份到 android_backup${NC}"
    fi
    echo ""
fi

# 步骤 2: 修改 .metadata 文件
echo "📝 步骤 2: 修改 .metadata 文件..."
if [ ! -f ".metadata" ]; then
    echo -e "${RED}❌ 错误: .metadata 文件不存在${NC}"
    exit 1
fi

# 备份 .metadata
cp .metadata .metadata.backup

# 使用 Python 修改 .metadata（更可靠）
python3 << 'PYTHON_SCRIPT'
import re

with open('.metadata', 'r') as f:
    content = f.read()

# 将 project_type: app 改为 project_type: module
content = re.sub(r'project_type:\s*app', 'project_type: module', content)

# 删除 migration 部分（从 migration: 到文件末尾的所有内容，但保留 version 部分）
lines = content.split('\n')
new_lines = []
skip_migration = False
for line in lines:
    if line.strip().startswith('migration:'):
        skip_migration = True
        continue
    if skip_migration and line.strip() and not line.startswith(' ') and not line.startswith('\t'):
        # 遇到新的顶级键，停止跳过
        if not line.strip().startswith('#'):
            skip_migration = False
            new_lines.append(line)
    elif not skip_migration:
        new_lines.append(line)

content = '\n'.join(new_lines)

with open('.metadata', 'w') as f:
    f.write(content)

print("✅ .metadata 已更新")
PYTHON_SCRIPT

echo -e "${GREEN}✅ .metadata 文件已修改${NC}"
echo ""

# 步骤 3: 修改 pubspec.yaml 文件
echo "📝 步骤 3: 修改 pubspec.yaml 文件..."
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ 错误: pubspec.yaml 文件不存在${NC}"
    exit 1
fi

# 备份 pubspec.yaml
cp pubspec.yaml pubspec.yaml.backup

# 使用 Python 修改 pubspec.yaml
python3 << 'PYTHON_SCRIPT'
import re

with open('pubspec.yaml', 'r') as f:
    lines = f.readlines()

# 找到正确的 flutter: 配置块（不是 dependencies 中的 flutter sdk 依赖）
flutter_idx = None
in_dependencies = False
in_dev_dependencies = False

for i in range(len(lines)):
    line_stripped = lines[i].strip()
    line_indent = len(lines[i]) - len(lines[i].lstrip())
    
    # 检查是否在 dependencies 或 dev_dependencies 块中
    if line_stripped == 'dependencies:':
        in_dependencies = True
        in_dev_dependencies = False
        continue
    elif line_stripped == 'dev_dependencies:':
        in_dependencies = False
        in_dev_dependencies = True
        continue
    
    # 如果遇到其他顶级键（0个空格缩进），说明已经离开 dependencies/dev_dependencies 块
    if line_stripped and not line_stripped.startswith('#') and line_indent == 0:
        if line_stripped == 'flutter:':
            # 找到独立的 flutter: 配置块
            flutter_idx = i
            break
        elif line_stripped not in ['dependencies:', 'dev_dependencies:']:
            # 遇到其他顶级键，说明已经离开 dependencies/dev_dependencies
            in_dependencies = False
            in_dev_dependencies = False

if flutter_idx is None:
    print("❌ 未找到正确的 flutter: 配置块")
    print("   提示：flutter: 配置块应该在 dependencies 和 dev_dependencies 之后")
    exit(1)

print(f"找到 flutter: 块在第 {flutter_idx + 1} 行")

# 检查是否已经有 module 配置
has_module = False
for i in range(flutter_idx + 1, min(flutter_idx + 10, len(lines))):
    if lines[i].strip().startswith('module:'):
        has_module = True
        print("✅ module 配置已存在")
        break

if not has_module:
    # 插入 module 配置
    indent = '  '
    module_config = [
        f"{indent}module:\n",
        f"{indent}  androidX: true\n",
        f"{indent}  androidPackage: ai.restosuite.inc.tables\n",
        f"{indent}  iosBundleIdentifier: ai.restosuite.inc.tables\n"
    ]
    # 在 flutter: 后面插入
    lines[flutter_idx + 1:flutter_idx + 1] = module_config
    print("✅ 已添加 module 配置")

# 修复 assets 和 fonts 的缩进（确保它们在 flutter: 下，与 module: 同级）
print("🔧 检查并修复 assets 和 fonts 的缩进...")
fixed = False
i = flutter_idx + 1
while i < len(lines):
    line = lines[i]
    stripped = line.lstrip()
    
    # 如果遇到顶级键（0个空格），停止
    if stripped and not stripped.startswith('#') and len(line) - len(stripped) == 0:
        break
    
    # 检查是否是 uses-material-design、assets 或 fonts（应该在 flutter: 下，2个空格缩进）
    if stripped.startswith('uses-material-design:') or stripped.startswith('assets:') or stripped.startswith('fonts:'):
        indent = len(line) - len(stripped)
        # 如果缩进是4个空格（在 module 块内），修复为2个空格
        if indent == 4:
            lines[i] = '  ' + stripped
            fixed = True
            print(f"✅ 修复了第 {i+1} 行的缩进: {stripped.split(':')[0]}")
            
            # 如果是 assets 或 fonts，还需要修复其子项的缩进
            if stripped.startswith('assets:') or stripped.startswith('fonts:'):
                j = i + 1
                while j < len(lines):
                    next_line = lines[j]
                    next_stripped = next_line.lstrip()
                    next_indent = len(next_line) - len(next_stripped)
                    
                    # 如果遇到同级或更高级的键，停止
                    if next_stripped and not next_stripped.startswith('#'):
                        if next_indent <= 2:
                            break
                        # 如果缩进大于4，减少2个空格
                        if next_indent > 4:
                            lines[j] = next_line[2:]
                            fixed = True
                    elif next_stripped == '':
                        # 空行保持不变
                        pass
                    j += 1
                    # 如果下一行是同级键，停止
                    if j < len(lines):
                        check_line = lines[j]
                        check_stripped = check_line.lstrip()
                        if check_stripped and not check_stripped.startswith('#'):
                            check_indent = len(check_line) - len(check_stripped)
                            if check_indent <= 2:
                                break
    
    i += 1

if fixed:
    print("✅ 缩进已修复")
else:
    print("✅ 缩进已正确，无需修复")
    
# 写回文件
with open('pubspec.yaml', 'w') as f:
    f.writelines(lines)

PYTHON_SCRIPT

echo -e "${GREEN}✅ pubspec.yaml 文件已修改${NC}"
echo ""

# 步骤 4: 删除 android 目录
if [ -d "android" ]; then
    echo "🗑️  步骤 4: 删除 android 目录..."
    rm -rf android
    echo -e "${GREEN}✅ android 目录已删除${NC}"
    echo ""
fi

# 步骤 5: 清理并重新获取依赖
echo "🧹 步骤 5: 清理并重新获取依赖..."
flutter clean > /dev/null 2>&1 || true
flutter pub get

echo ""
echo -e "${GREEN}✅ 依赖已更新${NC}"
echo ""

# 步骤 5.5: 生成 assets.gen.dart 文件
echo "🔨 步骤 5.5: 生成 assets.gen.dart 文件..."
echo "这可能需要一些时间..."
flutter pub run build_runner build --delete-conflicting-outputs > /dev/null 2>&1 || true

# 检查是否生成成功
if [ -f "lib/gen/assets.gen.dart" ]; then
    echo -e "${GREEN}✅ assets.gen.dart 已生成${NC}"
else
    echo -e "${YELLOW}⚠️  assets.gen.dart 未自动生成，可能需要手动运行: flutter pub run build_runner build${NC}"
fi
echo ""

# 步骤 5.6: 修复 Kotlin 版本（兼容 mobile_scanner 等插件）
echo "🔧 步骤 5.6: 修复 Kotlin 版本..."
SETTINGS_FILE=".android/settings.gradle"
if [ -f "$SETTINGS_FILE" ]; then
    # 备份原文件
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup" 2>/dev/null || true
    
    # 使用 sed 替换 Kotlin 版本（macOS 和 Linux 兼容）
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/org.jetbrains.kotlin.android" version "1\.8\.22"/org.jetbrains.kotlin.android" version "2.1.0"/g' "$SETTINGS_FILE"
    else
        sed -i 's/org.jetbrains.kotlin.android" version "1\.8\.22"/org.jetbrains.kotlin.android" version "2.1.0"/g' "$SETTINGS_FILE"
    fi
    
    # 验证是否替换成功
    if grep -q 'org.jetbrains.kotlin.android" version "2.1.0"' "$SETTINGS_FILE"; then
        echo -e "${GREEN}✅ Kotlin 版本已更新到 2.1.0${NC}"
    else
        echo -e "${YELLOW}⚠️  Kotlin 版本可能未正确更新${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  $SETTINGS_FILE 不存在，跳过 Kotlin 版本修复${NC}"
fi
echo ""

# 步骤 6: 验证转换
echo "🔍 步骤 6: 验证转换..."
echo ""

# 检查 .metadata
if grep -q "project_type: module" .metadata; then
    echo -e "${GREEN}✅ .metadata: project_type 已设置为 module${NC}"
else
    echo -e "${RED}❌ .metadata: project_type 设置失败${NC}"
fi

# 检查 pubspec.yaml
if grep -q "module:" pubspec.yaml && grep -q "androidPackage: ai.restosuite.inc.tables" pubspec.yaml; then
    echo -e "${GREEN}✅ pubspec.yaml: module 配置已添加${NC}"
else
    echo -e "${RED}❌ pubspec.yaml: module 配置添加失败${NC}"
fi

# 检查 android 目录
if [ ! -d "android" ]; then
    echo -e "${GREEN}✅ android 目录已删除${NC}"
else
    echo -e "${YELLOW}⚠️  android 目录仍然存在${NC}"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Flutter 项目已成功转换为模块！${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📋 下一步："
echo "  1. 运行 'flutter build aar' 构建 Android AAR"
echo "  2. 运行 'flutter build ios-framework' 构建 iOS Framework"
echo ""
echo "💡 提示："
echo "  - 备份文件已保存：.metadata.backup, pubspec.yaml.backup"
echo "  - 如果需要恢复，可以使用备份文件"
echo ""
