#! /bin/bash

#expire time(unit: second)
((TIME_DAY=1))
((TIME_EXPIRED=TIME_DAY*24*3600))

# file that stores the start time of CEICT-SERVER
cd /var/lib/asterisk/
TIME_FILE=ceict-server-start.bat

# write down the first run time of SERVER
if [ -f "$TIME_FILE" ]
    then
        echo "time file exits"   
    else
        echo `date +%s` > $TIME_FILE
fi

# get the start time
read start_t<$TIME_FILE

# get the stop time 
stop_t=`date +%s`

# calculate the escaped time
((escape_t=stop_t-start_t))

# if time expired, kill asterisk and httpd
if [[ $escape_t -gt $TIME_EXPIRED ]] 
    then
        killall asterisk
        crontab -r
        echo "expired"
    else
        echo "not expired"
fi

echo "used: $escape_t / $TIME_EXPIRED"
