#!/bin/bash
# Program:
#	You input your demobilization date, I calculate how many days
#	before you demobilize.
# History:
# 2005/08/29	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 1. �i���ϥΪ̳o��{�����γ~�A�åB�i�����Ӧp���J����榡�H
echo "This program will try to calculate :"
echo "How many days before your demobilization date..."
read -p "Please input your demobilization date (YYYYMMDD ex>20090401): " date2

# 2. ���դ@�U�A�o�ӿ�J�����e�O�_���T�H�Q�Υ��W��ܪk�o��
date_d=$(echo $date2 |grep '[0-9]\{8\}')   # �ݬݬO�_���K�ӼƦr
if [ "$date_d" == "" ]; then
	echo "You input the wrong date format...."
	exit 1
fi

# 3. �}�l�p�����o��
declare -i date_dem=`date --date="$date2" +%s`    # �h�������
declare -i date_now=`date +%s`                    # �{�b������
declare -i date_total_s=$(($date_dem-$date_now))  # �Ѿl��Ʋέp
declare -i date_d=$(($date_total_s/60/60/24))     # �ର���
if [ "$date_total_s" -lt "0" ]; then              # �P�_�O�_�w�h��
	echo "You had been demobilization before: " $((-1*$date_d)) " ago"
else
	declare -i date_h=$(($(($date_total_s-$date_d*60*60*24))/60/60))
	echo "You will demobilize after $date_d days and $date_h hours."
fi
