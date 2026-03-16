#!/bin/bash
FLUTTER_BIN="/home/lsyst/Documentos/JAVA/flutter/bin/flutter"
LOG_FILE="debug_android.log"

echo "Start: $(date)" > $LOG_FILE
echo "User: $(whoami)" >> $LOG_FILE
echo "PWD: $(pwd)" >> $LOG_FILE
echo "Flutter version check:" >> $LOG_FILE
$FLUTTER_BIN --version >> $LOG_FILE 2>&1
echo "Running flutter create:" >> $LOG_FILE
$FLUTTER_BIN create --platforms=android . >> $LOG_FILE 2>&1
echo "Checking results:" >> $LOG_FILE
ls -la android >> $LOG_FILE 2>&1
echo "End: $(date)" >> $LOG_FILE
