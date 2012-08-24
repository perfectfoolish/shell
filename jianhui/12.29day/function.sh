#!/bin/bash

function daytime()
{
   hour=0
   until [ $hour -ge 24 ]
   do
      case $hour in 
        [0-9] | 1[0-1])
        echo "good morning"
           ;;
        1[2])
        echo "good "
           ;;
        1[3-8])
        echo "afternoon"
           ;;
        *)
        echo "night"
      esac
      hour=$(($hour+1))
  done
}
daytime
