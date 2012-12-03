#!/bin/bash
# Program:
#	Use loop to calculate "1+2+3+...+100" result.
# History:
# 2005/08/29	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

s=0  # �o�O�[�`���ƭ��ܼ�
i=0  # �o�O�֭p���ƭȡA��Y�O 1, 2, 3....
while [ "$i" != "100" ]
do
	i=$(($i+1))   # �C�� i ���|�W�[ 1 
	s=$(($s+$i))  # �C�����|�[�`�@���I
done
echo "The result of '1+2+3+...+100' is ==> $s"
