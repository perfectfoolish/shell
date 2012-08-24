#!/bin/bash

function max()
{
   read num1 num2 num3
   if [ $num1 -gt $num2 ]
     then 
     max=$num1
     num1=$num2
    else
     max=$num2
     num2=$num1
   fi
    if [ $max -gt $num3 ]
    then
     echo "$max"
    else 
     echo "$num3"
    fi
}
max
