#! /bin/bash

uninstall()
{
	service cws stop
	rpm -ev `rpm -qa | grep ims` 
}

rpm_install()
{
	rpm -ivh ./ims*	

	if [ -f /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties ];then
		sed -i 's/C:\/temp/\/etc\/asterisk/' /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
		
		addr=`sed -n '/dbhost=/p' /etc/asterisk/res_mysql.conf`
		addr=${addr#dbhost=}
		name=`sed -n '/dbname=/p' /etc/asterisk/res_mysql.conf`
		name=${name#dbname=}
		user=`sed -n '/dbuser=/p' /etc/asterisk/res_mysql.conf`
		user=${user#dbuser=}
		pass=`sed -n '/dbpass=/p' /etc/asterisk/res_mysql.conf`
		pass=${pass#dbpass=}

		sed -i "/jdbc.default.user=root/s/root/$user/" /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
		sed -i "/jdbc.default.password=2011ceict/s/2011ceict/$pass/" /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
		sed -i "/jdbc.sms.user=root/s/root/$user/" /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
		sed -i "/jdbc.sms.password=2011ceict/s/2011ceict/$pass/" /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
		sed -i "s/\/\/[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}\/ims/\/\/$addr\/$name/" /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
		sed -i "s/mci.hostname=[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}/mci.hostname=localhost/" /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties

	fi

	service cws start
	
	chkconfig --level 35 cws on

	rm -rf ./ims*
}

download()
{
	wget 'http://192.168.0.20:8081/nexus/service/local/artifact/maven/redirect?r=snapshots&g=com.ceict&a=ims-rpm&v=1.0.0-SNAPSHOT&e=rpm&c=821'
}

uninstall

download

rpm_install
