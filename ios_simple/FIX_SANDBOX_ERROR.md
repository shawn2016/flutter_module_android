# 修复 Sandbox 权限错误

## 错误原因

这是 macOS 沙盒权限问题，Flutter 无法写入 build 目录。

## 解决方法

### 方法 1: 清理 build 目录（已执行）

```bash
cd ios_simple
rm -rf build
```

### 方法 2: 在 Xcode 中清理

1. 在 Xcode 中：Product > Clean Build Folder (⇧⌘K)
2. 关闭 Xcode
3. 重新打开项目

### 方法 3: 检查终端权限

如果问题持续，可能需要给终端或 Xcode 添加文件访问权限：

1. 打开"系统设置" > "隐私与安全性" > "完全磁盘访问权限"
2. 确保以下应用已添加：
   - Xcode
   - Terminal（或你使用的终端应用）
   - Flutter（如果单独列出）

### 方法 4: 使用命令行构建

如果 Xcode 构建有问题，可以尝试使用命令行：

```bash
cd ios_simple
xcodebuild -workspace ios_simple.xcworkspace -scheme ios_simple -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' clean build
```

## 快速修复脚本

运行以下命令：

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
rm -rf build
# 然后在 Xcode 中：Product > Clean Build Folder (⇧⌘K)
```


