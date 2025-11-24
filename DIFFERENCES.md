# Flutter App vs Module 核心差异对比

## 快速对比表

| 项目 | flutter_demo (App) | flutter_module_demo (Module) |
|------|-------------------|------------------------------|
| **项目类型** | `project_type: app` | `project_type: module` |
| **Android目录** | `android/` (可见) | `.android/` (隐藏，自动生成) |
| **构建插件** | `com.android.application` | `com.android.library` |
| **applicationId** | ✅ 有 | ❌ 无（库模块不支持） |
| **versionCode/Name** | ✅ 有 | ❌ 无（库模块不支持） |
| **构建命令** | `flutter build apk` | `flutter build aar` |
| **输出文件** | APK文件 | AAR文件（Maven仓库格式） |
| **独立运行** | ✅ 可以 | ⚠️ 通过示例应用 |
| **集成方式** | 直接安装 | 嵌入到原生应用 |

## 文件差异清单

### 1. .metadata 文件

**App项目:**
```yaml
project_type: app
# 包含完整的migration信息
```

**Module项目:**
```yaml
project_type: module
# 没有migration信息
```

### 2. pubspec.yaml

**App项目:**
```yaml
name: flutter_demo
description: "A new Flutter project."
# 没有module配置
```

**Module项目:**
```yaml
name: flutter_module_demo
description: "A new Flutter module project."

flutter:
  module:                    # ← 关键差异
    androidX: true
    androidPackage: com.example.flutter_module_demo
    iosBundleIdentifier: com.example.flutterModuleDemo
```

### 3. Android构建配置

**App项目 (android/app/build.gradle.kts):**
```kotlin
plugins {
    id("com.android.application")  // ← application
}

defaultConfig {
    applicationId = "com.example.flutter_demo"  // ← 有applicationId
    versionCode = flutter.versionCode
    versionName = flutter.versionName
}
```

**Module项目 (.android/build.gradle):**
```groovy
apply plugin: "com.android.library"  // ← library

defaultConfig {
    minSdk = 24
    targetSdk = 36
    // ← 没有applicationId
    // ← 没有versionCode/versionName
}
```

### 4. 目录结构

**App项目:**
```
flutter_demo/
├── android/          # 可见目录
├── ios/              # 完整iOS配置
├── web/              # Web配置
├── macos/            # macOS配置
├── windows/          # Windows配置
└── linux/            # Linux配置
```

**Module项目:**
```
flutter_module_demo/
├── .android/         # 隐藏目录（自动生成）
│   ├── Flutter/      # Flutter引擎
│   ├── app/          # 示例应用
│   └── include_flutter.groovy
└── build/host/outputs/repo/  # AAR输出目录
```

## 转换检查清单

将App转换为Module需要：

- [ ] 修改 `.metadata` 中的 `project_type: module`
- [ ] 在 `pubspec.yaml` 的 `flutter:` 块中添加 `module:` 配置
- [ ] 删除 `android/` 目录（运行 `flutter pub get` 会自动生成 `.android/`）
- [ ] 更新构建命令：`flutter build aar` 而不是 `flutter build apk`
- [ ] 更新文档说明这是Module项目

## 关键命令对比

| 操作 | App项目 | Module项目 |
|------|---------|-----------|
| **创建项目** | `flutter create app_name` | `flutter create --template=module module_name` |
| **构建** | `flutter build apk` | `flutter build aar` |
| **运行** | `flutter run` | `flutter run` (使用示例应用) |
| **集成** | 直接安装APK | 在原生项目中添加依赖 |

## 使用场景

### 使用 App 项目当：
- ✅ 开发独立的Flutter应用
- ✅ 需要直接发布到应用商店
- ✅ 不需要集成到现有原生应用

### 使用 Module 项目当：
- ✅ 需要将Flutter嵌入到现有Android/iOS应用
- ✅ 需要以AAR/Framework形式提供给其他团队
- ✅ 渐进式迁移原生应用到Flutter

