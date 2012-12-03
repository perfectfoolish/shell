#!/bin/bash
set -e
#install JAVA

chmod +x ./web/jdk-6u24-linux-i586-rpm.bin
echo | ./web/jdk-6u24-linux-i586-rpm.bin 


#install JETTY

unzip ./web/jetty-distribution-7.5.2.v20111006.zip -d /usr/share/
mv /usr/share/jetty-distribution-7.5.2.v20111006 /usr/share/jetty


# echo export JAVA_HOME=/usr/java/jdk1.6.0_24 >> /etc/profile
# echo export JRE_HOME=$JAVA_HOME/jre >> /etc/profile
# echo export JETTY_HOME=/usr/share/jetty >> /etc/profile
# echo export PATH=$JAVA_HOME/bin:$JETTY_HOME/bin:$PATH >> /etc/profile
# source /etc/profile

if [ -f /etc/profile ]; then
	mv /etc/profile /etc/profile.bak
	cp ./web/profile /etc/
fi
source /etc/profile
#
ln -s /usr/share/jetty/bin/jetty.sh /etc/init.d/jetty
chkconfig --add jetty
chkconfig --list jetty
chkconfig --level 35 jetty on
#service jetty start

#

service jetty stop
text=`sed 's/OPTIONS=Server,jsp,jmx,resources,websocket,ext/&,ajp/' /usr/share/jetty/start.ini`
#text=`sed /OPTIONS=Server,jsp,jmx,resources,websocket,ext/s/ext/ext,ajp/ /usr/share/jetty/start.ini`
echo "$text" > /usr/share/jetty/start.ini

echo etc/jetty-ajp.xml >> /usr/share/jetty/start.ini


rm -rf /usr/share/jetty/contexts/*.xml
cp ./web/ims.xml /usr/share/jetty/contexts

if [ -f ./web/ims/WEB-INF/classes/config.properties ]; then
	mv ./web/ims/WEB-INF/classes/config.properties ./web/ims/WEB-INF/classes/config.properties.bak
	cp ./web/config.properties ./web/ims/WEB-INF/classes
fi


echo | service jetty start 

