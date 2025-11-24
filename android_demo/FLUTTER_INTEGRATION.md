# Flutter Module 集成说明

## 已完成的配置

### 1. AAR 文件配置

**直接使用 AAR 文件**，已复制到 `app/libs/` 目录：
- `flutter_debug.aar` (16MB)
- `flutter_profile.aar` (6.1MB)
- `flutter_release.aar` (3.8MB)

### 2. Flutter 依赖配置

在 `app/build.gradle` 中直接引用 AAR 文件：

```gradle
dependencies {
    // Flutter Module依赖 - 直接使用AAR文件
    debugImplementation files('libs/flutter_debug.aar')
    profileImplementation files('libs/flutter_profile.aar')
    releaseImplementation files('libs/flutter_release.aar')
}
```

### 3. Maven 仓库配置

在 `settings.gradle` 中保留了 Flutter 引擎的 Maven 仓库（AAR 需要 Flutter 引擎依赖）：

```gradle
repositories {
    maven {
        String storageUrl = System.env.FLUTTER_STORAGE_BASE_URL ?: "https://storage.googleapis.com"
        url "$storageUrl/download.flutter.io"
    }
}
```

### 3. Build Types 配置

添加了 `profile` build type：

```gradle
buildTypes {
    profile {
        initWith debug
    }
}
```

### 4. 首页列表功能

在 `HomeFragment` 中添加了列表，点击 "Flutter 页面" 可以跳转到 Flutter Module。

## 使用方法

### 1. 构建 Flutter AAR

```bash
cd ../flutter_module_demo
flutter build aar
```

### 2. 复制 AAR 文件到项目

有两种方式：

**方式1: 使用脚本（推荐）**
```bash
cd android_demo
./copy_aar.sh
```

**方式2: 手动复制**
```bash
# 从 flutter_module_demo 复制 AAR 文件到 android_demo/app/libs/
cp ../flutter_module_demo/build/host/outputs/repo/com/example/flutter_module_demo/flutter_debug/1.0/flutter_debug-1.0.aar app/libs/flutter_debug.aar
cp ../flutter_module_demo/build/host/outputs/repo/com/example/flutter_module_demo/flutter_profile/1.0/flutter_profile-1.0.aar app/libs/flutter_profile.aar
cp ../flutter_module_demo/build/host/outputs/repo/com/example/flutter_module_demo/flutter_release/1.0/flutter_release-1.0.aar app/libs/flutter_release.aar
```

### 3. 同步项目

在 Android Studio 中点击 "Sync Project with Gradle Files"

### 4. 运行应用

1. 运行 Android 应用
2. 在首页会看到一个列表
3. 点击 "Flutter 页面" 列表项
4. 会跳转到 Flutter Module 页面

## 代码说明

### HomeFragment.kt

- 使用 `RecyclerView` 显示列表
- 点击列表项时，使用 `FlutterActivity.withNewEngine()` 启动 Flutter 页面
- 可以轻松添加更多列表项

### 启动 Flutter 页面的代码

```kotlin
startActivity(
    FlutterActivity
        .withNewEngine()
        .initialRoute("/")
        .build(requireContext())
)
```

## 自定义路由

如果需要跳转到 Flutter 的特定路由，可以修改 `initialRoute`：

```kotlin
FlutterActivity
    .withNewEngine()
    .initialRoute("/your-route")  // 修改这里
    .build(requireContext())
```

## 性能优化（可选）

如果需要更好的性能，可以使用缓存的 Flutter Engine：

```kotlin
// 在 Application 或 Activity 中初始化
val flutterEngine = FlutterEngine(context).apply {
    dartExecutor.executeDartEntrypoint(
        DartExecutor.DartEntrypoint.createDefault()
    )
    FlutterEngineCache.getInstance().put("my_engine_id", this)
}

// 使用时
startActivity(
    FlutterActivity
        .withCachedEngine("my_engine_id")
        .build(context)
)
```

## 故障排除

### 问题1: 找不到 AAR 文件

**解决方案**: 确保已运行 `flutter build aar` 并且路径正确

### 问题2: 依赖同步失败

**解决方案**: 
1. 检查 `settings.gradle` 中的路径是否正确
2. 确保 `flutter_module_demo/build/host/outputs/repo` 目录存在
3. 清理并重新同步：`./gradlew clean` 然后重新同步

### 问题3: 运行时崩溃

**解决方案**:
1. 检查 Flutter Module 是否已正确构建
2. 查看 Logcat 中的错误信息
3. 确保 minSdkVersion 兼容（当前设置为 24）

