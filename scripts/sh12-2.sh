#!/bin/bash
# Program:
#	Use function to repeate information.
# History:
# 2005/08/29	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

function printit(){
	echo -n "Your choice is "     # �[�W -n �i�H���_���~��b�P�@�����
}

echo "This program will print your selection !"
case $1 in
  "one")
	printit; echo $1 | tr 'a-z' 'A-Z'
	;;
  "two")
	printit; echo $1 | tr 'a-z' 'A-Z'
	;;
  "three")
	printit; echo $1 | tr 'a-z' 'A-Z'
	;;
  *)
	echo "Usage $0 {one|two|three}"
	;;
esac
