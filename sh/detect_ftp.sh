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
testing=$(service vsftpd status | grep "running")   # ������ port 80 �b�_�H
if [ "$testing" = "running" ]; then
	echo "FTP is running in your system."
fi
testing=$(service vsftpd status | grep "stopped")   # ������ port 80 �b�_�H
if [ "$testing" = "stopped" ]; then
	echo "FTP is not running in your system."
fi
