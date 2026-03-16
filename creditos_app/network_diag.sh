#!/bin/bash
LOG_FILE="network_diag.log"
echo "--- IP ADDR ---" > $LOG_FILE
/sbin/ip addr show >> $LOG_FILE 2>&1
echo "--- IFCONFIG ---" >> $LOG_FILE
/sbin/ifconfig >> $LOG_FILE 2>&1
echo "--- HOSTNAME -I ---" >> $LOG_FILE
hostname -I >> $LOG_FILE 2>&1
echo "--- ANDROID SDK ---" >> $LOG_FILE
find /home/lsyst -maxdepth 5 -name "android-sdk" -type d >> $LOG_FILE 2>&1
find /home/lsyst -maxdepth 5 -name "Sdk" -type d >> $LOG_FILE 2>&1
echo "--- ENVIRONMENT ---" >> $LOG_FILE
env | grep -i android >> $LOG_FILE 2>&1
