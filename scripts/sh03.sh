#!/bin/bash
# Program:
#	Program creates three files, which named by user's input 
#	and date command.
# History:
# 2005/08/23	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 1. ���ϥΪ̿�J�ɮצW�١A�è��o fileuser �o���ܼơF
echo -e "I will use 'touch' command to create 3 files." # �º���ܸ�T
read -p "Please input your filename: " fileuser         # ���ܨϥΪ̿�J

# 2. ���F�קK�ϥΪ��H�N�� Enter �A�Q���ܼƥ\����R�ɦW�O�_���]�w�H
filename=${fileuser:-"filename"}           # �}�l�P�_���_�]�w�ɦW

# 3. �}�l�Q�� date ���O�Ө��o�һݭn���ɦW�F�F
date1=$(date --date='2 days ago' +%Y%m%d)  # �e��Ѫ����
date2=$(date --date='1 days ago' +%Y%m%d)  # �e�@�Ѫ����
date3=$(date +%Y%m%d)                      # ���Ѫ����
file1=${filename}${date1}                  # ���U�T��b�]�w�ɦW
file2=${filename}${date2}
file3=${filename}${date3}

# 4. �N�ɦW�إߧa�I
touch "$file1"                             # ���U�T��b�إ��ɮ�
touch "$file2"
touch "$file3"
