#!/bin/bash

function max()
{
   read num1 num2
   if [ $num1 -gt $num2 ]
    then
     echo "max: $num1"
   else  
     echo "max: $num2"
   fi
}
max
