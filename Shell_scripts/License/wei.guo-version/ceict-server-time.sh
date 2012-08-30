#! /bin/bash
TIME_FILE=./time_time
TIME=`cat $TIME_FILE`
echo $TIME

# if time expired, kill asterisk and httpd

while((1))
do	
		if [[ $TIME -le 0 ]] 
		then
			killall asterisk
      echo "killall asterisk"
			echo "0" > $TIME_FILE
      break
		else 
			START_TIME=$((`date +%s`))			
      echo "start_time is $START_TIME"
			sleep 5
			if [[ `date +%s` -lt START_TIME ]]
			then 
				continue	
      elif [[ `date +%s` -gt $(($START_TIME + 8)) ]]
      then 
        continue
			else 
				TIME=$((TIME+START_TIME-`date +%s`))
				echo $TIME > $TIME_FILE
			fi
			
		fi

	
done
echo "over"
