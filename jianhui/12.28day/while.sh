#!/bin/bash

t=1
sum=0
while [ $t -le 100 ]
do
   sum=$(($sum+$t))
   t=$(($t+1))
   echo $RANDOM
done
echo "sunm: $sum"
