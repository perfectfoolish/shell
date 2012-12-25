#!/bin/bash  
# This script is used to capture the detail options of install.log   
# Including the the RPM name, version and release.  
# Created by Joe.Yeung<yangjiazhi@live.com>  
VOIP_CD=/mnt/cdrom  
ALL_RPMS_DIR=/mnt/cdrom/CentOS  
VOIP_RPMS_DIR=/voip/CentOS  
cat /root/install.log |grep Installing | sed 's/Installing //g'| sed 's/^[0-9]\+://g' > /root/packages.list  
packages_list=/root/packages.list  

cat $packages_list |  
while read row; do  
    #echo $row  
    Name=`rpm -q --qf=%{name} $row`  
    echo name: $Name  

    Version=`rpm -q --qf=%{version} $row`  
    echo version: $Version  

    Release=`rpm -q --qf=%{Release} $row`  
    echo release: $Release  
    echo  

    cd $ALL_RPMS_DIR  
    cp $Name-$Version-$Release* $VOIP_RPMS_DIR    
    echo Copying $Name-$Version-$Release* $VOIP_RPMS_DIR is done  
done 
