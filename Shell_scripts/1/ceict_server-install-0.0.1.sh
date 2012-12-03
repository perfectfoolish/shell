#!/bin/bash
#set -e

redhat_check_dependencies()
{
	missing_packages=" "
	
	echo "Checking for mysql..."
	eval "rpm -q mysql > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo mysql is OK
	else
		echo mysql is FAILED
		missing_packages=$missing_packages"mysql "	
	fi

	echo "Checking for mysql-devel..."
	eval "rpm -q mysql-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo mysql-devel is OK
	else
		echo mysql-devel is FAILED
		missing_packages=$missing_packages"mysql-devel "	
	fi
	
	echo "Checking for mysql-server..."
	eval "rpm -q mysql-server > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo mysql-server is OK
	else
		echo mysql-server is FAILED
		missing_packages=$missing_packages"mysql-server "	
	fi
	
	echo "Checking for C development tools ..."
	eval "rpm -q gcc > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo gcc is OK
	else
		echo gcc is FAILED
		missing_packages=$missing_packages"gcc "
	fi

	echo "Checking for C++ development tools..."
	eval "rpm -q gcc-c++ > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo gcc-c++ is OK
	else		
		echo gcc-c++ is FAILED
		missing_packages=$missing_packages"gcc-c++ "
	fi

	echo "Checking for Make Utility..."
	eval "rpm -q make > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo make is OK
	else
		echo make is FAILED
		missing_packages=$missing_packages"make "
	fi

	echo "Checking for Ncurses Library..."
	eval "rpm -q ncurses > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo ncurses is OK
	else
		echo ncurses is FAILED
		missing_packages=$missing_packages"ncurses "	
	fi

	echo "Checking for ncurses-devel library..."
	eval "rpm -q ncurses-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo ncurses-devel is OK
	else
		echo ncurses-devel is FAILED
		missing_packages=$missing_packages"ncurses-devel "
		
	fi


	echo "Checking for bison ..."
	eval "rpm -q bison > /dev/null"
	if [ $? -eq 0 ]; then
		echo bison is OK
	else	
		echo bison is FAILED
		missing_packages=$missing_packages"bison "
	fi

	echo "Checking for bison-devel ..."
	eval "rpm -q bison-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo bison-devel is OK
	else
		echo bison-devel is FAILED
		missing_packages=$missing_packages"bison-devel "
	fi

	echo "Checking for openssl ..."
	eval "rpm -q openssl > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo openssl is OK
	else
		echo openssl is FAILED
		missing_packages=$missing_packages"openssl "
	fi

	echo "Checking for openssl-devel..."
	eval "rpm -q openssl-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo openssl-devel is OK
	else
		echo openssl-devel is FAILED
		missing_packages=$missing_packages"openssl-devel "
	fi

	echo "Checking for gnutls-devel..."
	eval "rpm -q gnutls-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo gnutls-devel is OK
	else
		echo gnutls-devel is FAILED
		missing_packages=$missing_packages"gnutls-devel "
	fi

	echo "Checking for zlib..."
	eval "rpm -q zlib > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo zlib is OK
	else
		echo zlib is FAILED
		missing_packages=$missing_packages"zlib "
	fi

	echo "Checking for zlib-devel..."
	eval "rpm -q zlib-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo zlib-devel is OK
	else
		echo zlib-devel is FAILED
		missing_packages=$missing_packages"zlib-devel "
	fi

	echo "Checking for kernel development packages..."
	eval "rpm -q kernel-devel-$(uname -r) > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo kernel-devel-$(uname -r) is OK
	else
		echo kernel-devel-$(uname -r) is FAILED
		missing_packages=$missing_packages"kernel-devel-$(uname -r) "
	fi

	echo "Checking for libxml2-devel..."
	eval "rpm -q libxml2-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		echo libxml2-devel is OK
	else
		echo libxml2-devel is FAILED
		missing_packages=$missing_packages"libxml2-devel "
	fi

	echo $missing_packages
	
	if [ "$missing_packages" != " " ]; then
		echo "WARNING: You are missing some prerequisites!!!"
		echo "Missing Packages $missing_packages\n"
		for package in $missing_packages
		do
			case $package in
				gcc)
				echo -e "\n C Compiler (gcc)."
				echo -e "	Required for compiling packages."
				echo -e "	Install gcc package(e.g yum install gcc)."
				;;

				g++)
				echo -e "\n C++ Compiler (g++)."
				echo -e "	Required for compiling packages."
				echo -e "	Install gcc-c++ package(e.g yum install gcc-c++)."
				;;

				make)
				echo -e "\n Make Utility. "
				echo -e "	Required for compiling packages."
				echo -e "	Install make package (e.g yum install make)."
				;;

				bash)
				echo -e "\n Bash v2 or higher."
				echo -e "	Required for installation and confiruration scripts."
				;;

				ncurses)
				echo -e "\n Ncurses Library."
				echo -e "	Required for compiling packages."
				echo -e "	Install ncurses development package(e.g yum install ncurses)."
				;;

				ncurses-devel)
				echo -e "	Ncurses-devel library."
				echo -e "	Required for compiling packages."
				echo -e "	Install ncurse development package(e.g yum install ncurses-devel)."
				;;

				bison)
				echo -e "\n Bison."
				echo -e "	Required for compiling packages."
				echo -e "	Install bison package (e.g yum install bison)."
				;;

				bison-devel)
				echo -e "\n Bison library."
				echo -e "	Required for compiling packages."
				echo -e "	Install bison-devel package (e.g yum install bison-devel)."
				;;

				openssl)
				echo -e "\n OpenSSL."
				echo -e "	Required for compiling packages."
				echo -e "	Install openssl package (e.g yum install openssl)."
				;;

				openssl-devel)
				echo -e "\n Gnutls Library."
				echo -e "	Required for compiling packages."
				echo -e "	Install gnutls-devel package(e.g yum install gnutls-devel)."
				;;

				zlib)
				echo -e "\n Zlib library."
				echo -e "	Required for compiling packages."
				echo -e "	Install zlib package (e.g yum install zlib)."
				;;

				zlib-devel)
				echo -e "\n Zlib development packages."
				echo -e "	Required for compiling packages."
				echo -e "	Install zlib-devel package(e.g yum install zlib-devel)."
				;;

				kernel-devel-$(uname -r))
				echo -e "\n Kernel development packages."
				echo -e "	Required for compiling packages."
				echo -e "	Install kernel-devel-$(uname -r) package (e.g yum install kernel-devel-$(uname -r))."
				;;

				libxml2-devel)
				echo -e "\n libxml2 development packages."
				echo -e "	Required for compiling packages."
				echo -e "	Install libxml2-devel packages(e.g yum install libxml2-devel)."
				;;
				
			esac
		done

		echo 
		
		for package in $missing_packages
		do
			echo "yum install -y $package"
			
			yum install -y $package
		done
		
	fi

	return 0
}

install_libpri()
{


	cd $LIBPRI_SOURCE_DIR

	tar zxvf *.tar.gz	

	cd libp* 

	make 
	if [ $? -ne 0 ]; then
		echo "Installing $LIBPRI_SOURCE_DIR: make ..."
	fi

	make install 
	if [ $? -ne 0 ]; then
		echo "Installing $LIBPRI_SOURCE_DIR: make install ..."
	fi

	echo "------------------------------------------------------------------------------------"
	echo "Installing $LIBPRI_SOURCE_DIR ..."
	echo OK

	cd $PROD_HOME

}

install_dahdi()
{


	cd $DAHDI_LINUX_COMPLETE_SOURCE_DIR

	tar zxvf *.tar.gz	

	cd dahd*

	make 
	if [ $? -ne 0 ]; then
		echo  "Installing $DAHDI_LINUX_COMPLETE_SOURCE_DIR: make ..."
	fi

	make install 
	if [ $? -ne 0 ]; then
		echo  "Installing $DAHDI_LINUX_COMPLETE_SOURCE_DIR: make install ..."
	fi

	make config
	if [ $? -ne 0 ]; then
		echo "Installing $DAHDI_LINUX_COMPLETE_SOURCE_DIR: make config ..."
	fi


	echo
	echo "------------------------------------------------------------------------------------"
	echo "Installing $DAHDI_LINUX_COMPLETE_SOURCE_DIR ..."
	echo OK
	echo "------------------------------------------------------------------------------------"

	cd $PROD_HOME

}

install_ffmpeg()
{
	echo
	cd $FFMPEG_SOURCE_DIR

	cp ./ffmpeg*.tar.bz2 /usr/local/include
	cd /usr/local/include
	tar jxvf ffmpeg*.tar.bz2
	cd ffmpeg*

	./configure
	if [ $? -ne 0 ]; then
		echo "Installing ffmpeg: ./configure ..."
	fi

	make 
	if [ $? -ne 0 ]; then
		echo "Installing ffmpeg: make ..."
	fi

	make install 
	if [ $? -ne 0 ]; then
		echo "Installing ffmpeg: make install ..."
	fi
	
	echo
	echo "------------------------------------------------------------------------------------------"
	echo "Installing ffmpeg ..."
	echo OK
	echo "------------------------------------------------------------------------------------------"
	
	cd $PROD_HOME

}

install_ceictims()
{
	echo

	cd $AST_SOURCE_DIR

    	tar -xzvf *.tar.gz
	cd ceict_server* 

	./configure 
	if [ $? -ne 0 ]; then
		echo "Installing Ceictims: ./configure ..."
	fi

	make 
	if [ $? -ne 0 ]; then
		echo "Installing Ceictims: make ..."
	fi

#	if [ -f menuselect.makeopts ] ; then 
#		text=`sed /MENUSELECT_ADDONS=/s/app_mysql\ // menuselect.makeopts`
#		echo "$text" > menuselect.makeopts
#		text=`sed /MENUSELECT_ADDONS=/s/\ msg_mysql\ res_config_mysql// menuselect.makeopts`
#		echo "$text" > menuselect.makeopts
#		text=`sed 's/MENUSELECT_EMBED=/&ADDONS/' menuselect.makeopts`
#		echo "$text" > menuselect.makeopts
#	fi
#
#	make
#	if [ $? -ne 0 ]; then
#		echo "Installing Ceictims: make ..."
#	fi

	make install 
	if [ $? -ne 0 ]; then
		echo "Installing Ceictims: make install ..."
	fi

	make samples 
	if [ $? -ne 0 ]; then
		echo "Installing Ceictims: make samples ..."
	fi
    
	make config 
	if [ $? -ne 0 ]; then
		echo "Installing Ceictims: make config ..."
	fi
	
	echo
	echo "------------------------------------------------------------------------------------------"
	echo "Installing Ceictims ..."
	echo OK
	echo "------------------------------------------------------------------------------------------"

	cd $PROD_HOME
}

fun_source_install()
{
	#install libpri
	if [ "$LIBPRI_AUTO_INSTALL" == "YES" ]; then
		install_libpri
	fi
	
	#install dahdi
	if [ "$DAHDI_AUTO_INSTALL" == "YES" ]; then
		install_dahdi
	fi

	#install ffmpeg
	if [ "$FFMPEG_AUTO_INSTALL" == "YES" ]; then
		install_ffmpeg
	fi

	# Install Ceictims
	if [ "$AST_AUTO_INSTALL" == "YES" ]; then
		install_ceictims
	fi	
}

deploy_mysql()
{
	service mysqld start

	mysqladmin -u root password '2011ceict'
	mysql -u root -p2011ceict < ./mysql/allowlocalhost.sql 
	
	if [ -f /etc/my.cnf ]; then
		mv /etc/my.cnf /etc/my.cnf.bak
		cp ./mysql/my.cnf /etc
	fi
	
	service mysqld restart

	mysql -u root -p2011ceict < ./mysql/ims.sql


}

add_conf()
{
	if [ -f /etc/ceictims/sip.conf ]; then
		mv /etc/ceictims/sip.conf /etc/ceictims/sip.conf.bak
		cp ./ceict_server/voip_conf/sip.conf /etc/ceictims
	fi
	
	if [ -f /etc/ceictims/extensions.conf ]; then
		mv /etc/ceictims/extensions.conf /etc/ceictims/extensions.conf.bak
		cp ./ceict_server/voip_conf/extensions.conf /etc/ceictims
	fi
	
	if [ -f /etc/ceictims/manager.conf ]; then
		mv /etc/ceictims/manager.conf /etc/ceictims/manager.conf.bak
		cp ./ceict_server/voip_conf/manager.conf /etc/ceictims
	fi
	
	cp ./ceict_server/voip_conf/res_mysql.conf /etc/ceictims
	cp ./ceict_server/voip_conf/ptt_group_options.conf /etc/ceictims
	cp ./ceict_server/voip_conf/sip_custom.conf /etc/ceictims/

	touch /etc/ceictims/sip_ceict.conf
	touch /etc/ceictims/sip_custom_post.conf
	touch /etc/ceictims/extensions_ceict.conf
	touch /etc/ceictims/extensions_ptt.conf
	touch /etc/ceictims/extensions_custom.conf
	touch /etc/ceictims/ptt_intercom_group.conf
	touch /etc/ceictims/ptt_default_group.conf

}

ip_control()
{
	cp ./ceict_server/ipdispatch_conf/extensions_dispatch.conf /etc/ceictims
	cp ./ceict_server/ipdispatch_conf/ceict_conf.sh /var/lib/ceictims/agi-bin/
	cp ./ceict_server/ipdispatch_conf/ceict_broadcast.sh /var/lib/ceictims/agi-bin/
	chmod +x /var/lib/ceictims/agi-bin/ceict_conf.sh
	chmod +x /var/lib/ceictims/agi-bin/ceict_broadcast.sh
	mkdir -p /var/lib/ceictims/agi-bin/zdzt
	chmod 775 /var/lib/ceictims/agi-bin/zdzt
	groupadd ceictims
	useradd ceictims -g ceictims
	chown ceictims:ceictims /var/lib/ceictims/agi-bin/zdzt
}

#The directory which store files what is used for installing
FULL_PATH="$0"
PROD_HOME=$(cd ${FULL_PATH%/*}; pwd)

#libpri dahdi and ceictims source code path
FFMPEG_SOURCE_DIR="./ffmpeg"
LIBPRI_SOURCE_DIR="./libpri"
DAHDI_LINUX_COMPLETE_SOURCE_DIR="./dahdi-linux-complete"
AST_SOURCE_DIR="./ceict_server"

LIBPRI_AUTO_INSTALL="YES"
DAHDI_AUTO_INSTALL="YES"
FFMPEG_AUTO_INSTALL="YES"
AST_AUTO_INSTALL="YES"

#chmod -R +x *

redhat_check_dependencies

fun_source_install

#Close SELinux

text=`sed /SELINUX=enforcing/s/enforcing/disabled/ /etc/selinux/config`
echo "$text" > /etc/selinux/config

#deploy mysql

deploy_mysql

#add configuration files
add_conf

#ip  control
ip_control

#Permanent close to the firewall and Add powered up

chkconfig --level 2345 iptables off
chkconfig --level 35 mysqld on

# echo /root/.src/ems.sh >> /etc/rc.d/rc.local

#restart

reboot

