#!/bin/bash
# Program:
#	User inputs his first name and last name.  Program shows his full name.
# History:
# 2005/08/23	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please input your first name: " firstname  # 造成使用者輸入
read -p "Please input your last name:  " lastname   # 造成使用者輸入
echo -e "\nYour full name is: $firstname $lastname" # 結果由螢幕輸出
