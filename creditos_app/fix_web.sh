#!/bin/bash
FLUTTER_BIN="/home/lsyst/Documentos/JAVA/flutter/bin/flutter"
$FLUTTER_BIN config --enable-web > setup_web.log 2>&1
$FLUTTER_BIN create --template=app --platforms=web . >> setup_web.log 2>&1
$FLUTTER_BIN pub get >> setup_web.log 2>&1
ls -la >> setup_web.log 2>&1
