# Flutter App 转 Module 完整指南

本文档详细说明如何将 `flutter_demo`（Flutter应用项目）转换为 `flutter_module_demo`（Flutter Module项目）。

## 核心差异对比

### 1. 项目类型标识

**flutter_demo (.metadata)**
```yaml
project_type: app
```

**flutter_module_demo (.metadata)**
```yaml
project_type: module
```

### 2. pubspec.yaml 差异

**flutter_demo (应用项目)**
```yaml
name: flutter_demo
description: "A new Flutter project."
publish_to: 'none'
```

**flutter_module_demo (Module项目)**
```yaml
name: flutter_module_demo
description: "A new Flutter module project."

# 关键差异：添加了 module 配置块
flutter:
  module:
    androidX: true
    androidPackage: com.example.flutter_module_demo
    iosBundleIdentifier: com.example.flutterModuleDemo
```

### 3. Android 目录结构差异

**flutter_demo (应用项目)**
```
flutter_demo/
├── android/                    # 可见的android目录
│   ├── app/
│   │   ├── build.gradle.kts   # application插件
│   │   └── src/main/
│   ├── build.gradle.kts
│   └── settings.gradle.kts
```

**flutter_module_demo (Module项目)**
```
flutter_module_demo/
├── .android/                   # 隐藏的.android目录（自动生成）
│   ├── Flutter/               # Flutter引擎模块
│   ├── app/                   # 示例应用（可选）
│   ├── build.gradle           # library插件
│   ├── settings.gradle        # 使用Groovy语法
│   └── include_flutter.groovy # Flutter模块包含脚本
```

### 4. Android 构建配置差异

**flutter_demo/android/app/build.gradle.kts**
```kotlin
plugins {
    id("com.android.application")  // 应用插件
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    defaultConfig {
        applicationId = "com.example.flutter_demo"  // 有applicationId
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}
```

**flutter_module_demo/.android/build.gradle**
```groovy
apply plugin: "com.android.library"  // 库插件
apply plugin: "kotlin-android"

android {
    namespace = "com.example.flutter_module_demo"
    compileSdk = 36
    defaultConfig {
        minSdk = 24
        targetSdk = 36
        // 没有applicationId
        // 没有versionCode/versionName（库模块不支持）
    }
}
```

### 5. 平台目录差异

**flutter_demo (应用项目)**
- 包含完整的平台目录：`android/`, `ios/`, `web/`, `macos/`, `windows/`, `linux/`
- 每个平台都有完整的运行配置

**flutter_module_demo (Module项目)**
- 只有 `.android/` 隐藏目录（自动生成）
- 没有其他平台目录（因为Module是嵌入到原生应用的）
- 可以通过 `flutter run` 运行，但会使用 `.android/` 中的示例应用

## 手动转换步骤

### 方法1: 使用 Flutter 命令（推荐）

这是最简单的方法，但会创建新项目：

```bash
# 1. 创建新的Flutter Module项目
flutter create --template=module flutter_module_demo

# 2. 复制你的代码
cp flutter_demo/lib/* flutter_module_demo/lib/

# 3. 复制依赖配置（如果需要）
# 编辑 flutter_module_demo/pubspec.yaml，添加你的依赖

# 4. 构建AAR
cd flutter_module_demo
flutter build aar
```

### 方法2: 手动修改现有项目

如果你想在现有项目上修改，需要做以下改动：

#### 步骤1: 修改 .metadata 文件

```yaml
# 将 project_type 从 app 改为 module
project_type: module

# 删除 migration 部分（Module项目不需要）
```

#### 步骤2: 修改 pubspec.yaml

在 `flutter:` 块中添加 `module` 配置：

```yaml
flutter:
  uses-material-design: true
  
  # 添加这个模块配置块
  module:
    androidX: true
    androidPackage: com.example.flutter_demo  # 改为你的包名
    iosBundleIdentifier: com.example.flutterDemo  # iOS包名
```

#### 步骤3: 删除或重命名 android 目录

```bash
# 删除旧的android目录（Flutter会自动生成.android）
rm -rf android
```

#### 步骤4: 运行 flutter pub get

```bash
flutter pub get
```

这会自动生成 `.android/` 目录和所有必要的配置文件。

#### 步骤5: 验证转换

```bash
# 检查项目类型
flutter doctor

# 尝试构建AAR
flutter build aar
```

## 关键文件说明

### include_flutter.groovy

这是Flutter Module的核心文件，用于：
- 包含Flutter引擎模块
- 配置Flutter SDK路径
- 加载Flutter插件

**位置**: `.android/include_flutter.groovy`

### .android/settings.gradle

Module项目的settings.gradle使用Groovy语法（不是Kotlin DSL），并且：
- 包含 `include_flutter.groovy` 脚本
- 自动配置Flutter模块

### .android/build.gradle

Module项目的根build.gradle：
- 使用 `com.android.library` 插件（不是application）
- 没有applicationId
- 没有versionCode/versionName（库模块不支持）

## 构建AAR

转换完成后，使用以下命令构建AAR：

```bash
# 构建所有版本
flutter build aar

# 构建特定版本
flutter build aar --release
flutter build aar --debug
flutter build aar --profile
```

AAR文件会生成在：
```
build/host/outputs/repo/com/example/flutter_module_demo/
├── flutter_debug/1.0/flutter_debug-1.0.aar
├── flutter_profile/1.0/flutter_profile-1.0.aar
└── flutter_release/1.0/flutter_release-1.0.aar
```

## 注意事项

1. **不要手动编辑 .android/ 目录下的文件**
   - 这些文件是自动生成的
   - 修改后运行 `flutter pub get` 会被覆盖

2. **Module项目不能直接运行**
   - 需要通过原生应用启动
   - 或者使用 `.android/` 中的示例应用

3. **依赖管理**
   - pubspec.yaml 中的依赖配置保持不变
   - Flutter会自动处理依赖的AAR打包

4. **资源文件**
   - assets配置在pubspec.yaml中保持不变
   - Flutter会自动打包到AAR中

5. **插件支持**
   - Flutter插件会自动包含在AAR中
   - 原生Android项目需要添加相应的依赖

## 常见问题

### Q: 转换后还能独立运行吗？
A: 可以，使用 `flutter run` 会使用 `.android/` 中的示例应用运行。

### Q: 如何测试Module？
A: 
1. 构建AAR: `flutter build aar`
2. 在原生Android项目中集成
3. 或者使用 `flutter run` 运行示例应用

### Q: 转换后需要修改代码吗？
A: 通常不需要，Flutter代码保持不变。只需要确保路由和初始化逻辑适合嵌入到原生应用。

### Q: 如何回退到应用项目？
A: 
1. 修改 `.metadata` 中的 `project_type: app`
2. 删除 `pubspec.yaml` 中的 `module:` 配置块
3. 运行 `flutter create .` 重新生成平台目录

## 总结

主要改动点：
1. ✅ `.metadata` 中 `project_type: module`
2. ✅ `pubspec.yaml` 中添加 `module:` 配置块
3. ✅ 删除 `android/` 目录（自动生成 `.android/`）
4. ✅ 使用 `flutter build aar` 构建（不是 `flutter build apk`）

最简单的方法：使用 `flutter create --template=module` 创建新项目，然后复制代码。

