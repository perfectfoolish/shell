#!/bin/bash

x=0
read a b
if [ $a -lt $b ]
then
 a=$b
 b=$a
else
a=$a
b=$b
fi
yshu=1
until [ $yshu -eq 0 ]
do
  yshu=$(($a%$b))
  a=$b
  b=$yshu
done
echo "$a"  
