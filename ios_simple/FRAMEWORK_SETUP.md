# iOS Framework 集成指南

## 使用 Framework 打包方式（类似 Android AAR）

### 步骤 1: 构建 Flutter Framework

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
./build_framework.sh release
```

或者手动构建：

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/flutter_module_demo
flutter build ios-framework --release
```

### 步骤 2: 安装 CocoaPods 依赖

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
pod install
```

Podfile 会自动检测 Framework 是否存在：
- 如果 Framework 存在，使用 Framework 方式
- 如果 Framework 不存在，回退到开发模式（直接引用 .ios）

### 步骤 3: 打开工作空间

```bash
open ios_simple.xcworkspace
```

⚠️ **必须打开 `.xcworkspace` 文件！**

### 步骤 4: 在 Xcode 中添加文件

如果新文件没有自动添加到项目中：

1. 右键点击 `ios_simple` 文件夹
2. 选择 "Add Files to 'ios_simple'"
3. 选择以下文件：
   - `AppDelegate.swift`
   - `FlutterManager.swift`
4. 确保勾选你的 target

### 步骤 5: 运行项目

1. 选择目标设备（模拟器或真机）
2. 点击运行按钮 (⌘R)
3. 在首页点击 "进入 Flutter" 按钮
4. Flutter 模块应该会打开

## Framework 位置

构建完成后，Framework 会生成在：

```
flutter_module_demo/build/ios/framework/
├── Debug/
│   └── Flutter.framework
├── Profile/
│   └── Flutter.framework
└── Release/
    └── Flutter.framework
```

## Podfile 配置说明

当前 Podfile 配置了智能检测：

```ruby
# 如果 Framework 存在，使用 Framework 方式
if File.exist?(File.join(flutter_framework_path, 'Flutter.framework'))
    pod 'Flutter', :path => flutter_framework_path
else
    # 回退到开发模式
    install_all_flutter_pods(flutter_application_path)
end
```

## 更新 Framework

当 Flutter 模块代码更新后，需要重新构建 Framework：

```bash
./build_framework.sh release
pod install
```

## 优势

✅ **独立打包**：不依赖 Flutter 源码  
✅ **类似 AAR**：与 Android 的 AAR 方式一致  
✅ **可分发**：可以分发给其他团队  
✅ **稳定**：发布时更稳定

## 注意事项

- Framework 构建后，修改 Flutter 代码需要重新构建
- 不支持热重载（Hot Reload）
- 适合发布和生产环境使用


