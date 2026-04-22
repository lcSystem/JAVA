#!/bin/bash

set -e

# === DETECTAR JAVA ===
if [ -d "/usr/lib/jvm/java-21-openjdk-amd64" ]; then
  export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
elif [ -d "/usr/lib/jvm/java-17-openjdk-amd64" ]; then
  export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
else
  echo "❌ No tienes Java 17 o 21 instalado"
  exit 1
fi

export PATH=$JAVA_HOME/bin:$PATH

# === CONFIGURACIÓN ===
FLUTTER_PATH="$HOME/Descargas/flutter/bin/flutter"
SDK_PATH="$HOME/Android/Sdk"
PROJECT_PATH="$(pwd)"

echo "🚀 Generando AAB..."

# Variables SDK
export ANDROID_HOME="$SDK_PATH"
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

# Ir al proyecto
cd "$PROJECT_PATH"

# Build
$FLUTTER_PATH clean
$FLUTTER_PATH pub get
$FLUTTER_PATH build appbundle --no-tree-shake-icons

echo "✅ AAB generado en:"
echo "$PROJECT_PATH/build/app/outputs/bundle/release/app-release.aab"
