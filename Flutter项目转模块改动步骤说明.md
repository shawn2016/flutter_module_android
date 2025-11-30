# Flutter 项目转模块改动步骤说明

## 📋 概述

本文档详细说明如何将 `rs-booking` Flutter **应用项目**转换为 Flutter **模块项目**，以便嵌入到原生 Android/iOS 应用中。

---

## 🎯 转换目标

**从：** Flutter 应用项目（可以独立运行）  
**到：** Flutter 模块项目（可以嵌入到原生应用）

---

## 📝 需要修改的文件清单

| 文件 | 操作 | 说明 |
|------|------|------|
| `.metadata` | **修改** | 更改项目类型标识 |
| `pubspec.yaml` | **修改** | 添加 module 配置 |
| `android/` | **删除** | 删除后会自动生成 `.android/` |
| `ios/` | **保留** | iOS 配置保留，但会生成 `.ios/` |

---

## 🔧 详细改动步骤

### 步骤 1: 修改 `.metadata` 文件

**文件路径：** `rs-booking/.metadata`

**修改前：**
```yaml
project_type: app
# 可能包含 migration 信息
```

**修改后：**
```yaml
project_type: module
# 删除 migration 部分（如果有）
```

**具体操作：**

1. 打开 `.metadata` 文件
2. 将 `project_type: app` 改为 `project_type: module`
3. 删除 `migration:` 部分（如果有）

**完整示例：**
```yaml
# This file tracks properties of this Flutter project.
# Used by Flutter tool to assess capabilities and perform upgrades etc.
#
# This file should be version controlled and should not be manually edited.

version:
  revision: "stable"
  channel: "stable"

project_type: module  # ⭐ 改为 module

# ⭐ 删除 migration 部分（如果有）
```

**改动目的：**
- 告诉 Flutter 工具这是一个模块项目
- 影响 Flutter 工具的行为（如生成 `.android/` 而不是 `android/`）

---

### 步骤 2: 修改 `pubspec.yaml` 文件

**文件路径：** `rs-booking/pubspec.yaml`

**修改前：**
```yaml
name: rs_booking
description: "RS Booking application"
publish_to: 'none'

flutter:
  uses-material-design: true
  assets:
    - assets/images/
  # ... 其他配置
```

**修改后：**
```yaml
name: rs_booking
description: "RS Booking module"  # ⭐ 可选：更新描述
publish_to: 'none'

flutter:
  uses-material-design: true
  assets:
    - assets/images/
  
  # ⭐ 新增：module 配置块
  module:
    androidX: true
    androidPackage: ai.restosuite.inc.tables
    iosBundleIdentifier: ai.restosuite.inc.tables
```

**具体操作：**

1. 打开 `pubspec.yaml` 文件
2. 在 `flutter:` 块中添加 `module:` 配置
3. 设置 Android 包名和 iOS Bundle Identifier

**配置说明：**

- `androidX: true` - 使用 AndroidX 库
- `androidPackage: ai.restosuite.inc.tables` - Android 包名（用于生成 AAR）
- `iosBundleIdentifier: ai.restosuite.inc.tables` - iOS Bundle Identifier

**改动目的：**
- 配置模块的 Android 和 iOS 标识
- 这些信息会用于生成 AAR 和 Framework

---

### 步骤 3: 删除 `android/` 目录（如果存在）

**操作：**

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking

# 备份（可选）
# cp -r android android_backup

# 删除 android 目录
rm -rf android
```

**改动目的：**
- Flutter 模块使用 `.android/` 隐藏目录（自动生成）
- 删除 `android/` 后，运行 `flutter pub get` 会自动生成 `.android/`

**注意：**
- 如果 `android/` 目录中有自定义配置，需要先备份
- 自定义配置需要在生成 `.android/` 后重新应用

---

### 步骤 4: 运行 `flutter pub get`

**操作：**

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
flutter pub get
```

**改动目的：**
- 重新生成项目结构
- 自动创建 `.android/` 目录（如果已删除 `android/`）
- 更新依赖

**预期结果：**
- 生成 `.android/` 目录（隐藏目录）
- 生成 `.ios/` 目录（如果还没有）

---

### 步骤 5: 验证转换结果

**检查项目类型：**

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking

# 检查 .metadata
cat .metadata | grep "project_type"
# 应该输出: project_type: module

# 检查 pubspec.yaml
cat pubspec.yaml | grep -A 5 "module:"
# 应该看到 module 配置

# 检查目录结构
ls -la | grep android
# 应该看到 .android（隐藏目录），不应该看到 android
```

**验证构建：**

```bash
# 测试 Android AAR 构建
flutter build aar

# 如果成功，会生成：
# build/host/outputs/repo/ai/restosuite/inc/tables/
#   ├── flutter_debug/1.0/flutter_debug-1.0.aar
#   ├── flutter_profile/1.0/flutter_profile-1.0.aar
#   └── flutter_release/1.0/flutter_release-1.0.aar
```

---

## 📊 转换前后对比

### 目录结构对比

**转换前（App 项目）：**
```
rs-booking/
├── android/              # 可见目录
│   ├── app/
│   │   └── build.gradle.kts
│   └── settings.gradle.kts
├── ios/                  # iOS 配置
├── lib/                  # Dart 代码
├── pubspec.yaml
└── .metadata             # project_type: app
```

**转换后（Module 项目）：**
```
rs-booking/
├── .android/             # ⭐ 隐藏目录（自动生成）
│   ├── Flutter/
│   ├── app/              # 示例应用
│   ├── build.gradle      # library 插件
│   └── include_flutter.groovy
├── .ios/                 # ⭐ iOS 配置（自动生成）
├── lib/                  # Dart 代码（不变）
├── pubspec.yaml          # ⭐ 添加了 module 配置
└── .metadata             # ⭐ project_type: module
```

### 构建命令对比

| 操作 | App 项目 | Module 项目 |
|------|---------|------------|
| **构建 Android** | `flutter build apk` | `flutter build aar` |
| **构建 iOS** | `flutter build ios` | `flutter build ios-framework` |
| **运行** | `flutter run` | `flutter run`（使用示例应用） |

---

## ✅ 转换检查清单

完成以下所有步骤后，转换完成：

- [ ] ✅ 修改 `.metadata` 文件：`project_type: module`
- [ ] ✅ 修改 `pubspec.yaml`：添加 `module:` 配置块
- [ ] ✅ 删除 `android/` 目录（如果存在）
- [ ] ✅ 运行 `flutter pub get`
- [ ] ✅ 验证 `.android/` 目录已生成
- [ ] ✅ 测试构建：`flutter build aar`
- [ ] ✅ 验证 AAR 文件已生成

---

## 🚀 转换后可以做什么

### 1. 构建 Android AAR

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
flutter build aar
```

**输出位置：**
```
build/host/outputs/repo/ai/restosuite/inc/tables/
├── flutter_debug/1.0/flutter_debug-1.0.aar
├── flutter_profile/1.0/flutter_profile-1.0.aar
└── flutter_release/1.0/flutter_release-1.0.aar
```

### 2. 构建 iOS Framework

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
flutter build ios-framework
```

**输出位置：**
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

### 3. 集成到原生项目

**Android：**
- 参考：`android_simple/原生项目怎么集成flutter模块.md`

**iOS：**
- 参考：`ios_simple/原生项目怎么集成flutter模块.md`

---

## ⚠️ 注意事项

### 1. 备份重要文件

转换前建议备份：
```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
cp -r android android_backup  # 如果 android 目录有自定义配置
```

### 2. 自定义 Android 配置

如果 `android/` 目录中有自定义配置（如 ProGuard 规则、自定义 Gradle 配置等），需要：
1. 先备份这些配置
2. 删除 `android/` 目录
3. 运行 `flutter pub get` 生成 `.android/`
4. 将自定义配置重新应用到 `.android/` 目录

### 3. 依赖兼容性

确保所有依赖都兼容模块项目：
- 某些插件可能不支持模块项目
- 需要测试所有功能是否正常

### 4. 版本控制

转换后，建议：
- 提交所有改动到 Git
- 添加 `.android/` 到 `.gitignore`（自动生成，不需要版本控制）
- 添加 `.ios/` 到 `.gitignore`（自动生成，不需要版本控制）

---

## 🔄 回退方法

如果转换后出现问题，可以回退：

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking

# 1. 恢复 .metadata
# 将 project_type: module 改回 project_type: app

# 2. 恢复 pubspec.yaml
# 删除 module: 配置块

# 3. 恢复 android 目录（如果有备份）
# cp -r android_backup android

# 4. 运行 flutter pub get
flutter pub get
```

---

## 📚 相关文档

- [Android 原生项目集成指南](../../flutter_module_android/android_simple/原生项目怎么集成flutter模块.md)
- [iOS 原生项目集成指南](../../flutter_module_android/ios_simple/原生项目怎么集成flutter模块.md)
- [Flutter 官方文档：Add Flutter to existing apps](https://docs.flutter.cn/add-to-app/)

---

## 🎯 快速转换脚本

可以创建一个脚本自动化转换过程：

```bash
#!/bin/bash
# convert_to_module.sh

cd /Users/shawn/Desktop/coding/04-resto/rs-booking

echo "开始转换 rs-booking 为 Flutter Module..."

# 1. 修改 .metadata
sed -i '' 's/project_type: app/project_type: module/' .metadata

# 2. 检查 pubspec.yaml 是否已有 module 配置
if ! grep -q "module:" pubspec.yaml; then
    echo "需要在 pubspec.yaml 中添加 module 配置"
    echo "请手动添加以下内容到 flutter: 块中："
    echo "  module:"
    echo "    androidX: true"
    echo "    androidPackage: ai.restosuite.inc.tables"
    echo "    iosBundleIdentifier: ai.restosuite.inc.tables"
fi

# 3. 备份并删除 android 目录
if [ -d "android" ]; then
    echo "备份 android 目录..."
    cp -r android android_backup_$(date +%Y%m%d_%H%M%S)
    echo "删除 android 目录..."
    rm -rf android
fi

# 4. 运行 flutter pub get
echo "运行 flutter pub get..."
flutter pub get

echo "✅ 转换完成！"
echo ""
echo "下一步："
echo "1. 检查 pubspec.yaml 中的 module 配置"
echo "2. 运行 flutter build aar 测试构建"
```

---

**文档版本：** 1.0  
**最后更新：** 2025-11-29  
**适用项目：** rs-booking

