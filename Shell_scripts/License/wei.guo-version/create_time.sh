#! /bin/sh

#expire time(unit: second)
TIME_DAY=1
TIME_EXPIRED=$(($TIME_DAY*24*3600))

# file that stores the start time of CEICT-SERVER
cd /root/time_test/time

#touch ceict-server-start.bat

TIME_FILE="./ceict-server-start.bat"

# write down the first run time of SERVER
if [ -f "$TIME_FILE" ]
    then
        echo "time file exits"   
    else
#        echo $(date+%s -d '2012-10-10 01:01:01')> $TIME_FILE
    

		echo  "$TIME_EXPIRED" > $TIME_FILE
fi

