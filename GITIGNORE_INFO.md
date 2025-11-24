# .gitignore 配置说明

## 已配置的忽略规则

### Android 构建文件
- `android_demo/app/build/` - 所有构建产物
- `android_demo/build/` - 项目级构建文件
- `android_demo/.gradle/` - Gradle 缓存
- `android_demo/.idea/` - Android Studio 配置
- `android_demo/local.properties` - 本地配置（包含 SDK 路径）

### Flutter 构建文件
- `flutter_demo/build/` - Flutter 构建产物
- `flutter_module_demo/build/` - Flutter Module 构建产物
- `.dart_tool/` - Dart 工具缓存
- `.flutter-plugins*` - Flutter 插件配置

## 关于 build/intermediates/ 文件

**是的，这些文件应该被 git 忽略！**

`build/intermediates/` 目录下的所有文件都是：
- ✅ 构建过程中自动生成的中间文件
- ✅ 每次构建都会重新生成
- ✅ 不应该提交到版本控制
- ✅ 已经在 `.gitignore` 中配置为忽略

## 如果文件已经被 git 跟踪

如果这些文件在添加 `.gitignore` 之前就已经被 git 跟踪，需要先从 git 中移除：

```bash
# 从 git 中移除 build 目录（但保留本地文件）
git rm -r --cached android_demo/app/build/

# 提交更改
git commit -m "Remove build files from git tracking"
```

之后这些文件就会被 `.gitignore` 忽略，不会再被跟踪。

## 验证忽略规则

检查文件是否被忽略：
```bash
git check-ignore android_demo/app/build/intermediates/merged_res/debug/mergeDebugResources/values-si_values-si.arsc.flat
```

如果输出文件路径，说明已被忽略；如果没有输出，说明未被忽略。

