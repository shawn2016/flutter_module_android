# 修复 Flutter 资源文件加载失败问题

## 问题

```
Unable to load asset: "assets/images/loginLogo.png"
Exception: Asset not found
```

## 可能的原因

1. **资源文件未正确打包到 iOS 模块中**
2. **pubspec.yaml 配置正确，但需要重新构建**
3. **CocoaPods 缓存问题**

## 解决方案

### 步骤 1: 检查 pubspec.yaml 配置

确保 `rs-booking/pubspec.yaml` 中正确配置了资源：

```yaml
flutter:
  assets:
    - assets/images/
    - assets/html/booking_privacy.html
```

### 步骤 2: 清理并重新构建 Flutter 模块

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
flutter clean
flutter pub get
```

### 步骤 3: 重新安装 CocoaPods 依赖

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
rm -rf Pods Podfile.lock
pod install
```

### 步骤 4: 在 Xcode 中清理构建

1. 打开 `ios_simple.xcworkspace`
2. Product > Clean Build Folder (⇧⌘K)
3. 重新构建 (⌘B)
4. 运行项目 (⌘R)

## 验证资源文件

检查资源文件是否被打包：

```bash
# 检查 Flutter 模块的构建输出
cd /Users/shawn/Desktop/coding/04-resto/rs-booking
find build -name "flutter_assets" -type d

# 检查资源文件是否在其中
find build -name "loginLogo.png"
```

## 如果还是不行

### 方法 1: 检查资源文件路径

确保代码中使用的是正确的路径：

```dart
// ✅ 正确
Image.asset('assets/images/loginLogo.png')

// ❌ 错误
Image.asset('images/loginLogo.png')
Image.asset('/assets/images/loginLogo.png')
```

### 方法 2: 使用完整路径

如果使用代码生成（如 `assets.gen.dart`），确保使用生成的路径：

```dart
Assets.images.loginLogo.png()
```

### 方法 3: 检查文件大小写

iOS 对文件名大小写敏感，确保：
- 文件名：`loginLogo.png`
- 代码中：`loginLogo.png`（大小写一致）

## 常见问题

### Q1: 资源文件在 Android 正常，iOS 不正常

**原因：** iOS 的资源打包机制不同

**解决方案：**
1. 确保运行了 `flutter pub get`
2. 确保运行了 `pod install`
3. 清理并重新构建

### Q2: 部分资源文件能加载，部分不能

**原因：** 可能是文件路径或大小写问题

**解决方案：**
1. 检查文件名大小写
2. 检查 pubspec.yaml 中的路径配置
3. 确保所有资源文件都在 assets 目录下


