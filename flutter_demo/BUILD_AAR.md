# Flutter Module AAR 构建指南

## 重要说明

**flutter_demo 项目已配置为可以构建 AAR，但推荐使用 `flutter_module_demo` 项目来构建 AAR。**

Flutter Module 是专门为集成到原生应用而设计的项目类型，使用 `flutter build aar` 命令可以更方便地构建和发布 AAR。

## 方法1: 使用 Flutter Module 项目（推荐）

### 步骤1: 使用 flutter_module_demo 项目

项目位置：`flutter_module_demo/`

### 步骤2: 构建 AAR

```bash
cd flutter_module_demo

# 构建所有版本（Debug, Profile, Release）
flutter build aar

# 或者单独构建
flutter build aar --release
flutter build aar --debug
flutter build aar --profile
```

### 步骤3: AAR 文件位置

构建完成后，AAR 文件会生成在：
```
flutter_module_demo/build/host/outputs/repo/
```

### 步骤4: 在 Android 项目中使用

#### 4.1 配置 Maven 仓库

在 Android 项目的 `settings.gradle` 或 `build.gradle` 中添加：

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

#### 4.2 添加依赖

在 `app/build.gradle` 中添加：

```gradle
dependencies {
    debugImplementation 'com.example.flutter_module_demo:flutter_debug:1.0'
    profileImplementation 'com.example.flutter_module_demo:flutter_profile:1.0'
    releaseImplementation 'com.example.flutter_module_demo:flutter_release:1.0'
}
```

#### 4.3 添加 Profile Build Type（如果需要）

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

## 方法2: 使用 flutter_demo 项目（需要手动配置）

### 步骤1: 恢复为 Application 配置

由于 Flutter 插件对 library 模块的支持有限，建议保持 `flutter_demo` 为应用项目，或使用上面的 Module 方法。

### 步骤2: 使用 Gradle 构建（如果已配置为 library）

```bash
cd flutter_demo/android
./gradlew :app:assembleRelease
```

AAR 文件会在：`android/app/build/outputs/aar/app-release.aar`

## 在 Android 代码中使用 Flutter Module

### 启动 Flutter 页面

```kotlin
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 启动 Flutter 页面
        startActivity(
            FlutterActivity
                .withNewEngine()
                .initialRoute("/")
                .build(this)
        )
    }
}
```

### 使用缓存的 Flutter Engine（推荐用于性能优化）

```kotlin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity : AppCompatActivity() {
    private val flutterEngine: FlutterEngine by lazy {
        FlutterEngine(this).apply {
            dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            FlutterEngineCache.getInstance().put("my_engine_id", this)
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 使用缓存的 Engine
        startActivity(
            FlutterActivity
                .withCachedEngine("my_engine_id")
                .build(this)
        )
    }
    
    override fun onDestroy() {
        super.onDestroy()
        flutterEngine.destroy()
    }
}
```

## 项目结构说明

- **flutter_demo/**: 原始 Flutter 应用项目（可独立运行）
- **flutter_module_demo/**: Flutter Module 项目（用于构建 AAR，集成到原生应用）

## 常见问题

### Q: 如何将现有 Flutter 应用转换为 Module？
A: 使用命令 `flutter create --template=module .`，但注意这会改变项目结构。推荐创建新的 Module 项目并复制代码。

### Q: AAR 文件太大怎么办？
A: 使用 `flutter build aar --split-per-abi` 来按 ABI 拆分 AAR，减小单个文件大小。

### Q: 如何查看 AAR 内容？
A: AAR 文件实际上是一个 ZIP 文件，可以使用解压工具查看，或使用 Android Studio 的 Archive Viewer。

### Q: 构建失败怎么办？
A: 
1. 确保 Flutter SDK 已正确安装
2. 运行 `flutter doctor` 检查环境
3. 清理构建：`flutter clean` 然后重新构建
4. 检查 `android/local.properties` 中的 `flutter.sdk` 路径是否正确

## 参考文档

- [Flutter 官方文档 - 集成 Android Archive](https://flutter.dev/to/integrate-android-archive)
- [Flutter 官方文档 - 添加 Flutter 到现有应用](https://docs.flutter.dev/development/add-to-app)
