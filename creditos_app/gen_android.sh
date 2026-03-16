#!/bin/bash
export PATH="/home/lsyst/Documentos/JAVA/flutter/bin:$PATH"
flutter config --enable-android > build_android.log 2>&1
flutter create --platforms=android . >> build_android.log 2>&1
ls -la >> build_android.log 2>&1
