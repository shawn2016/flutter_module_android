# RestoApp - Android 应用

这是一个带有底部导航栏的Android应用，包含三个主要页面：首页、订单、我的。

## 功能特性

- ✅ 底部导航栏
- ✅ 首页页面
- ✅ 订单页面
- ✅ 个人中心页面

## 技术栈

- Kotlin
- AndroidX
- Material Design Components
- ViewBinding

## 运行要求

- Android Studio Hedgehog | 2023.1.1 或更高版本
- JDK 8 或更高版本
- Android SDK 24 或更高版本（最低支持）
- Android SDK 34（编译目标）

## 如何运行

1. 使用 Android Studio 打开项目
2. 连接 Android 真机或启动模拟器
3. 点击运行按钮或使用快捷键 `Shift + F10` (Windows/Linux) 或 `Ctrl + R` (Mac)
4. 应用将自动安装并运行在设备上

## 项目结构

```
app/
├── src/
│   └── main/
│       ├── java/com/resto/app/
│       │   ├── MainActivity.kt          # 主Activity，包含底部导航
│       │   ├── HomeFragment.kt          # 首页Fragment
│       │   ├── OrderFragment.kt         # 订单Fragment
│       │   └── ProfileFragment.kt       # 个人中心Fragment
│       ├── res/
│       │   ├── layout/                  # 布局文件
│       │   ├── menu/                    # 菜单文件
│       │   └── values/                  # 资源文件
│       └── AndroidManifest.xml
└── build.gradle
```

## 开发说明

- 使用 ViewBinding 进行视图绑定
- 使用 Fragment 实现页面切换
- 底部导航使用 Material Design Components

