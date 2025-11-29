# 原生 Android 项目集成 Flutter 模块完整指南

## 📋 目录

1. [项目概述](#项目概述)
2. [前置条件](#前置条件)
3. [集成步骤概览](#集成步骤概览)
4. [详细文件修改说明](#详细文件修改说明)
5. [完整操作流程](#完整操作流程)
6. [常见问题](#常见问题)

---

## 项目概述

`android_simple` 是一个**原生 Android 项目**，用于演示如何将 Flutter 模块（`rs-booking`）集成到原生 Android 应用中。

### 项目结构

```
android_simple/
├── app/
│   ├── libs/                    # Flutter AAR 文件存放目录
│   │   ├── flutter_debug.aar
│   │   ├── flutter_profile.aar
│   │   └── flutter_release.aar
│   ├── build.gradle             # ⚠️ 需要修改：添加 Flutter 依赖
│   └── src/main/
│       ├── AndroidManifest.xml  # ⚠️ 需要修改：添加 Flutter Activity
│       └── java/com/simple/app/
│           └── MainActivity.kt  # ⚠️ 需要修改：添加启动 Flutter 的代码
├── settings.gradle              # ⚠️ 需要修改：添加 Maven 仓库
├── build.gradle                 # 根级构建文件（无需修改）
└── copy_aar.sh                  # 辅助脚本：构建并复制 AAR 文件
```

---

## 前置条件

### 1. Flutter 模块准备

确保 Flutter 模块已配置为 Module 类型：

**检查 `rs-booking/pubspec.yaml`：**

```yaml
flutter:
  module:
    androidX: true
    androidPackage: ai.restosuite.inc.tables
    iosBundleIdentifier: ai.restosuite.inc.tables
```

**检查 `rs-booking/.metadata`：**

```yaml
project_type: module
```

### 2. 构建 Flutter AAR

```bash
cd /path/to/rs-booking
flutter build aar
```

构建完成后，AAR 文件会生成在：
```
rs-booking/build/host/outputs/repo/ai/restosuite/inc/tables/
├── flutter_debug/1.0/flutter_debug-1.0.aar
├── flutter_profile/1.0/flutter_profile-1.0.aar
└── flutter_release/1.0/flutter_release-1.0.aar
```

---

## 集成步骤概览

1. ✅ **修改 `settings.gradle`** - 添加 Maven 仓库配置
2. ✅ **修改 `app/build.gradle`** - 添加 Flutter 依赖和 Profile 构建类型
3. ✅ **修改 `AndroidManifest.xml`** - 注册 Flutter Activity
4. ✅ **修改 `MainActivity.kt`** - 添加启动 Flutter 的代码
5. ✅ **复制 AAR 文件** - 使用脚本或手动复制

---

## 详细文件修改说明

### 1. 修改 `settings.gradle`

**文件路径：** `android_simple/settings.gradle`

**修改内容：**

```gradle
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        
        // ⭐ 新增：Flutter Module 的 Maven 本地仓库
        // 这个仓库包含了 Flutter 模块的 AAR 文件和依赖信息
        maven {
            url '../../rs-booking/build/host/outputs/repo'
        }
        
        // ⭐ 新增：Flutter 引擎仓库
        // Flutter AAR 需要依赖 Flutter 引擎，这个仓库提供引擎下载
        maven {
            String storageUrl = System.env.FLUTTER_STORAGE_BASE_URL ?: "https://storage.googleapis.com"
            url "$storageUrl/download.flutter.io"
        }
        
        // ⭐ 新增：自定义 Maven 仓库（如果需要）
        // 某些 Flutter 插件可能需要自定义仓库
        maven {
            url 'https://pub.restosuite.cn/'
        }
    }
}
```

**改动目的：**
- 让 Gradle 能够找到 Flutter 模块的 AAR 文件
- 让 Gradle 能够下载 Flutter 引擎依赖
- 支持自定义插件的 Maven 仓库

**关键点：**
- `url '../../rs-booking/build/host/outputs/repo'` 是 Flutter AAR 的本地 Maven 仓库路径
- Flutter 引擎仓库是必需的，因为 AAR 依赖 Flutter 引擎

---

### 2. 修改 `app/build.gradle`

**文件路径：** `android_simple/app/build.gradle`

#### 2.1 添加 Profile 构建类型

**修改内容：**

```gradle
android {
    // ... 其他配置 ...
    
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            minifyEnabled false
        }
        // ⭐ 新增：Profile 构建类型
        // Flutter 有三种构建模式：Debug、Profile、Release
        // Profile 模式用于性能分析，介于 Debug 和 Release 之间
        profile {
            initWith debug
        }
    }
}
```

**改动目的：**
- Flutter 模块支持三种构建模式：Debug、Profile、Release
- Profile 模式用于性能分析，需要单独配置

#### 2.2 添加 Flutter 依赖

**修改内容：**

```gradle
dependencies {
    // ... 其他依赖 ...
    
    // ⭐ 新增：Flutter Module 依赖
    // 使用 Maven 本地仓库中的 AAR 文件
    // 注意：groupId 和 artifactId 来自 Flutter 模块的 pubspec.yaml 配置
    
    // Debug 版本
    debugImplementation('ai.restosuite.inc.tables:flutter_debug:1.0') {
        // 排除冲突的依赖（根据实际情况调整）
        exclude group: 'com.example.r_upgrade', module: 'r_upgrade_lib'
    }
    
    // Profile 版本
    profileImplementation('ai.restosuite.inc.tables:flutter_profile:1.0') {
        exclude group: 'com.example.r_upgrade', module: 'r_upgrade_lib'
    }
    
    // Release 版本
    releaseImplementation('ai.restosuite.inc.tables:flutter_release:1.0') {
        exclude group: 'com.example.r_upgrade', module: 'r_upgrade_lib'
    }
}
```

**改动目的：**
- 引入 Flutter 模块的 AAR 文件
- 根据构建类型（Debug/Profile/Release）使用对应的 AAR
- 排除可能冲突的依赖

**关键点：**
- `ai.restosuite.inc.tables` 是 `groupId`，来自 `pubspec.yaml` 中的 `androidPackage`
- `flutter_debug`、`flutter_profile`、`flutter_release` 是 `artifactId`
- `1.0` 是版本号
- `exclude` 用于排除冲突的依赖（根据实际情况调整）

---

### 3. 修改 `AndroidManifest.xml`

**文件路径：** `android_simple/app/src/main/AndroidManifest.xml`

**修改内容：**

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- ⭐ 新增：网络权限（Flutter 可能需要） -->
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.SimpleApp">
        
        <!-- 原有的 MainActivity -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/Theme.SimpleApp">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
        <!-- ⭐ 新增：Flutter Activity -->
        <!-- 这是 Flutter 提供的 Activity，用于显示 Flutter 页面 -->
        <activity
            android:name="io.flutter.embedding.android.FlutterActivity"
            android:exported="true"
            android:theme="@style/Theme.SimpleApp"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize" />
        
        <!-- ⭐ 新增：Flutter 嵌入配置 -->
        <!-- 指定使用 Flutter Embedding V2（推荐） -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>

</manifest>
```

**改动目的：**
- 注册 Flutter Activity，用于显示 Flutter 页面
- 启用硬件加速，提升 Flutter 性能
- 配置软键盘处理方式
- 指定使用 Flutter Embedding V2

**关键点：**
- `io.flutter.embedding.android.FlutterActivity` 是 Flutter 提供的标准 Activity
- `android:hardwareAccelerated="true"` 启用硬件加速（Flutter 推荐）
- `android:windowSoftInputMode="adjustResize"` 处理软键盘
- `flutterEmbedding` 值为 `2` 表示使用 V2 嵌入方式（推荐）

---

### 4. 修改 `MainActivity.kt`

**文件路径：** `android_simple/app/src/main/java/com/simple/app/MainActivity.kt`

**修改内容：**

```kotlin
package com.simple.app

import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
// ⭐ 新增：导入 Flutter Activity
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val btnOpenFlutter = findViewById<Button>(R.id.btnOpenFlutter)
        btnOpenFlutter.setOnClickListener {
            // ⭐ 新增：启动 Flutter 页面
            startActivity(
                FlutterActivity
                    .withNewEngine()              // 使用新的 Flutter 引擎
                    .initialRoute("/")            // 设置初始路由（可选）
                    .build(this)                  // 构建 Intent
            )
        }
    }
}
```

**改动目的：**
- 在原生页面中添加按钮，点击后跳转到 Flutter 页面
- 演示如何启动 Flutter Activity

**关键点：**
- `FlutterActivity.withNewEngine()` 创建一个新的 Flutter 引擎（每次启动都是新实例）
- `initialRoute("/")` 设置 Flutter 的初始路由，对应 Flutter 中的路由路径
- 也可以使用 `withCachedEngine("engine_id")` 使用缓存的引擎（性能更好）

**高级用法：**

```kotlin
// 使用缓存的引擎（推荐用于生产环境）
val cachedEngine = FlutterEngineCache.getInstance().get("my_engine_id")
if (cachedEngine == null) {
    // 创建并缓存引擎
    val engine = FlutterEngine(this)
    engine.dartExecutor.executeDartEntrypoint(
        DartExecutor.DartEntrypoint.createDefault()
    )
    FlutterEngineCache.getInstance().put("my_engine_id", engine)
}

startActivity(
    FlutterActivity
        .withCachedEngine("my_engine_id")
        .build(this)
)
```

---

### 5. 复制 AAR 文件（可选）

**方式 1：使用脚本（推荐）**

```bash
cd android_simple
./copy_aar.sh
```

脚本会自动：
1. 构建 Flutter AAR（如果还没构建）
2. 复制 AAR 文件到 `app/libs/` 目录

**方式 2：手动复制**

```bash
# 1. 构建 Flutter AAR
cd /path/to/rs-booking
flutter build aar

# 2. 复制 AAR 文件
cp rs-booking/build/host/outputs/repo/ai/restosuite/inc/tables/flutter_debug/1.0/flutter_debug-1.0.aar \
   android_simple/app/libs/flutter_debug.aar

cp rs-booking/build/host/outputs/repo/ai/restosuite/inc/tables/flutter_profile/1.0/flutter_profile-1.0.aar \
   android_simple/app/libs/flutter_profile.aar

cp rs-booking/build/host/outputs/repo/ai/restosuite/inc/tables/flutter_release/1.0/flutter_release-1.0.aar \
   android_simple/app/libs/flutter_release.aar
```

**注意：** 
- 如果使用 Maven 本地仓库（在 `settings.gradle` 中配置），**不需要**手动复制 AAR 到 `libs` 目录
- Gradle 会自动从 Maven 仓库中下载 AAR 文件

---

## 完整操作流程

### 步骤 1：准备 Flutter 模块

```bash
# 1. 确保 Flutter 模块已配置为 Module 类型
cd /path/to/rs-booking
cat pubspec.yaml | grep -A 3 "module:"

# 2. 构建 Flutter AAR
flutter build aar
```

### 步骤 2：修改 Android 项目配置

按照上面的说明修改以下文件：
1. `settings.gradle` - 添加 Maven 仓库
2. `app/build.gradle` - 添加依赖和 Profile 构建类型
3. `app/src/main/AndroidManifest.xml` - 注册 Flutter Activity
4. `app/src/main/java/com/simple/app/MainActivity.kt` - 添加启动代码

### 步骤 3：同步项目

在 Android Studio 中：
1. 点击 "Sync Project with Gradle Files" 按钮
2. 等待同步完成

### 步骤 4：运行项目

1. 连接 Android 设备或启动模拟器
2. 点击 "Run" 按钮
3. 在应用中点击按钮，应该能看到 Flutter 页面

---

## 常见问题

### Q1: 同步失败，找不到 Flutter AAR

**原因：** Maven 仓库路径不正确或 AAR 未构建

**解决方案：**
1. 检查 `settings.gradle` 中的路径是否正确
2. 确保已运行 `flutter build aar`
3. 检查 AAR 文件是否存在：
   ```bash
   ls -la rs-booking/build/host/outputs/repo/ai/restosuite/inc/tables/
   ```

### Q2: 依赖冲突错误

**原因：** Flutter 模块的依赖与原生项目的依赖冲突

**解决方案：**
在 `app/build.gradle` 中使用 `exclude` 排除冲突的依赖：
```gradle
debugImplementation('ai.restosuite.inc.tables:flutter_debug:1.0') {
    exclude group: '冲突的groupId', module: '冲突的module'
}
```

### Q3: Flutter 页面白屏

**原因：** Flutter 引擎未正确初始化或路由错误

**解决方案：**
1. 检查 `initialRoute` 是否正确
2. 查看 Logcat 中的错误信息
3. 确保 Flutter 模块的入口文件正确

### Q4: 性能问题

**原因：** 每次启动都创建新的 Flutter 引擎

**解决方案：**
使用缓存的引擎（参考上面的高级用法）

### Q5: 如何自定义 Flutter 页面

**方式 1：使用自定义路由**

```kotlin
FlutterActivity
    .withNewEngine()
    .initialRoute("/custom-page")  // 自定义路由
    .build(this)
```

**方式 2：创建自定义 Flutter Activity**

```kotlin
class MyFlutterActivity : FlutterActivity() {
    override fun getInitialRoute(): String {
        return "/custom-page"
    }
}
```

---

## 总结

集成 Flutter 模块到原生 Android 项目需要修改以下文件：

| 文件 | 修改内容 | 目的 |
|------|---------|------|
| `settings.gradle` | 添加 Maven 仓库 | 让 Gradle 能找到 Flutter AAR |
| `app/build.gradle` | 添加依赖和 Profile 构建类型 | 引入 Flutter 模块 |
| `AndroidManifest.xml` | 注册 Flutter Activity | 允许启动 Flutter 页面 |
| `MainActivity.kt` | 添加启动代码 | 实现跳转到 Flutter 页面 |

**核心原理：**
1. Flutter 模块通过 `flutter build aar` 打包成 AAR 文件
2. AAR 文件发布到本地 Maven 仓库
3. Android 项目通过 Gradle 依赖引入 AAR
4. 使用 `FlutterActivity` 启动 Flutter 页面

---

## 参考资料

- [Flutter 官方文档：将 Flutter 添加到现有应用](https://docs.flutter.cn/add-to-app/)
- [Flutter Embedding V2](https://docs.flutter.cn/add-to-app/android/add-flutter-screen/)

---

**文档版本：** 1.0  
**最后更新：** 2025-11-29  
**维护者：** Android 开发团队

