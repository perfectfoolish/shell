#!/bin/bash

x=1
y=1
while [ $x -le 9 ]
do
   y=1
   while [ $y -le $x ]
   do
      res=$(($x*$y))
      printf "%d*%d=%d " $x $y $res
      y=$(($y+1))
   done
   printf "\n"
   x=$(($x+1))
done
