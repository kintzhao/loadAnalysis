#!/bin/sh

LOG_FILE=/mnt/profile/log
MAX_NUM=3

[ -d /mnt/profile ] || mkdir -p /mnt/profile       #判定是否是目录及确保目录名称存在，如果目录不存在的就新创建一个

rotate_log()
{
    cd /mnt/profile

    [ -f log ] || return 1

    NEWEST_NUM=$(ls log* | sort -n | tail -n 1 | cut -d '.' -f 2)

    [ "$NEWEST_NUM" = "log" ] && mv log log.1 && return 0

    [ $NEWEST_NUM -lt $MAX_NUM ] && mv log log.$((NEWEST_NUM + 1)) && return 0

    [ $NEWEST_NUM -eq $MAX_NUM ] && \
    {
        rm log.1 
        index=2
        while [ $index -le $MAX_NUM ]; do
            mv log.$index log.$((index - 1))
            index=$((index + 1))
        done
        mv log log.$MAX_NUM
    }
}

rotate_log

while true; do
    sleep 720
    sync

    echo "" >> $LOG_FILE
    echo "======== $(date +%r) ========" >> $LOG_FILE
    echo "======== Uptime:" >> $LOG_FILE
    uptime >> $LOG_FILE
    echo "======== Before Cache Drop:" >> $LOG_FILE
    echo "================= FREE:" >> $LOG_FILE
    free >> $LOG_FILE
    echo "================= TOP:" >> $LOG_FILE
    top -b -n 1 | head -n 24 >> $LOG_FILE
    
    echo 1 > /proc/sys/vm/drop_caches || exit 1

    echo "======== After Cache Dropped:" >> $LOG_FILE
    echo "================= FREE:" >> $LOG_FILE
    free >> $LOG_FILE
    echo "================= TOP:" >> $LOG_FILE
    top -b -n 1 | head -n 24 >> $LOG_FILE
done
