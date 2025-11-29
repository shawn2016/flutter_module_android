# 修复 Flutter 白屏问题

## 问题

点击"进入 Flutter"按钮后，Flutter 页面显示白屏，没有报错。

## 可能的原因

1. FlutterEngine 未正确初始化
2. Flutter 模块路径配置错误
3. 插件未正确注册
4. Flutter 模块未正确加载

## 已应用的修复

### 1. 改进插件注册

在 `AppDelegate.swift` 中添加了运行时插件注册：

```swift
if let registrantClass = NSClassFromString("GeneratedPluginRegistrant") as? NSObject.Type {
    if registrantClass.responds(to: Selector(("registerWithRegistry:"))) {
        registrantClass.perform(Selector(("registerWithRegistry:")), with: flutterEngine)
    }
}
```

### 2. 添加调试日志

在 `FlutterManager.swift` 和 `HomeView.swift` 中添加了打印语句，方便调试。

### 3. 设置背景色

在 `FlutterView` 中设置了背景色，确保视图可见。

## 检查步骤

### 1. 检查 Podfile 路径

确保 Podfile 中的路径正确：

```ruby
flutter_application_path = '../../rs-booking'
```

### 2. 运行 pod install

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
rm -rf Pods Podfile.lock
pod install
```

### 3. 检查 rs-booking 模块

确保 `rs-booking` 已正确配置为 Flutter 模块：

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
flutter pub get
```

### 4. 查看控制台日志

运行项目后，查看 Xcode 控制台输出：
- 应该看到 "✅ 使用已初始化的 FlutterEngine"
- 应该看到 "🔄 创建 FlutterViewController..."
- 应该看到 "✅ FlutterViewController 创建完成"

### 5. 检查 Flutter 模块

确保 `rs-booking` 的 `pubspec.yaml` 中有模块配置：

```yaml
flutter:
  module:
    androidX: true
    androidPackage: ai.restosuite.inc.tables
    iosBundleIdentifier: ai.restosuite.inc.tables
```

## 如果还是白屏

### 方法 1: 检查 Xcode 控制台

查看是否有错误信息，特别是：
- Flutter 引擎启动错误
- 模块加载错误
- 路径错误

### 方法 2: 验证 Flutter 模块

在终端运行：

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
flutter run -d ios
```

如果能正常运行，说明 Flutter 模块本身没问题。

### 方法 3: 清理并重新构建

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
rm -rf Pods Podfile.lock build
pod install
```

然后在 Xcode 中：
1. Product > Clean Build Folder (⇧⌘K)
2. Product > Build (⌘B)
3. Product > Run (⌘R)

## 调试技巧

在 Xcode 控制台中查看：
- Flutter 引擎是否启动
- 是否有 Dart 代码执行错误
- 是否有资源加载错误

