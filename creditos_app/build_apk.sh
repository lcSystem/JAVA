#!/bin/bash
export PATH="/home/lsyst/Documentos/JAVA/flutter/bin:$PATH"
LOG_FILE="build_apk.log"

echo "Build Start: $(date)" > $LOG_FILE
flutter build apk --debug --no-pub >> $LOG_FILE 2>&1
echo "Checking APK location:" >> $LOG_FILE
find build -name "*.apk" >> $LOG_FILE 2>&1
echo "Build End: $(date)" >> $LOG_FILE
