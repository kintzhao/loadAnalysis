#!/bin/sh

LOG_FILE=/tmp/kint/log
LOG_STATISTIC_FILE=/tmp/kint/statistic.csv
MAX_NUM=3

[ -d /tmp/kint ] || mkdir -p /tmp/kint       #判定是否是目录及确保目录名称存在，如果目录不存在的就新创建一个

rotate_log()
{
    cd /tmp/kint

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
    #sleep 60                                                                                                                                                                                                                                                                 
    #sync
	
    echo "" >> $LOG_FILE                                                                                                                                                                                                                                                      
    echo "======== $(date +%r) ========" >> $LOG_FILE                                                                                                                                                                                                                         
    time_date=`date`                                                                                                                                                                                                                                                          
    echo "======== Uptime:" >> $LOG_FILE                                                                                                                                                                                                                                      
    uptime >> $LOG_FILE                                                                                                                                                                                                                                                       
    echo "======== Before Cache Drop:" >> $LOG_FILE                                                                                                                                                                                                                           
    echo "================= FREE:" >> $LOG_FILE   
    #free >> $LOG_FILE                                                                                                                                                                                                                                                         
    #beforemem=`free -m | grep Mem | awk '{print $4}'`  
    free -m 	> tmp.txt	
    cat tmp.txt >> $LOG_FILE  
	beforemem=`cat tmp.txt | grep Mem | awk '{print $4}'`
	
	
    echo "================= TOP:" >> $LOG_FILE                                                                                                                                                                                                                                
    #top -b -n 1 | head -n 24 >> $LOG_FILE	
    #beforeCpu=`top -b -n 1 | head -n 24 | grep "/usr/bin/slamwared -t /etc/sdp_ref.json" | awk 'NR==1{print $7}'  | awk -F% '{print $1}'`      #%                                                                                                                                                             
    top -b -n 1 | head -n 24 > tmp.txt	
	cat tmp.txt > $LOG_FILE
	beforeCpu=`cat tmp.txt  | grep "/usr/bin/slamwared -t /etc/sdp_ref.json" | awk 'NR==1{print $7}'  | awk -F% '{print $1}'`      #%                                                                                                                                                             

	
    echo 1 > /proc/sys/vm/drop_caches || exit 1                                                                                                                                                                                                                               

    echo "======== After Cache Dropped:" >> $LOG_FILE                                                                                                                                                                                                                         
    echo "================= FREE:" >> $LOG_FILE                                                                                                                                                                                                                               
    free >> $LOG_FILE                                                                                                                                                                                                                                                         
    echo "================= TOP:" >> $LOG_FILE                                                                                                                                                                                                                                
    #top -b -n 1 | head -n 24 >> $LOG_FILE                                                                                                                                                                                                                                     
    #afterCpu=`top -b -n 1 | head -n 24 | grep "/usr/bin/slamwared -t /etc/sdp_ref.json" | awk 'NR==1{print $7}' | awk -F% '{print $1}'`          #%
    top -b -n 1 | head -n 24 > tmp.txt	
	cat tmp.txt > $LOG_FILE
	afterCpu=`cat tmp.txt  | grep "/usr/bin/slamwared -t /etc/sdp_ref.json" | awk 'NR==1{print $7}'  | awk -F% '{print $1}'`      #%                                                                                                                                                             

	#afterCpu=`top -b -n 1 | head -n 24 | grep "/usr/bin/slamwared -t /etc/sdp_ref.json" | awk '{print $7}' | sed -n '1p'`
	#echo $time_date"  "$beforemem"  "$beforeCpu"  "$afterCpu   >> $LOG_STATISTIC_FILE                                                                                                                                                                                        
    echo -n $time_date"  " >> $LOG_STATISTIC_FILE                                                                                                                                                                                                                             
    echo -n $beforemem"  " >> $LOG_STATISTIC_FILE                                                                                                                                                                                                                             
    echo  -n $beforeCpu"  ">> $LOG_STATISTIC_FILE                                                                                                                                                                                                                             
    echo  $afterCpu"  " >> $LOG_STATISTIC_FILE                                                                                                                                                                                                                                   
    sleep 10                                                                                                                                                                                                                                                                  
    sync
	
done                                                                                                                                                                                                                                                                          
 
