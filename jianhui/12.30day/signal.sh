#!/bin/bash


function myexit()
{
   echo "just hit <ctrl+c>"
   echo "now the number is: $num"
   exit 0
}


trap "myexit" 2


num=0
while :
do 
   echo "$num"
   let num=$num+1
   sleep 1
done 
