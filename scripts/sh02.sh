#!/bin/bash
# Program:
#	User inputs his first name and last name.  Program shows his full name.
# History:
# 2005/08/23	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please input your first name: " firstname  # �y���ϥΪ̿�J
read -p "Please input your last name:  " lastname   # �y���ϥΪ̿�J
echo -e "\nYour full name is: $firstname $lastname" # ���G�ѿù���X
