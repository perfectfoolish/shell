#!/bin/bash


function max()
{
#  -n 不换行
    echo -n "please input tow numbers: "
    read num1 num2
    if [ $num1 -gt $num2 ]
    then
       echo "num1 > num2"
       return $num1
    elif [ $num1 -lt $num2 ]
    then
       echo "num1 < num2"
       return $num2
    else
       echo "num1 = num2"
       return 0
    fi
}
max
#保存返回值$?  将返回值保存到ret变量
ret=$?
echo "ret: $ret"
