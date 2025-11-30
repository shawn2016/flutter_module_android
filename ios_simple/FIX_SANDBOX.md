# 修复 Sandbox 权限错误

## 问题原因

`ios_simple.entitlements` 文件中启用了 `com.apple.security.app-sandbox`，这是 **macOS 应用的设置**，不应该用于 iOS 应用。

iOS 应用不需要这个沙盒设置，它会导致 Flutter 无法写入 build 目录。

## 已修复

✅ 已移除 `com.apple.security.app-sandbox` 设置

## 下一步

### 1. 在 Xcode 中清理构建

1. 在 Xcode 中：Product > Clean Build Folder (⇧⌘K)
2. 等待清理完成

### 2. 重新构建

1. 在 Xcode 中：Product > Build (⌘B)
2. 如果构建成功，运行项目 (⌘R)

### 3. 如果还有问题

检查 Xcode 项目设置：

1. 选择项目 Target `ios_simple`
2. 在 "Signing & Capabilities" 选项卡
3. 检查 "Code Signing Entitlements" 设置
4. 如果指向 `ios_simple.entitlements`，确保文件内容正确（已修复）

## 验证

运行项目后，应该不再有沙盒权限错误。


