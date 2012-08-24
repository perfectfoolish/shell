#!/bin/bash

#a hou mian jia canshu  形式是 a:
while getopts a:bc OPTION
do
   case $OPTION in
   a)
   echo "....a"
#  存储到 optarg
   echo "OPTARG:$OPTARG"
   aopt=$OPTARG
   ;;
   b)
   echo "....b"
   ;;
   c)
   echo "....c"
   ;;
   *)
   echo "no argment"
   esac
done
