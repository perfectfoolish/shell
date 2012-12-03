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
		rm -rf  /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
		cp ./config.properties /opt/ceict-webapp-server/webapps/root/WEB-INF/classes/config.properties
	fi

	service cws cleancache
	service cws start
	
	rm -rf ./ims*
}

download()
{
	wget 'http://192.168.0.20:8081/nexus/service/local/artifact/maven/redirect?r=snapshots&g=com.ceict&a=ims-rpm&v=1.0.0-SNAPSHOT&e=rpm'
}

uninstall

download

rpm_install
