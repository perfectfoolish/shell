#!/bin/bash
#冒号   冒号的空操作

read num
if [ $num -gt 10 ] 
then
  echo ">10"
else 
   :
fi
