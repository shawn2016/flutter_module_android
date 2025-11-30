# 原生 iOS 项目集成 Flutter 模块完整指南

## 📋 目录

1. [项目概述](#项目概述)
2. [前置条件](#前置条件)
3. [集成步骤概览](#集成步骤概览)
4. [详细文件修改说明](#详细文件修改说明)
5. [完整操作流程](#完整操作流程)
6. [常见问题](#常见问题)

---

## 项目概述

`ios_simple` 是一个**原生 iOS 项目**（使用 SwiftUI），用于演示如何将 Flutter 模块（`rs-booking`）集成到原生 iOS 应用中。

### 项目结构

```
ios_simple/
├── Podfile                          # ⚠️ 需要修改：配置 Flutter 模块依赖
├── ios_simple/
│   ├── ios_simpleApp.swift          # ⚠️ 需要修改：连接 AppDelegate
│   ├── AppDelegate.swift            # ⚠️ 需要新建：初始化 FlutterEngine
│   ├── FlutterManager.swift         # ⚠️ 需要新建：管理 Flutter 视图
│   ├── HomeView.swift               # ⚠️ 需要修改：添加跳转到 Flutter 的代码
│   └── ios_simple.entitlements      # ⚠️ 需要检查：确保没有 macOS 沙盒设置
├── Pods/                            # CocoaPods 依赖（自动生成）
└── ios_simple.xcworkspace           # Xcode 工作空间（运行 pod install 后生成）
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

### 2. 生成 iOS 配置文件

```bash
cd /path/to/rs-booking
flutter pub get
```

这会自动生成 `.ios/` 目录和必要的配置文件。

### 3. 安装 CocoaPods

```bash
sudo gem install cocoapods
```

---

## 集成步骤概览

1. ✅ **创建/修改 `Podfile`** - 配置 Flutter 模块依赖
2. ✅ **创建 `AppDelegate.swift`** - 初始化 FlutterEngine
3. ✅ **修改 `ios_simpleApp.swift`** - 连接 AppDelegate
4. ✅ **创建 `FlutterManager.swift`** - 管理 Flutter 视图控制器
5. ✅ **修改 `HomeView.swift`** - 添加跳转到 Flutter 的代码
6. ✅ **检查 `ios_simple.entitlements`** - 确保配置正确
7. ✅ **运行 `pod install`** - 安装依赖

---

## 详细文件修改说明

### 1. 创建/修改 `Podfile`

**文件路径：** `ios_simple/Podfile`

**完整内容：**

```ruby
# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'ios_simple' do
  use_frameworks!

  # ⭐ Flutter Module 路径配置
  # 指向 Flutter 模块的根目录
  flutter_application_path = '../../rs-booking'
  
  # ⭐ 加载 Flutter 的 podhelper.rb 脚本
  # 这个脚本提供了安装 Flutter 模块的函数
  load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
  
  # ⭐ 安装 Flutter 模块的所有 Pods
  # 这会自动安装 Flutter 引擎、插件等所有依赖
  install_all_flutter_pods(flutter_application_path)
end

# ⭐ post_install 钩子
# 在 Pods 安装完成后执行，用于配置 Flutter 相关的构建设置
post_install do |installer|
  installer.pods_project.targets.each do |target|
    # 应用 Flutter 的额外构建设置
    flutter_additional_ios_build_settings(target)
  end
  # 执行 Flutter 的 post_install 脚本
  flutter_post_install(installer)
end
```

**改动目的：**
- 配置 Flutter 模块的路径
- 自动安装 Flutter 引擎和所有插件
- 应用 Flutter 特定的构建设置

**关键点：**
- `flutter_application_path` 指向 Flutter 模块的根目录
- `install_all_flutter_pods()` 会自动安装所有 Flutter 依赖
- `flutter_post_install()` 是必需的，用于配置 Flutter 插件

---

### 2. 创建 `AppDelegate.swift`

**文件路径：** `ios_simple/ios_simple/AppDelegate.swift`

**完整内容：**

```swift
//
//  AppDelegate.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import UIKit
import Flutter

class AppDelegate: UIResponder, UIApplicationDelegate {
    // ⭐ 全局变量：存储 AppDelegate 实例
    // 使用 weak 避免循环引用
    // 在 SwiftUI 中，需要通过这种方式访问 AppDelegate
    static weak var shared: AppDelegate?
    
    // ⭐ 懒加载 FlutterEngine
    // FlutterEngine 是 Flutter 的核心，负责运行 Dart 代码
    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
    
    override init() {
        super.init()
        // ⭐ 保存实例到静态变量，方便其他地方访问
        AppDelegate.shared = self
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // ⭐ 启动 Flutter 引擎
        // 这会初始化 Flutter 运行时环境
        flutterEngine.run()
        
        // ⭐ 注册 Flutter 插件（如果可用）
        // GeneratedPluginRegistrant 是 Flutter 自动生成的插件注册类
        // 使用运行时检查避免编译错误
        if let registrantClass = NSClassFromString("GeneratedPluginRegistrant") as? NSObject.Type {
            if registrantClass.responds(to: Selector(("registerWithRegistry:"))) {
                registrantClass.perform(Selector(("registerWithRegistry:")), with: flutterEngine)
            }
        }
        
        return true
    }
}
```

**改动目的：**
- 在应用启动时初始化 FlutterEngine
- 注册 Flutter 插件
- 提供全局访问 FlutterEngine 的方式

**关键点：**
- `FlutterEngine` 必须在应用启动时初始化
- 使用 `lazy var` 延迟初始化，节省启动时间
- `AppDelegate.shared` 用于在 SwiftUI 中访问 AppDelegate
- 插件注册使用运行时检查，避免编译错误

---

### 3. 修改 `ios_simpleApp.swift`

**文件路径：** `ios_simple/ios_simple/ios_simpleApp.swift`

**修改前：**

```swift
import SwiftUI

@main
struct ios_simpleApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
```

**修改后：**

```swift
//
//  ios_simpleApp.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import SwiftUI

@main
struct ios_simpleApp: App {
    // ⭐ 使用 UIApplicationDelegateAdaptor 连接 AppDelegate
    // 这是 SwiftUI 中连接 UIKit AppDelegate 的方式
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
```

**改动目的：**
- 在 SwiftUI App 中连接 UIKit 的 AppDelegate
- 确保 AppDelegate 的方法被正确调用

**关键点：**
- `@UIApplicationDelegateAdaptor` 是 SwiftUI 提供的属性包装器
- 这样 AppDelegate 的 `application(_:didFinishLaunchingWithOptions:)` 方法会被调用

---

### 4. 创建 `FlutterManager.swift`

**文件路径：** `ios_simple/ios_simple/FlutterManager.swift`

**完整内容：**

```swift
//
//  FlutterManager.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import Foundation
import Flutter
import UIKit

class FlutterManager {
    // ⭐ 单例模式
    static let shared = FlutterManager()
    
    // ⭐ 从 AppDelegate 获取 FlutterEngine
    private var flutterEngine: FlutterEngine? {
        // 使用全局变量 AppDelegate.shared 获取引擎
        return AppDelegate.shared?.flutterEngine
    }
    
    private init() {
        // FlutterEngine 在 AppDelegate 中初始化
    }
    
    // ⭐ 获取 FlutterViewController
    // initialRoute: 可选，设置 Flutter 的初始路由
    func getFlutterViewController(initialRoute: String? = nil) -> FlutterViewController {
        // 确保 FlutterEngine 已初始化
        guard let engine = flutterEngine else {
            print("⚠️ FlutterEngine 未找到，创建新的引擎")
            // 如果获取失败，尝试直接创建新的引擎（fallback）
            let newEngine = FlutterEngine(name: "fallback flutter engine")
            newEngine.run()
            
            // 注册插件
            if let registrantClass = NSClassFromString("GeneratedPluginRegistrant") as? NSObject.Type {
                if registrantClass.responds(to: Selector(("registerWithRegistry:"))) {
                    registrantClass.perform(Selector(("registerWithRegistry:")), with: newEngine)
                }
            }
            
            let flutterViewController = FlutterViewController(
                engine: newEngine,
                nibName: nil,
                bundle: nil
            )
            
            if let route = initialRoute {
                flutterViewController.setInitialRoute(route)
            }
            
            return flutterViewController
        }
        
        print("✅ 使用已初始化的 FlutterEngine")
        
        // ⭐ 创建 FlutterViewController
        // FlutterViewController 是显示 Flutter 页面的视图控制器
        let flutterViewController = FlutterViewController(
            engine: engine,
            nibName: nil,
            bundle: nil
        )
        
        // ⭐ 设置初始路由（如果提供）
        // 对应 Flutter 中的路由路径，例如 "/home"、"/(home)" 等
        if let route = initialRoute {
            flutterViewController.setInitialRoute(route)
        }
        
        return flutterViewController
    }
}
```

**改动目的：**
- 封装 Flutter 视图控制器的创建逻辑
- 提供统一的接口获取 FlutterViewController
- 支持设置初始路由

**关键点：**
- 使用单例模式，方便全局访问
- 从 AppDelegate 获取已初始化的 FlutterEngine（性能更好）
- 提供 fallback 机制，确保即使 AppDelegate 未正确设置也能工作
- `setInitialRoute()` 用于设置 Flutter 的初始路由

---

### 5. 修改 `HomeView.swift`

**文件路径：** `ios_simple/ios_simple/HomeView.swift`

**修改前：**

```swift
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("首页")
            }
        }
    }
}
```

**修改后：**

```swift
//
//  HomeView.swift
//  ios_simple
//
//  Created by shawn on 2025/11/29.
//

import SwiftUI
import UIKit
import Flutter

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("首页")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Spacer()
                
                // ⭐ 进入 Flutter 按钮 - 使用 NavigationLink 打开全屏页面
                NavigationLink(destination: FlutterView()) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                        Text("进入 Flutter")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationTitle("首页")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// ⭐ Flutter 视图包装器
// UIViewControllerRepresentable 用于在 SwiftUI 中使用 UIKit 视图控制器
struct FlutterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FlutterViewController {
        print("🔄 创建 FlutterViewController...")
        // 从 FlutterManager 获取 FlutterViewController
        let flutterViewController = FlutterManager.shared.getFlutterViewController()
        
        // 确保视图正确加载
        flutterViewController.view.backgroundColor = .white
        
        // 优化焦点处理，减少警告
        if #available(iOS 15.0, *) {
            flutterViewController.view.setNeedsFocusUpdate()
        }
        
        print("✅ FlutterViewController 创建完成")
        return flutterViewController
    }
    
    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {
        // 不需要更新
    }
}
```

**改动目的：**
- 在 SwiftUI 页面中添加跳转到 Flutter 的按钮
- 使用 `UIViewControllerRepresentable` 将 UIKit 的 `FlutterViewController` 包装成 SwiftUI 视图

**关键点：**
- `UIViewControllerRepresentable` 是 SwiftUI 提供的协议，用于集成 UIKit 视图控制器
- `NavigationLink` 用于导航到 Flutter 页面（全屏 push 方式）
- 也可以使用 `.sheet()` 以模态方式展示（从底部弹出）

**其他展示方式：**

```swift
// 方式 1: 使用 NavigationLink（全屏 push）
NavigationLink(destination: FlutterView()) {
    Text("进入 Flutter")
}

// 方式 2: 使用 sheet（模态弹出）
@State private var showFlutter = false

Button("进入 Flutter") {
    showFlutter = true
}
.sheet(isPresented: $showFlutter) {
    FlutterView()
}

// 方式 3: 使用 fullScreenCover（全屏模态）
.fullScreenCover(isPresented: $showFlutter) {
    FlutterView()
}
```

---

### 6. 检查 `ios_simple.entitlements`

**文件路径：** `ios_simple/ios_simple/ios_simple.entitlements`

**正确配置：**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<!-- iOS 应用不需要 app-sandbox，这是 macOS 的设置 -->
	<!-- 如果需要特定权限，可以在这里添加，例如：
	<key>com.apple.developer.associated-domains</key>
	<array>
		<string>applinks:example.com</string>
	</array>
	-->
</dict>
</plist>
```

**改动目的：**
- 确保没有 macOS 的沙盒设置（`com.apple.security.app-sandbox`）
- iOS 应用不需要这个设置，会导致权限错误

**关键点：**
- ❌ **不要**添加 `com.apple.security.app-sandbox`
- ✅ 如果需要特定权限（如 Associated Domains），可以在这里添加

---

## 完整操作流程

### 步骤 1：准备 Flutter 模块

```bash
# 1. 确保 Flutter 模块已配置为 Module 类型
cd /path/to/rs-booking
cat pubspec.yaml | grep -A 3 "module:"

# 2. 生成 iOS 配置文件
flutter pub get
```

### 步骤 2：创建/修改 iOS 项目文件

按照上面的说明创建/修改以下文件：
1. `Podfile` - 配置 Flutter 模块依赖
2. `AppDelegate.swift` - 初始化 FlutterEngine
3. `ios_simpleApp.swift` - 连接 AppDelegate
4. `FlutterManager.swift` - 管理 Flutter 视图控制器
5. `HomeView.swift` - 添加跳转到 Flutter 的代码
6. `ios_simple.entitlements` - 检查配置

### 步骤 3：安装 CocoaPods 依赖

```bash
cd /path/to/ios_simple
pod install
```

**重要：** 安装完成后，必须打开 `.xcworkspace` 文件，而不是 `.xcodeproj` 文件！

### 步骤 4：在 Xcode 中添加文件

如果新创建的文件没有自动添加到项目中：

1. 在 Xcode 中，右键点击项目文件夹
2. 选择 "Add Files to 'ios_simple'..."
3. 选择以下文件：
   - `AppDelegate.swift`
   - `FlutterManager.swift`
4. 确保勾选你的 target

### 步骤 5：运行项目

1. 打开 `ios_simple.xcworkspace`（⚠️ 必须是 `.xcworkspace`！）
2. 选择目标设备（模拟器或真机）
3. 点击运行按钮 (⌘R)
4. 在应用中点击按钮，应该能看到 Flutter 页面

---

## 常见问题

### Q1: "No such module 'Flutter'" 错误

**原因：** CocoaPods 依赖未正确安装

**解决方案：**
```bash
cd ios_simple
rm -rf Pods Podfile.lock
pod install
```

然后：
1. 关闭 Xcode
2. 重新打开 `ios_simple.xcworkspace`
3. Product > Clean Build Folder (⇧⌘K)
4. 重新构建 (⌘B)

### Q2: "Cannot find 'GeneratedPluginRegistrant' in scope"

**原因：** 插件注册类未找到

**解决方案：**
- 当前代码已使用运行时检查，不会出现编译错误
- 如果 Flutter 模块没有插件，这个警告可以忽略
- 确保运行了 `pod install`

### Q3: Flutter 页面白屏

**原因：** FlutterEngine 未正确初始化或路由错误

**解决方案：**
1. 检查 Xcode 控制台是否有错误信息
2. 确认 AppDelegate 已正确连接
3. 确认 FlutterEngine 已启动（查看日志）
4. 检查 `initialRoute` 是否正确

### Q4: Sandbox 权限错误

**原因：** `ios_simple.entitlements` 中启用了 macOS 沙盒

**解决方案：**
- 确保 `ios_simple.entitlements` 中没有 `com.apple.security.app-sandbox`
- 参考上面的正确配置

### Q5: 如何自定义 Flutter 路由

**方式 1：在创建 FlutterViewController 时设置**

```swift
let flutterViewController = FlutterManager.shared.getFlutterViewController(initialRoute: "/custom-page")
```

**方式 2：在 FlutterManager 中修改**

```swift
func getFlutterViewController(initialRoute: String? = nil) -> FlutterViewController {
    // ...
    if let route = initialRoute {
        flutterViewController.setInitialRoute(route)
    }
    // ...
}
```

### Q6: 性能优化 - 使用缓存的引擎

当前实现每次创建新的 FlutterViewController，但共享同一个 FlutterEngine。如果需要更好的性能，可以：

```swift
// 在 AppDelegate 中预加载引擎
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    flutterEngine.run()
    // 预加载，提升首次打开速度
    return true
}
```

### Q7: 如何传递数据到 Flutter

**方式 1：通过路由参数**

```swift
flutterViewController.setInitialRoute("/page?param=value")
```

**方式 2：通过 MethodChannel**

```swift
let channel = FlutterMethodChannel(
    name: "com.example/channel",
    binaryMessenger: flutterEngine.binaryMessenger
)

channel.invokeMethod("methodName", arguments: ["key": "value"])
```

---

## 总结

集成 Flutter 模块到原生 iOS 项目需要创建/修改以下文件：

| 文件 | 操作 | 目的 |
|------|------|------|
| `Podfile` | 创建/修改 | 配置 Flutter 模块依赖 |
| `AppDelegate.swift` | 新建 | 初始化 FlutterEngine |
| `ios_simpleApp.swift` | 修改 | 连接 AppDelegate |
| `FlutterManager.swift` | 新建 | 管理 Flutter 视图控制器 |
| `HomeView.swift` | 修改 | 添加跳转到 Flutter 的代码 |
| `ios_simple.entitlements` | 检查 | 确保配置正确 |

**核心原理：**
1. 通过 CocoaPods 引入 Flutter 模块（使用 `.ios` 目录）
2. 在 AppDelegate 中初始化 FlutterEngine
3. 使用 FlutterViewController 显示 Flutter 页面
4. 通过 UIViewControllerRepresentable 在 SwiftUI 中集成

**关键步骤：**
1. 配置 Podfile
2. 运行 `pod install`
3. 打开 `.xcworkspace`（不是 `.xcodeproj`！）
4. 创建 AppDelegate 和 FlutterManager
5. 在 SwiftUI 中使用 FlutterView

---

## 参考资料

- [Flutter 官方文档：将 Flutter 添加到现有 iOS 应用](https://docs.flutter.cn/add-to-app/ios/)
- [Flutter 官方文档：在 iOS 中添加 Flutter 页面](https://docs.flutter.cn/add-to-app/ios/add-flutter-screen/)
- [CocoaPods 官方文档](https://guides.cocoapods.org/)

---

## 两种集成方式对比

### 方式 1: CocoaPods 直接引用（当前方式，开发推荐）

**优点：**
- ✅ 支持热重载
- ✅ 开发时快速迭代
- ✅ 自动处理依赖
- ✅ 配置简单

**缺点：**
- ❌ 需要 Flutter 开发环境
- ❌ 需要 Flutter SDK

**适用场景：** 开发阶段

### 方式 2: Framework 打包（发布时推荐）

**优点：**
- ✅ 独立打包，不依赖 Flutter 源码
- ✅ 可以分发给其他团队
- ✅ 发布时更稳定

**缺点：**
- ❌ 不支持热重载
- ❌ 修改代码需要重新打包
- ❌ 配置相对复杂

**适用场景：** 发布阶段

**使用 Framework 方式：**

```bash
# 1. 构建 Framework
cd rs-booking
flutter build ios-framework --release

# 2. 在 Xcode 中手动添加 Framework
# 导航到 build/ios/framework/Release/
# 添加 App.xcframework 和 Flutter.xcframework
```

---

**文档版本：** 1.0  
**最后更新：** 2025-11-29  
**维护者：** iOS 开发团队
