#!/bin/sh
# Gradle Wrapper - 自动下载并运行 Gradle
APP_NAME="Gradle"
APP_BASE_NAME=$(basename "$0")
MAX_FD="maximum"
warn() { echo "$*"; }
die() { echo "$*"; exit 1; }

# Determine Java
if [ -n "$JAVA_HOME" ]; then
    JAVACMD="$JAVA_HOME/bin/java"
else
    JAVACMD="java"
fi

# Resolve project dir
PRG="$0"
while [ -h "$PRG" ]; do
    ls=$(ls -ld "$PRG")
    link=$(expr "$ls" : '.*-> \(.*\)$')
    if expr "$link" : '/.*' > /dev/null; then PRG="$link"; else PRG=$(dirname "$PRG")/"$link"; fi
done
SAVED="$(pwd)"
cd "$(dirname "$PRG")/" >/dev/null
APP_HOME="$(pwd -P)"
cd "$SAVED" >/dev/null

CLASSPATH="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"

# Download wrapper jar if missing
if [ ! -f "$CLASSPATH" ]; then
    echo "Downloading Gradle Wrapper..."
    WRAPPER_URL="https://services.gradle.org/distributions/gradle-8.5-bin.zip"
    mkdir -p "$APP_HOME/gradle/wrapper"
    if command -v curl > /dev/null 2>&1; then
        curl -sL "https://raw.githubusercontent.com/gradle/gradle/v8.5.0/gradle/wrapper/gradle-wrapper.jar" -o "$CLASSPATH"
    elif command -v wget > /dev/null 2>&1; then
        wget -q "https://raw.githubusercontent.com/gradle/gradle/v8.5.0/gradle/wrapper/gradle-wrapper.jar" -O "$CLASSPATH"
    else
        die "ERROR: Cannot download Gradle Wrapper. Install curl or wget."
    fi
fi

exec "$JAVACMD" \
    -Xmx2048m \
    -Dorg.gradle.appname="$APP_BASE_NAME" \
    -classpath "$CLASSPATH" \
    org.gradle.wrapper.GradleWrapperMain "$@"
