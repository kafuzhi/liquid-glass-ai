#!/bin/bash
# ============================================
# 液态玻璃 AI - APK 构建脚本
# ============================================
# 前置要求:
#   1. JDK 17+  (推荐: Azul Zulu / Eclipse Temurin)
#   2. Android SDK (通过 Android Studio 安装，或 cmdline-tools)
#   3. 设置环境变量: JAVA_HOME, ANDROID_HOME
# ============================================

set -e

echo "╔══════════════════════════════════════╗"
echo "║   液态玻璃 AI - APK 构建工具        ║"
echo "╚══════════════════════════════════════╝"
echo ""

# 检查 Java
if ! command -v java &>/dev/null; then
    echo "❌ 未找到 Java，请安装 JDK 17+"
    echo "   下载: https://adoptium.net/"
    exit 1
fi
echo "✓ Java: $(java -version 2>&1 | head -1)"

# 检查 ANDROID_HOME
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo "❌ 未设置 ANDROID_HOME 或 ANDROID_SDK_ROOT"
    echo "   Android Studio 默认路径:"
    echo "   macOS:  ~/Library/Android/sdk"
    echo "   Linux:  ~/Android/Sdk"
    echo "   Windows: %LOCALAPPDATA%\\Android\\Sdk"
    exit 1
fi
SDK="${ANDROID_HOME:-$ANDROID_SDK_ROOT}"
echo "✓ Android SDK: $SDK"
echo ""

# 进入项目目录
cd "$(dirname "$0")"

# 检查 Gradle Wrapper
if [ ! -f "gradlew" ]; then
    echo "⏳ 生成 Gradle Wrapper..."
    gradle wrapper --gradle-version 8.5 2>/dev/null || {
        echo "⚠️  未安装 gradle 命令，尝试手动创建 wrapper..."
        mkdir -p gradle/wrapper
        cat > gradle/wrapper/gradle-wrapper.properties <<EOF
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.5-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF
    }
fi

# 构建
echo "🔨 开始构建 Debug APK..."
echo ""
./gradlew assembleDebug --no-daemon 2>&1

APK="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
    SIZE=$(du -h "$APK" | cut -f1)
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║   ✅ 构建成功!                       ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    echo "📱 APK 路径: $APK"
    echo "📦 文件大小: $SIZE"
    echo ""
    echo "安装到手机:"
    echo "  adb install $APK"
else
    echo ""
    echo "❌ 构建失败，请检查上方错误信息"
    exit 1
fi
