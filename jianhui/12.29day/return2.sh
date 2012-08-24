#!/bin/bash

function direxit()
{
   read dir
   if [ ! -d $dir ]
   then 
     return 1
   else
     return 0
   fi
}
if direxit
then
  echo "dir exit"
else
  echo "dir no exit"
fi
