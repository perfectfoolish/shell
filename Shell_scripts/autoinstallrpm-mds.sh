#! /bin/sh 

uninstall()
{
	service cws stop
	rpm -ev `rpm -qa | grep ims` 
}

rpm_install()
{
	rpm -ivh ./ims*	

	if [ -f /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties ];then
		
		sed -i 's/\/etc\/asterisk/\/etc\/ceictims/g' /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
		sed -i 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/localhost/g' /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
#		sed -i 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/localhost/g' /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties

	fi

	service cws start
	
	chkconfig --level 35 cws on

	if [ ! -d rpm ];then
		mkdir /root/rpm
	fi
	
	ls ./ims-rpm-*.rpm > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		mv ./ims-rpm-*.rpm /root/rpm
	fi
}


log()
{
	DIR=logs
	max_dirno=0
	if [ ! -d logs ];then
		mkdir /root/$DIR
	fi
	for dirname in `ls $DIR`;do

		dirno=${dirname#log}

		if [ $dirno -gt $max_dirno ];then
			max_dirno=$dirno
		fi

	done

	LAST_DIR=/root/$DIR/log$((max_dirno + 1))
	mkdir $LAST_DIR

}

uninstall
rpm_install
log


