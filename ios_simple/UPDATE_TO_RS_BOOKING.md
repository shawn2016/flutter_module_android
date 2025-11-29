# 更新到 rs-booking 模块

## 已完成的更改

✅ **Podfile** - 更新 Flutter 模块路径为 `../../rs-booking`
✅ **build_framework.sh** - 更新 Framework 构建脚本路径
✅ **setup_framework.sh** - 更新设置脚本路径

## 配置说明

### Podfile 配置

```ruby
flutter_application_path = '../../rs-booking'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
install_all_flutter_pods(flutter_application_path)
```

### 路径说明

- iOS 项目位置: `/Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple`
- Flutter 模块位置: `/Users/shawn/Desktop/coding/04-resto/rs-booking`
- 相对路径: `../../rs-booking`

## 下一步

### 1. 确保 rs-booking 已配置为 Flutter 模块

检查 `rs-booking/pubspec.yaml` 中是否有：

```yaml
flutter:
  module:
    androidX: true
    androidPackage: ai.restosuite.inc.tables
    iosBundleIdentifier: ai.restosuite.inc.tables
```

### 2. 运行 pod install

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
pod install
```

### 3. 在 Xcode 中重新构建

1. 打开 `ios_simple.xcworkspace`
2. 清理构建: Product > Clean Build Folder (⇧⌘K)
3. 重新构建: Product > Build (⌘B)
4. 运行项目: Product > Run (⌘R)

## 验证

运行项目后，点击"进入 Flutter"按钮，应该能看到 `rs-booking` 模块的内容。

