#!/bin/bash
echo "--- IP Addresses ---" > diag.log
hostname -I >> diag.log 2>&1
echo "--- Android SDK Search ---" >> diag.log
find /home/lsyst -maxdepth 3 -name "Sdk" -type d >> diag.log 2>&1
find /usr/lib -maxdepth 2 -name "android-sdk" -type d >> diag.log 2>&1
echo "--- Environment ---" >> diag.log
env | grep -E "ANDROID|SDK|FLUTTER|JAVA" >> diag.log
