#!/bin/bash
# Program:
#	Use function to repeate information.
# History:
# 2005/08/29	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

function printit(){
	echo "Your choice is $1"   # �o�� $1 �����n�Ѧҩ��U���O���U�F
}

echo "This program will print your selection !"
case $1 in
  "one")
	printit 1  # �Ъ`�N�A printit ���O�᭱�٦����ѼơI
	;;
  "two")
	printit 2
	;;
  "three")
	printit 3
	;;
  *)
	echo "Usage $0 {one|two|three}"
	;;
esac
