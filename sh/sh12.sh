#!/bin/bash
# Program:
#	This script only accepts the flowing parameter: one, two or three.
# History:
# 2005/08/29	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo "This program will print your selection !"
# read -p "Input your choice: " choice # �Ȯɨ����A�i�H�����I
# case $choice in                      # �Ȯɨ����A�i�H�����I
case $1 in                             # �{�b�ϥΡA�i�H�ΤW���������I
  "one")
	echo "Your choice is ONE"
	;;
  "two")
	echo "Your choice is TWO"
	;;
  "three")
	echo "Your choice is THREE"
	;;
  *)
	echo "Usage $0 {one|two|three}"
	;;
esac
