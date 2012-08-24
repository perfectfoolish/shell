#!/bin/bash

for a in $*
do
 echo $*
#shift  功能是依次向左移动  直到减到零
 shift
done
