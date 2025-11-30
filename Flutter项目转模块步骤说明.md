# Flutter 项目转模块完整步骤说明

## 📋 概述

本文档详细说明如何将 `rs-booking` 从 **Flutter 应用项目**转换为 **Flutter 模块项目**，以便嵌入到原生 Android/iOS 应用中。

---

## 🔍 转换前后对比

### 转换前（App 项目）

```
rs-booking/
├── .metadata                    # project_type: app
├── pubspec.yaml                 # 没有 module 配置
├── android/                     # 可见的 android 目录
│   ├── app/
│   │   └── build.gradle.kts    # com.android.application
│   └── settings.gradle.kts
├── ios/                         # 可见的 ios 目录
└── lib/                         # Flutter 代码
```

### 转换后（Module 项目）

```
rs-booking/
├── .metadata                    # project_type: module
├── pubspec.yaml                 # 有 module 配置
├── .android/                    # 隐藏的 .android 目录（自动生成）
│   ├── Flutter/
│   ├── app/                     # 示例应用
│   └── include_flutter.groovy
├── .ios/                        # 隐藏的 .ios 目录（自动生成）
│   └── Flutter/
└── lib/                         # Flutter 代码（不变）
```

---

## 📝 详细转换步骤

### 步骤 1: 修改 `.metadata` 文件

**文件路径：** `rs-booking/.metadata`

**修改内容：**

```yaml
# 修改前
project_type: app

# 修改后
project_type: module
```

**完整文件内容（修改后）：**

```yaml
# This file tracks properties of this Flutter project.
# Used by Flutter tool to assess capabilities and perform upgrades etc.
#
# This file should be version controlled and should not be manually edited.

version:
  revision: "d8a9f9a52e5af486f80d932e838ee93861ffd863"
  channel: "stable"

# ⭐ 关键修改：将 app 改为 module
project_type: module

# ⭐ 删除 migration 部分（Module 项目不需要）
```

**改动目的：**
- 告诉 Flutter 工具这是一个模块项目
- 影响 Flutter 工具的行为（如生成 `.android/` 而不是 `android/`）

---

### 步骤 2: 修改 `pubspec.yaml` 文件

**文件路径：** `rs-booking/pubspec.yaml`

**修改内容：**

在 `flutter:` 块中添加 `module:` 配置：

```yaml
flutter:
  uses-material-design: true
  
  # ⭐ 新增：Module 配置
  module:
    androidX: true
    androidPackage: ai.restosuite.inc.tables
    iosBundleIdentifier: ai.restosuite.inc.tables
```

**完整示例（假设原有配置）：**

```yaml
name: rs_booking
description: "RS Booking Flutter Module"
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  # ... 其他依赖 ...

flutter:
  uses-material-design: true
  
  # 资源文件
  assets:
    - assets/images/
    - assets/html/booking_privacy.html
  
  # 字体文件
  fonts:
    - family: iconfont
      fonts:
        - asset: assets/fonts/iconfont.ttf
    - family: DigitFont
      fonts:
        - asset: assets/fonts/OPPO Sans 4.0.ttf
          weight: 700
  
  # ⭐ 新增：Module 配置
  module:
    androidX: true
    androidPackage: ai.restosuite.inc.tables
    iosBundleIdentifier: ai.restosuite.inc.tables
```

**配置说明：**

| 配置项 | 说明 | 示例值 |
|--------|------|--------|
| `androidX: true` | 使用 AndroidX 库 | `true` |
| `androidPackage` | Android 包名（用于生成 AAR） | `ai.restosuite.inc.tables` |
| `iosBundleIdentifier` | iOS Bundle ID | `ai.restosuite.inc.tables` |

**改动目的：**
- 配置模块的 Android 包名和 iOS Bundle ID
- 这些信息会用于生成 AAR 和 Framework

---

### 步骤 3: 删除或重命名 `android/` 目录

**操作：**

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking

# 方法 1: 删除 android 目录（推荐）
rm -rf android

# 方法 2: 重命名备份（如果想保留）
mv android android_backup
```

**改动目的：**
- Flutter Module 使用 `.android/` 隐藏目录（自动生成）
- 删除旧的 `android/` 目录，让 Flutter 生成新的 `.android/` 目录

**注意：**
- 如果 `android/` 目录中有自定义配置，需要先备份
- 运行 `flutter pub get` 后会自动生成 `.android/` 目录

---

### 步骤 4: 运行 `flutter pub get`

**操作：**

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
flutter pub get
```

**这个命令会：**
- ✅ 解析 `pubspec.yaml` 中的依赖
- ✅ 自动生成 `.android/` 目录（如果不存在）
- ✅ 自动生成 `.ios/` 目录（如果不存在）
- ✅ 生成必要的配置文件

**验证：**

```bash
# 检查 .android 目录是否生成
ls -la .android

# 检查 .ios 目录是否生成
ls -la .ios
```

---

### 步骤 5: 验证转换结果

#### 5.1 检查项目类型

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
cat .metadata | grep "project_type"
```

应该显示：`project_type: module`

#### 5.2 检查 Module 配置

```bash
cat pubspec.yaml | grep -A 5 "module:"
```

应该看到 module 配置块。

#### 5.3 检查目录结构

```bash
# 应该没有 android/ 目录
test -d android && echo "❌ android 目录还存在" || echo "✅ android 目录已删除"

# 应该有 .android/ 目录
test -d .android && echo "✅ .android 目录已生成" || echo "❌ .android 目录未生成"

# 应该有 .ios/ 目录
test -d .ios && echo "✅ .ios 目录已生成" || echo "❌ .ios 目录未生成"
```

#### 5.4 测试构建 AAR（Android）

```bash
flutter build aar
```

如果成功，会在以下位置生成 AAR 文件：
```
build/host/outputs/repo/ai/restosuite/inc/tables/
├── flutter_debug/1.0/flutter_debug-1.0.aar
├── flutter_profile/1.0/flutter_profile-1.0.aar
└── flutter_release/1.0/flutter_release-1.0.aar
```

#### 5.5 测试构建 Framework（iOS）

```bash
flutter build ios-framework
```

如果成功，会在以下位置生成 Framework：
```
build/ios/framework/
├── Debug/
│   ├── App.xcframework
│   └── Flutter.xcframework
├── Profile/
│   ├── App.xcframework
│   └── Flutter.xcframework
└── Release/
    ├── App.xcframework
    └── Flutter.xcframework
```

---

## 📋 完整操作清单

### ✅ 必须修改的文件

- [ ] **`.metadata`** - 修改 `project_type: app` → `project_type: module`
- [ ] **`pubspec.yaml`** - 添加 `module:` 配置块

### ✅ 必须执行的操作

- [ ] **删除 `android/` 目录** - `rm -rf android`
- [ ] **运行 `flutter pub get`** - 生成 `.android/` 和 `.ios/` 目录
- [ ] **验证转换** - 检查项目类型和目录结构
- [ ] **测试构建** - 运行 `flutter build aar` 和 `flutter build ios-framework`

### ✅ 可选操作

- [ ] **备份 `android/` 目录** - 如果需要保留自定义配置
- [ ] **更新 README** - 说明这是 Module 项目
- [ ] **更新构建脚本** - 使用 `flutter build aar` 而不是 `flutter build apk`

---

## 🔧 快速转换脚本

创建一个转换脚本 `convert_to_module.sh`：

```bash
#!/bin/bash

# Flutter 项目转模块脚本
# 使用方法: ./convert_to_module.sh

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 开始将 rs-booking 转换为 Flutter Module..."
echo ""

# 步骤 1: 修改 .metadata
echo "步骤 1: 修改 .metadata 文件..."
if [ -f "$PROJECT_DIR/.metadata" ]; then
    # 备份原文件
    cp "$PROJECT_DIR/.metadata" "$PROJECT_DIR/.metadata.backup"
    
    # 修改 project_type
    sed -i '' 's/project_type: app/project_type: module/g' "$PROJECT_DIR/.metadata"
    
    # 删除 migration 部分（可选）
    # sed -i '' '/^migration:/,/^$/d' "$PROJECT_DIR/.metadata"
    
    echo "✅ .metadata 已修改"
else
    echo "❌ .metadata 文件不存在"
    exit 1
fi

# 步骤 2: 检查 pubspec.yaml
echo ""
echo "步骤 2: 检查 pubspec.yaml..."
if grep -q "module:" "$PROJECT_DIR/pubspec.yaml"; then
    echo "✅ pubspec.yaml 已包含 module 配置"
else
    echo "⚠️  pubspec.yaml 中未找到 module 配置"
    echo "请手动添加以下配置到 flutter: 块中："
    echo ""
    echo "  module:"
    echo "    androidX: true"
    echo "    androidPackage: ai.restosuite.inc.tables"
    echo "    iosBundleIdentifier: ai.restosuite.inc.tables"
    echo ""
fi

# 步骤 3: 删除 android 目录
echo ""
echo "步骤 3: 处理 android 目录..."
if [ -d "$PROJECT_DIR/android" ]; then
    # 备份
    if [ ! -d "$PROJECT_DIR/android_backup" ]; then
        echo "备份 android 目录到 android_backup..."
        cp -r "$PROJECT_DIR/android" "$PROJECT_DIR/android_backup"
    fi
    
    echo "删除 android 目录..."
    rm -rf "$PROJECT_DIR/android"
    echo "✅ android 目录已删除"
else
    echo "✅ android 目录不存在（可能已删除）"
fi

# 步骤 4: 运行 flutter pub get
echo ""
echo "步骤 4: 运行 flutter pub get..."
cd "$PROJECT_DIR"
flutter pub get

# 步骤 5: 验证
echo ""
echo "步骤 5: 验证转换结果..."
if [ -d "$PROJECT_DIR/.android" ]; then
    echo "✅ .android 目录已生成"
else
    echo "❌ .android 目录未生成"
fi

if [ -d "$PROJECT_DIR/.ios" ]; then
    echo "✅ .ios 目录已生成"
else
    echo "❌ .ios 目录未生成"
fi

echo ""
echo "✅ 转换完成！"
echo ""
echo "下一步："
echo "1. 检查 pubspec.yaml 中的 module 配置"
echo "2. 运行 'flutter build aar' 测试 Android 构建"
echo "3. 运行 'flutter build ios-framework' 测试 iOS 构建"
```

---

## ⚠️ 注意事项

### 1. 备份重要文件

转换前建议备份：
```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
cp .metadata .metadata.backup
cp pubspec.yaml pubspec.yaml.backup
```

### 2. 自定义 Android 配置

如果 `android/` 目录中有自定义配置（如 ProGuard 规则、签名配置等），需要：
1. 先备份这些配置
2. 转换后手动迁移到 `.android/` 目录（如果需要）

### 3. 自定义 iOS 配置

如果 `ios/` 目录中有自定义配置，需要：
1. 先备份这些配置
2. 转换后手动迁移到 `.ios/` 目录（如果需要）

### 4. Git 提交

转换后建议：
```bash
# 添加新文件
git add .metadata pubspec.yaml .android .ios

# 删除旧文件
git rm -r android

# 提交
git commit -m "Convert Flutter app to module"
```

---

## 🔍 转换前后关键差异

| 项目 | App 项目 | Module 项目 |
|------|---------|------------|
| **项目类型** | `project_type: app` | `project_type: module` |
| **Android 目录** | `android/` (可见) | `.android/` (隐藏，自动生成) |
| **iOS 目录** | `ios/` (可见) | `.ios/` (隐藏，自动生成) |
| **pubspec.yaml** | 无 `module:` 配置 | 有 `module:` 配置 |
| **构建命令** | `flutter build apk` | `flutter build aar` |
| **输出文件** | APK | AAR (Android) / Framework (iOS) |
| **独立运行** | ✅ 可以 | ⚠️ 通过示例应用 |

---

## 📚 相关文档

- [Android 原生项目集成 Flutter 模块指南](../flutter_module_android/android_simple/原生项目怎么集成flutter模块.md)
- [iOS 原生项目集成 Flutter 模块指南](../flutter_module_android/ios_simple/原生项目怎么集成flutter模块.md)
- [Flutter 官方文档：将 Flutter 添加到现有应用](https://docs.flutter.cn/add-to-app/)

---

**文档版本：** 1.0  
**最后更新：** 2025-11-30  
**适用项目：** rs-booking

