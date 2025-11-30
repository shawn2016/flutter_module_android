# iOS Flutter 模块生成指南

## 📋 概述

iOS 集成 Flutter 模块有两种方式：

1. **方式 1: CocoaPods 直接引用（开发推荐）** - 不需要生成 Framework
2. **方式 2: Framework 打包（发布推荐）** - 需要生成 Framework

---

## 方式 1: CocoaPods 直接引用（当前使用的方式）

### 特点
- ✅ **不需要生成 Framework**
- ✅ 支持热重载
- ✅ 开发时快速迭代
- ✅ 配置简单

### 工作原理
- Podfile 直接引用 Flutter 模块的 `.ios` 目录
- CocoaPods 自动处理依赖和构建配置
- 类似于 Android 直接引用源码

### 当前配置

**Podfile:**
```ruby
flutter_application_path = '../../rs-booking'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
install_all_flutter_pods(flutter_application_path)
```

### 使用步骤

```bash
# 1. 确保 Flutter 模块已准备好
cd /path/to/rs-booking
flutter pub get

# 2. 安装 CocoaPods 依赖
cd /path/to/ios_simple
pod install

# 3. 打开工作空间（必须是 .xcworkspace！）
open ios_simple.xcworkspace
```

**✅ 这就是当前使用的方式，不需要生成 Framework！**

---

## 方式 2: Framework 打包（发布时使用）

### 特点
- ✅ 独立打包，不依赖 Flutter 源码
- ✅ 可以分发给其他团队
- ✅ 发布时更稳定
- ❌ 不支持热重载
- ❌ 修改代码需要重新打包

### 生成 Framework

#### 方法 1: 使用脚本（推荐）

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
./build_framework.sh release
```

**脚本功能：**
- 自动构建 Flutter Framework
- 支持 Debug、Profile、Release 三种模式
- 显示构建结果和文件位置

#### 方法 2: 手动构建

```bash
# 进入 Flutter 模块目录
cd /path/to/rs-booking

# 构建 Framework（所有版本）
flutter build ios-framework

# 或者单独构建
flutter build ios-framework --debug
flutter build ios-framework --profile
flutter build ios-framework --release
```

### Framework 输出位置

构建完成后，Framework 会生成在：

```
rs-booking/build/ios/framework/
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

### 使用 Framework 方式

#### 步骤 1: 构建 Framework

```bash
cd /Users/shawn/Desktop/coding/04-resto/flutter_module_android/ios_simple
./build_framework.sh release
```

#### 步骤 2: 在 Xcode 中手动添加 Framework

1. 打开 `ios_simple.xcworkspace`
2. 在项目导航器中，右键点击项目名称
3. 选择 "Add Files to 'ios_simple'..."
4. 导航到 `rs-booking/build/ios/framework/Release/`
5. 选择以下文件：
   - `App.xcframework`
   - `Flutter.xcframework`
6. 确保勾选：
   - ✅ "Copy items if needed"
   - ✅ 你的 target

#### 步骤 3: 配置 Framework 设置

1. 选择项目 Target
2. 在 "General" 选项卡
3. 找到 "Frameworks, Libraries, and Embedded Content"
4. 确保 Framework 的 "Embed" 设置为 "Embed & Sign"

#### 步骤 4: 更新 Podfile（可选）

如果使用 Framework 方式，可以简化 Podfile：

```ruby
platform :ios, '12.0'

target 'ios_simple' do
  use_frameworks!
  # Framework 已在 Xcode 中手动添加，不需要 CocoaPods
end
```

---

## 两种方式对比

| 特性 | CocoaPods 直接引用 | Framework 打包 |
|------|-------------------|----------------|
| **是否需要生成 Framework** | ❌ 不需要 | ✅ 需要 |
| **开发体验** | ✅ 支持热重载 | ❌ 不支持 |
| **构建速度** | ✅ 快速 | ⚠️ 需要先构建 Framework |
| **分发** | ❌ 需要 Flutter 环境 | ✅ 独立打包 |
| **适用场景** | 开发阶段 | 发布阶段 |
| **当前使用** | ✅ **是** | ❌ 否 |

---

## 当前项目状态

### ✅ 当前使用：CocoaPods 直接引用

**不需要执行 `build_framework.sh`！**

当前项目已经配置为使用 CocoaPods 直接引用方式：

1. **Podfile** 配置为引用 `.ios` 模块
2. **运行 `pod install`** 即可
3. **不需要生成 Framework**

### 什么时候需要生成 Framework？

只有在以下情况下才需要生成 Framework：

1. **发布到 App Store** - 需要独立打包
2. **分发给其他团队** - 不需要 Flutter 环境
3. **CI/CD 构建** - 需要可复制的构建产物

---

## 脚本说明

### build_framework.sh

**位置：** `ios_simple/build_framework.sh`

**功能：** 构建 Flutter iOS Framework

**使用方法：**
```bash
cd ios_simple
./build_framework.sh [debug|release|profile]
```

**参数：**
- `debug` - 构建 Debug 版本
- `profile` - 构建 Profile 版本
- `release` - 构建 Release 版本（默认）

**输出：**
- Framework 文件生成在 `rs-booking/build/ios/framework/`

### setup_framework.sh

**位置：** `ios_simple/setup_framework.sh`

**功能：** 一键设置 Framework 方式（构建 + 安装 Pods）

**使用方法：**
```bash
cd ios_simple
./setup_framework.sh
```

**注意：** 这个脚本会构建 Framework，但当前项目使用的是 CocoaPods 方式，**不需要运行这个脚本**。

---

## 推荐工作流程

### 开发阶段（当前）

```bash
# 1. 确保 Flutter 模块已准备好
cd rs-booking
flutter pub get

# 2. 安装 CocoaPods 依赖
cd ios_simple
pod install

# 3. 打开工作空间
open ios_simple.xcworkspace

# 4. 在 Xcode 中运行项目
```

**✅ 不需要生成 Framework！**

### 发布阶段（如果需要）

```bash
# 1. 构建 Framework
cd ios_simple
./build_framework.sh release

# 2. 在 Xcode 中手动添加 Framework（见上面步骤）

# 3. 更新 Podfile（可选，如果完全使用 Framework 方式）

# 4. 构建和发布
```

---

## 常见问题

### Q1: 我需要执行 build_framework.sh 吗？

**答：** 
- **开发阶段：不需要** ✅
- **发布阶段：需要** ⚠️

当前项目使用 CocoaPods 直接引用方式，**不需要生成 Framework**。

### Q2: 如何切换到 Framework 方式？

**答：**
1. 运行 `./build_framework.sh release`
2. 在 Xcode 中手动添加 Framework
3. 更新 Podfile（可选）

### Q3: Framework 和 CocoaPods 方式可以同时使用吗？

**答：** 可以，但不推荐。建议选择一个方式：
- 开发时：使用 CocoaPods 方式
- 发布时：使用 Framework 方式

### Q4: 如何知道当前使用的是哪种方式？

**答：** 查看 Podfile：
- 如果有 `install_all_flutter_pods(flutter_application_path)` → CocoaPods 方式
- 如果只有 `pod 'Flutter', :path => ...` → Framework 方式

---

## 总结

### ✅ 当前项目（开发阶段）

**不需要生成 Framework！**

只需要：
```bash
cd ios_simple
pod install
open ios_simple.xcworkspace
```

### ⚠️ 发布阶段（如果需要）

如果需要独立打包：
```bash
cd ios_simple
./build_framework.sh release
# 然后在 Xcode 中手动添加 Framework
```

---

**文档版本：** 1.0  
**最后更新：** 2025-11-29


