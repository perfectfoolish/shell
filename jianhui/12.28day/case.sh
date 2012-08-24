#!/bin/bash

read a
case $a in
[0-9])
   echo "一个数字"
   ;;
[a-z])
   echo "一个小写字母"
   ;;
*)
   echo "其他字符"
esac
