# 修复 iOS Flutter 模块资源文件加载失败

## 问题

```
Unable to load asset: "assets/images/loginLogo.png"
Exception: Asset not found
```

## 问题分析

从检查结果看：
1. ✅ `pubspec.yaml` 中已配置 `assets/images/`
2. ✅ 文件 `assets/images/loginLogo.png` 存在
3. ❌ `AssetManifest.json` 中**没有**包含图片资源
4. ❌ Framework 的 `flutter_assets` 目录中**没有** `assets/images/` 目录

**根本原因：** 资源文件没有被正确打包到 iOS Framework 中。

## 解决方案

### 步骤 1: 检查 pubspec.yaml 配置

确保 `pubspec.yaml` 中的缩进正确：

```yaml
flutter:
  module:
    androidX: true
    androidPackage: ai.restosuite.inc.tables
    iosBundleIdentifier: ai.restosuite.inc.tables
  uses-material-design: true

  # ⭐ 注意：assets 的缩进要和 uses-material-design 对齐
  assets:
    - assets/images/
    - assets/html/booking_privacy.html
```

**关键点：**
- `assets:` 必须和 `uses-material-design:` 对齐（同一缩进级别）
- 列表项使用 `-` 开头

### 步骤 2: 清理并重新构建

```bash
cd /Users/shawn/Desktop/coding/04-resto/rs-booking

# 1. 清理构建缓存
flutter clean

# 2. 重新获取依赖
flutter pub get

# 3. 重新构建 Framework
flutter build ios-framework --release
```

### 步骤 3: 验证资源文件

检查资源文件是否被打包：

```bash
# 检查 AssetManifest.json
cat build/ios/framework/Release/App.xcframework/ios-arm64/App.framework/flutter_assets/AssetManifest.json | python3 -m json.tool

# 应该能看到 assets/images/loginLogo.png

# 检查文件是否存在
find build/ios/framework/Release/App.xcframework/ios-arm64/App.framework/flutter_assets -name "loginLogo.png"
```

### 步骤 4: 重新安装 CocoaPods

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
rm -rf Pods Podfile.lock
pod install
```

### 步骤 5: 在 Xcode 中清理并重新构建

1. 打开 `ios_simple.xcworkspace`
2. Product > Clean Build Folder (⇧⌘K)
3. 重新构建 (⌘B)
4. 运行项目 (⌘R)

## 常见问题

### Q1: AssetManifest.json 中只有 cupertino_icons

**原因：** 资源文件没有被识别或打包

**解决方案：**
1. 检查 `pubspec.yaml` 的缩进
2. 确保 `assets/images/` 路径正确
3. 运行 `flutter clean` 和 `flutter pub get`
4. 重新构建 Framework

### Q2: 资源文件在 Android 正常，iOS 不正常

**原因：** iOS Framework 构建时资源文件处理不同

**解决方案：**
1. 确保使用 `flutter build ios-framework` 构建
2. 检查 Framework 中的 `flutter_assets` 目录
3. 确保 CocoaPods 正确安装

### Q3: 部分资源文件能加载，部分不能

**原因：** 可能是文件路径或大小写问题

**解决方案：**
1. 检查文件名大小写（iOS 对大小写敏感）
2. 确保所有资源文件都在 `assets/images/` 目录下
3. 检查 `pubspec.yaml` 中的路径配置

## 验证清单

- [ ] `pubspec.yaml` 中 `assets:` 配置正确
- [ ] 运行了 `flutter clean` 和 `flutter pub get`
- [ ] 重新构建了 Framework
- [ ] `AssetManifest.json` 中包含图片资源
- [ ] Framework 的 `flutter_assets` 目录中有 `assets/images/` 目录
- [ ] 运行了 `pod install`
- [ ] 在 Xcode 中清理并重新构建


