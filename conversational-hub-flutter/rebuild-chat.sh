#!/bin/bash
# Script para recompilar Flutter Chat y copiar a Next.js
set -e

FLUTTER_DIR="/home/lsyst/Documentos/JAVA/conversational-hub-flutter"
FLUTTER_BIN="$FLUTTER_DIR/flutter/bin/flutter"
NEXT_PUBLIC="/home/lsyst/Documentos/JAVA/iam-core-front/ERP-FRONT/ERP-FRONT/public/chat-assets"

echo "🔨 Compilando Flutter Web..."
cd "$FLUTTER_DIR"
"$FLUTTER_BIN" build web --release

echo "📦 Copiando a Next.js..."
rm -rf "$NEXT_PUBLIC"
mkdir -p "$NEXT_PUBLIC"
cp -r "$FLUTTER_DIR/build/web/"* "$NEXT_PUBLIC/"

echo "✅ ¡Listo! Refresca tu navegador en http://localhost:3000/erp/mensajes"
