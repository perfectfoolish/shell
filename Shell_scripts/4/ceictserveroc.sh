#!/bin/bash 

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

#	echo "Checking for kernel development packages..."
#	eval "rpm -q kernel-devel-$(uname -r) > /dev/null 2>&1"
#	if [ $? -eq 0 ]; then
#		echo kernel-devel-$(uname -r) is OK
#	else
#		echo kernel-devel-$(uname -r) is FAILED
#		missing_packages=$missing_packages"kernel-devel-$(uname -r) "
#	fi

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

				#kernel-devel-$(uname -r))
				#echo -e "\n Kernel development packages."
				#echo -e "	Required for compiling packages."
				#echo -e "	Install kernel-devel-$(uname -r) package (e.g yum install kernel-devel-$(uname -r))."
				#;;

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

install_asterisk()
{
	echo

	cd $AST_SOURCE_DIR

    	tar -xzvf *.tar.gz
	cd asterisk* 

	./configure 
	if [ $? -ne 0 ]; then
		echo "Installing Asterisk: ./configure ..."
	fi

	make 
	if [ $? -ne 0 ]; then
		echo "Installing Asterisk: make ..."
	fi

	make install 
	if [ $? -ne 0 ]; then
		echo "Installing Asterisk: make install ..."
	fi

	make samples 
	if [ $? -ne 0 ]; then
		echo "Installing Asterisk: make samples ..."
	fi
    
	make config 
	if [ $? -ne 0 ]; then
		echo "Installing Asterisk: make config ..."
	fi
	
	echo
	echo "------------------------------------------------------------------------------------------"
	echo "Installing Asterisk ..."
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

	# Install Asterisk
	if [ "$AST_AUTO_INSTALL" == "YES" ]; then
		install_asterisk
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

voip_conf()
{
	if [ -f /etc/asterisk/sip.conf ]; then
		mv /etc/asterisk/sip.conf /etc/asterisk/sip.conf.bak
		cp ./ceict_server/voip_conf/sip.conf /etc/asterisk
	fi
	
	if [ -f /etc/asterisk/extensions.conf ]; then
		mv /etc/asterisk/extensions.conf /etc/asterisk/extensions.conf.bak
		cp ./ceict_server/voip_conf/extensions.conf /etc/asterisk
	fi
	

}

group_conf()
{
	cp ./ceict_server/group/ceict_conf.sh /var/lib/asterisk/agi-bin
	chmod +x /var/lib/asterisk/agi-bin/ceict_conf.sh
	mkdir -p /var/lib/asterisk/agi-bin/zdzt
}

sounds()
{
	rm -rf /var/lib/asterisk/sounds
	cp ./ceict_server/sounds /var/lib/asterisk
	rm -rf /var/lib/asterisk/moh/*wav
}

#The directory which store files what is used for installing
FULL_PATH="$0"
PROD_HOME=$(cd ${FULL_PATH%/*}; pwd)

#libpri dahdi and asterisk source code path
LIBPRI_SOURCE_DIR="./libpri"
DAHDI_LINUX_COMPLETE_SOURCE_DIR="./dahdi-linux-complete"
AST_SOURCE_DIR="./ceict_server"

LIBPRI_AUTO_INSTALL="YES"
DAHDI_AUTO_INSTALL="YES"
AST_AUTO_INSTALL="YES"


redhat_check_dependencies

fun_source_install

#Close SELinux

text=`sed /SELINUX=enforcing/s/enforcing/disabled/ /etc/selinux/config`
echo "$text" > /etc/selinux/config

#deploy mysql

deploy_mysql

#add configuration files
voip_conf

#Permanent close to the firewall and Add powered up

chkconfig --level 2345 iptables off
chkconfig --level 35 mysqld on


#restart

reboot

