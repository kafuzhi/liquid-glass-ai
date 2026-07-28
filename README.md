# 液态玻璃 AI - Android APK

基于 WebView 的 AI 聊天应用，液态玻璃风格 UI。

## 功能特性

- 🫧 液态玻璃毛玻璃 UI
- 🔌 支持所有 OpenAI 兼容 API（GPT / Claude / DeepSeek / 通义 / Gemini 等）
- 📡 流式输出
- 📎 文件上传 / 图片上传
- 🎙️ 语音输入
- 💾 本地设置持久化
- 📤 导出对话为 Markdown
- 全屏沉浸式 + 刘海屏适配

---

## 构建 APK

### 方式零：GitHub Actions 云构建（最简单，无需本地环境）

```bash
# 1. 在 GitHub 上创建新仓库（不要勾选任何初始化选项）
# 2. 运行推送脚本:
chmod +x push-to-github.sh
./push-to-github.sh 你的GitHub用户名 仓库名

# 3. 等待构建完成（约3-5分钟）
# 4. 去 GitHub 仓库 → Actions → 点击最新 Build → Artifacts → 下载 APK
```

### 方式一：Android Studio（推荐）

1. 打开 Android Studio
2. `File → Open` → 选择 `liquid-glass-ai-apk` 文件夹
3. 等待 Gradle Sync 完成
4. 点击 `Build → Build Bundle(s) / APK(s) → Build APK(s)`
5. APK 位于 `app/build/outputs/apk/debug/app-debug.apk`

### 方式二：命令行

```bash
# 前置要求
# - JDK 17+: https://adoptium.net/
# - Android SDK: 通过 Android Studio 安装

# 设置环境变量
export JAVA_HOME=/path/to/jdk17
export ANDROID_HOME=/path/to/Android/Sdk

# 构建
chmod +x build.sh
./build.sh

# 或直接用 gradle
chmod +x gradlew
./gradlew assembleDebug

# 安装到手机
adb install app/build/outputs/apk/debug/app-debug.apk
```

### 方式三：VS Code + Gradle

1. 安装 VS Code 扩展 `Gradle for Java`
2. 打开项目文件夹
3. 运行 `gradle assembleDebug` 任务

---

## 自定义 HTML

修改 `app/src/main/assets/index.html` 即可更新网页内容，重新构建即可。

---

## 签名发布版

```bash
# 生成签名密钥
keytool -genkey -v -keystore release.keystore -alias liquidglass -keyalg RSA -keysize 2048 -validity 10000

# 构建 Release APK
./gradlew assembleRelease

# 签名
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 -keystore release.keystore app/build/outputs/apk/release/app-release-unsigned.apk liquidglass

# 对齐
zipalign -v 4 app-release-unsigned.apk liquid-glass-ai.apk
```

## 技术栈

- Android WebView
- Java 17
- Gradle 8.5
- AndroidX WebKit
