# Flutter Module Demo

这是一个 Flutter Module 项目，可以打包成 AAR 文件供 Android 原生项目使用。

## 快速开始

### 构建 AAR

```bash
# 构建所有版本（Debug, Profile, Release）
flutter build aar

# 或单独构建
flutter build aar --release
flutter build aar --debug
flutter build aar --profile
```

### AAR 文件位置

构建完成后，AAR 文件位于：
```
build/host/outputs/repo/com/example/flutter_module_demo/
├── flutter_debug/1.0/flutter_debug-1.0.aar
├── flutter_profile/1.0/flutter_profile-1.0.aar
└── flutter_release/1.0/flutter_release-1.0.aar
```

## 在 Android 项目中使用

### 1. 配置 Maven 仓库

在 Android 项目的 `settings.gradle` 或根 `build.gradle` 中添加：

```gradle
String storageUrl = System.env.FLUTTER_STORAGE_BASE_URL ?: "https://storage.googleapis.com"

repositories {
    maven {
        url '/Users/shawn/Desktop/coding/04-resto/flutter_module_android/flutter_module_demo/build/host/outputs/repo'
    }
    maven {
        url "$storageUrl/download.flutter.io"
    }
}
```

### 2. 添加依赖

在 `app/build.gradle` 中添加：

```gradle
dependencies {
    debugImplementation 'com.example.flutter_module_demo:flutter_debug:1.0'
    profileImplementation 'com.example.flutter_module_demo:flutter_profile:1.0'
    releaseImplementation 'com.example.flutter_module_demo:flutter_release:1.0'
}
```

### 3. 添加 Profile Build Type（可选）

在 `app/build.gradle` 的 `android` 块中添加：

```gradle
android {
    buildTypes {
        profile {
            initWith debug
        }
    }
}
```

### 4. 在代码中使用

```kotlin
import io.flutter.embedding.android.FlutterActivity

// 启动 Flutter 页面
startActivity(
    FlutterActivity
        .withNewEngine()
        .initialRoute("/")
        .build(this)
)
```

## 项目结构

- `lib/main.dart` - Flutter 代码入口
- `build/host/outputs/repo/` - 构建输出的 AAR 文件

## 更多信息

详细的使用说明请参考 `../flutter_demo/BUILD_AAR.md`
