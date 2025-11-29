# Framework 使用说明

## Framework 已构建成功 ✅

从终端输出可以看到，Framework 已经成功构建：
```
Frameworks written to
/Users/shawn/Desktop/coding/04-resto/flutter_module_android/flutter_module_demo/build/ios/framework.
```

## Framework 文件位置

Framework 文件生成在：
```
flutter_module_demo/build/ios/framework/
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

## 两种集成方式

### 方式 1: 使用 CocoaPods（当前配置，推荐用于开发）

当前 Podfile 配置为使用 `.ios` 模块方式，这是**开发时推荐的方式**：

```ruby
flutter_application_path = '../flutter_module_demo'
install_all_flutter_pods(flutter_application_path)
```

**优点：**
- ✅ 支持热重载
- ✅ 自动处理依赖
- ✅ 配置简单

**使用：**
```bash
pod install
open ios_simple.xcworkspace
```

### 方式 2: 手动添加 Framework（发布时推荐）

如果你想使用 Framework 方式（类似 Android AAR），需要在 Xcode 中手动添加：

#### 步骤 1: 在 Xcode 中添加 Framework

1. 打开 `ios_simple.xcworkspace`
2. 在项目导航器中，右键点击项目名称
3. 选择 "Add Files to 'ios_simple'..."
4. 导航到 `flutter_module_demo/build/ios/framework/Release/`
5. 选择以下文件：
   - `App.xcframework`
   - `Flutter.xcframework`
6. 确保勾选：
   - ✅ "Copy items if needed"
   - ✅ 你的 target

#### 步骤 2: 配置 Framework 设置

1. 选择项目 Target
2. 在 "General" 选项卡
3. 找到 "Frameworks, Libraries, and Embedded Content"
4. 确保 Framework 的 "Embed" 设置为 "Embed & Sign"

#### 步骤 3: 更新 Podfile（可选）

如果使用 Framework 方式，可以简化 Podfile：

```ruby
platform :ios, '12.0'

target 'ios_simple' do
  use_frameworks!
  # Framework 已在 Xcode 中手动添加，不需要 CocoaPods
end
```

## 当前推荐方案

**开发阶段：使用方式 1（CocoaPods + .ios 模块）**

当前配置已经正确，直接运行：
```bash
cd ios_simple
pod install
open ios_simple.xcworkspace
```

Framework 已经构建好了，可以作为备用或发布时使用。

## 验证 Framework

检查 Framework 是否构建成功：

```bash
cd flutter_module_demo
ls -la build/ios/framework/Release/
```

应该能看到 `App.xcframework` 和 `Flutter.xcframework`。

