#!/bin/bash
# Program:
# 	Using netstat and grep to detect WWW,SSH,FTP and Mail services.
# History:
# 2005/08/28	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 1. ���@�@�ǧi�����ʧ@�Ӥw��
echo "Now, I will detect your Linux server's services!"
echo -e "The www, ftp, ssh, and mail will be detect! \n"

# 2. �}�l�i��@�Ǵ��ժ��u�@�A�åB�]��X�@�Ǹ�T�o�I
testing=$(netstat -tuln | grep ":80 ")   # ������ port 80 �b�_�H
if [ "$testing" != "" ]; then
	echo "WWW is running in your system."
fi
testing=$(netstat -tuln | grep ":22 ")   # ������ port 22 �b�_�H
if [ "$testing" != "" ]; then
	echo "SSH is running in your system."
fi
testing=$(netstat -tuln | grep ":21 ")   # ������ port 21 �b�_�H
if [ "$testing" != "" ]; then
	echo "FTP is running in your system."
fi
testing=$(netstat -tuln | grep ":25 ")   # ������ port 25 �b�_�H
if [ "$testing" != "" ]; then
	echo "Mail is running in your system."
fi
