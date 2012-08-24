#!/bin/bash
# Program:
#	Use loop to calculate "1+2+3+...+100" result.
# History:
# 2005/08/29	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

s=0  # 硂琌羆计跑计
i=0  # 硂琌仓璸计ョ琌 1, 2, 3....
while [ "$i" != "100" ]
do
	i=$(($i+1))   # –Ω i 常穦糤 1 
	s=$(($s+$i))  # –Ω常穦羆Ω
done
echo "The result of '1+2+3+...+100' is ==> $s"
