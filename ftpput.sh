#!/bin/sh      
#FileName:ftpput.sh   
#Function:从本地客户端向ftp服务器上传一个文件     
#Version:V0.1      
#Author:Sunrier      
#Date:2012-07-20

#$#表示传递给此Shell脚本的参数个数
#-ne表示不等于
if [ $# -ne 2  ] 
then
    echo "Usage $0  <local_dir/filename> <remote_dir>" 
    exit 1
fi  

#IP表示ftp的服务器ip地址
IP=127.0.0.1  
#IP=192.168.6.1

#FULLNAME获取本地文件全路径名
FULLNAME=$1

#DESTDIR获取需要上传的ftp远程目录路径
DESTDIR=$2

#basename返回一个路径中的文件名部分
#如FULLNAME="/home/Sunrier/Proj/log/test.log"; 
#当local_filename=`basename $FULLNAME`
#最终local_filename="test.log"
local_filename=`basename $FULLNAME`

#DESTFILE表示ftp服务器的路径,以及保存后的文件名
DESTFILE=$DESTDIR/$local_filename 

#ftp -i -n $IP <<FTPIT
ftp -i -n <<FTPIT
open $IP
user Sunrier redhat
bin
passive
cd /home/remote/log/ftpfile
put $FULLNAME $DESTFILE
quit
FTPIT

exit 0



