#! /bin/sh 
#
# mds-install.sh - Script of installing Multimedia Dispatching System server. Include:
# 		Trunk    --- The modified Ceictims source code.
#       Libpri   --- The libpri source code.
#       Dahdi    --- The dahdi source code.
#       Ffmpeg   --- The ffmpeg source code.
#       Web      --- The web for the MDS.
#
# Modified by zhen.li<zhen.li@ceict.com.cn>
#
#

ROOT_UID=0
OS="Red Hat"

FULL_PATH="$0"
PROD_HOME=`cd ${FULL_PATH%/*}; pwd`
CODE_SRC_DIR=${PROD_HOME}/src
FILE_SRC_DIR=${PROD_HOME}/files
MYSQL_SRC_DIR=${PROD_HOME}/mysql

# Install Path
LIBPRI_INSTALL_DIR="/root/src/libpri"
DAHDI_INSTALL_DIR="/root/src/dahdi"
AST_INSTALL_DIR="/root/src/ceictserver"
FFMPEG_INSTALL_DIR="/usr/local/include"

# Log file
LOG_ENABLE=YES
LOG_DIR="/root/src/log"
INSTALL_LOG="${LOG_DIR}/install.log.$(date +%F-%H-%M)"

LIBPRI_AUTO_INSTALL="YES"
DAHDI_AUTO_INSTALL="YES"
AST_AUTO_INSTALL="YES"
FFMPEG_AUTO_INSTALL="NO"

# Create log dir
mkdir -p $LOG_DIR

# Clear log file
cat /dev/null > "$INSTALL_LOG"

#---------------------------------------------------------------------------------------

# Save Logger Information
logger()
{
    if [ "$2" == "0" ]; then
        :
    else
        echo -ne "$1"
    fi

    if [ "$LOG_ENABLE" == "YES" ]; then
        if [ "$3" == "0" ]; then
            :
        else
            echo -ne "$(LANG=C date) : $1" >> "$INSTALL_LOG"
        fi
    fi
}

# OS is 'Red Hat' ?
check_os()
{
    cat /proc/version | grep "$OS" > /dev/null
    if [ $? -ne 0 ]; then
        return 1
    fi
}

show_status()
{
    if [ "$2" == "0" ]; then
        :
    else
		logger "\r\t\t\t\t\t\t\t\t\t\t[ $1 ]\n" 1 0
    fi

    if [ "$LOG_ENABLE" == "YES" ]; then
        if [ "$3" == "0" ]; then
            :
        else
			echo "" >> "$INSTALL_LOG"
			echo -ne "$(LANG=C date) : \t\t\t\t\t\t\t\t\t\t[ $1 ]\n" >> "$INSTALL_LOG"
		fi
	fi
    
}

modify_time()
{
	rpm -q ntp > /dev/null
	if [ $? -ne 0 ]; then
		yum install -y ntp
		if [ $? -ne 0 ]; then
			return 1
		fi
	fi
		
	ntpdate us.pool.ntp.org 
	if [$? -ne 0 ]; then
		return 1
	fi
}

# cheack the version of kernel and kernel-devel
check_kernel_version()
{
	logger "Checking for Kernel development packages..."
	rpm -q kernel-devel-$(uname -r) > /dev/null
	if [ $? -eq 0 ]; then
    	show_status OK
	else
    	show_status FAILED

		logger "Installing the lastest Kernel ..." 0 1
		yum install -y kernel
		if [ $? -ne 0 ]; then
			show_status FAILED 0 1
			logger "ERROR: Install Kernel failed. Please check the network.\n" 1 0
			exit 1
		else 
			show_status OK 0 1
		fi

		logger "Installing the lastest Kernel-devel ..." 0 1
		yum install -y kernel-devel
		if [ $? -ne 0 ]; then
			show_status FAILED 0 1
			logger "ERROR: Install Kernel-devel failed. Please check the network.\n" 1 0
			exit 1
		else
			show_status OK 0 1
		fi
	
		sed -i '/default=/s/1/0/' /boot/grub/menu.lst
		
		echo ""
		logger "NOTE: You should reboot your system NOW!\n" 1 0
	
		exit 1
	fi
}


redhat_check_dependencies()
{
	check_kernel_version

	missing_packages=" "
	
	logger "Checking for Mysql ..."
	rpm -q mysql > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"mysql "
	fi
	
	logger "Checking for Mysql-devel ..."
	rpm -q mysql-devel > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"mysql-devel "
	fi

	logger "Checking for Mysql-server ..."
	rpm -q mysql-server > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"mysql-server "
	fi

	logger "Checking for GCC  ..."
	rpm -q gcc > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		gcc --version > /dev/null
		if [  $? -eq 0 ]; then
			show_status OK
		else
			show_status FAILED
			missing_packages=$missing_packages"gcc "
		fi
	fi
	
	logger "Checking for GCC-C++ ..."
	rpm -q gcc-c++ > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		g++ --version > /dev/null
		if [  $? -eq 0 ]; then
			show_status OK
		else
			show_status FAILED
			missing_packages=$missing_packages"gcc-c++ "
		fi
	fi
	
	logger "Checking for Make Utility..."
	rpm -q make > /dev/null
	if [ $? -eq 0 ]; then
    	show_status OK
	else
        make --version > /dev/null
		if [ $? -eq 0 ]; then
			show_status OK
		else
			show_status FAILED
			missing_packages=$missing_packages"make "
		fi
	fi
	
	logger "Checking for Ncurses ..."
	rpm -q ncurses > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"ncurses "
	fi

	logger "Checking for Ncurses-devel ..."
	rpm -q ncurses-devel > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"ncurses-devel "
	fi

	logger "Checking for Bison ..."
	rpm -q bison > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"bison "
	fi

	logger "Checking for Bison-devel ..."
	rpm -q bison-devel > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"bison-devel "
	fi

	logger "Checking for Openssl ..."
	rpm -q openssl > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"openssl "
	fi
	
	logger "Checking for Openssl-devel..."
	rpm -q openssl-devel > /dev/null
	if [ $? -eq 0 ]; then
	    show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"openssl-devel "
	fi

	logger "Checking for Gnutls-devel..."
	rpm -q gnutls-devel > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"gnutls-devel "
	fi

	logger "Checking for Zlib..."
	rpm -q zlib > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"zlib "
	fi

	logger "Checking for Zlib-devel..."
	rpm -q zlib-devel > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"zlib-devel "
	fi

	logger "Checking for Libxml2-devel..."
	rpm -q libxml2-devel > /dev/null
	if [ $? -eq 0 ]; then
		show_status OK
	else
		show_status FAILED
		missing_packages=$missing_packages"libxml2-devel "
	fi
	
	if [ "$missing_packages" != " " ]; then
		echo "WARNING: You are missing some prerequisites!!!"
		logger "Missing Packages $missing_packages\n"
		for package in $missing_packages; do
			case $package in
				mysql)
					echo -e "\n Mysql."
					echo -e "   Required for mysql packages."
					echo -e "   Install mysql package(e.g yum install mysql)."
					;;
				mysql-devel)
					echo -e "\n Mysql-devel."
					echo -e "   Required for mysql-devel packages."
					echo -e "   Install mysql-devel package(e.g yum install mysql-devel)."
					;;
				mysql-server)
					echo -e "\n Mysql-server."
					echo -e "   Required for mysql-server packages."
					echo -e "   Install mysql-server package(e.g yum install mysql-server)."
					;;
				gcc)
					echo -e "\n C Compiler (gcc)."
					echo -e "   Required for compiling packages."
					echo -e "   Install gcc package(e.g yum install gcc)."
					;;

				gcc-c++)
					echo -e "\n C++ Compiler (g++)."
					echo -e "   Required for compiling packages."
					echo -e "   Install gcc-c++ package(e.g yum install gcc-c++)."
					;;

				make)
					echo -e "\n Make"
					echo -e "   Required for compiling packages."
					echo -e "   Install make package (e.g yum install make)."
					;;

				ncurses)
					echo -e "\n Ncurses"
					echo -e "   Required for compiling packages."
					echo -e "   Install ncurses development package(e.g yum install ncurses)."
					;;

				ncurses-devel)
					echo -e "\n Ncurses-devel"
					echo -e "   Required for compiling packages."
					echo -e "   Install ncurse development package(e.g yum install ncurses-devel)."
					;;
				
				bison)
					echo -e "\n Bison."
					echo -e "   Required for compiling packages."
					echo -e "   Install bison package (e.g yum install bison)."
					;;

				bison-devel)
					echo -e "\n Bison-devel"
					echo -e "   Required for compiling packages."
					echo -e "   Install bison-devel package (e.g yum install bison-devel)."
					;;

				openssl)
					echo -e "\n Openssl."
					echo -e "   Required for compiling packages."
					echo -e "   Install openssl package (e.g yum install openssl)."
					;;

				openssl-devel)
					echo -e "\n Openssl-devel."
					echo -e "   Required for compiling packages."
					echo -e "   Install openssl-devel package(e.g yum install openssl-devel)."
					;;

				gnutls-devel)
					echo -e "\n Gnutls-devel."
					echo -e "   Required for compiling packages."
					echo -e "   Install gnutls-devel package(e.g yum install gnutls-devel)."
					;;
				
				zlib)
					echo -e "\n Zlib"
					echo -e "   Required for compiling packages."
					echo -e "   Install zlib package (e.g yum install zlib)."
					;;

				zlib-devel)
					echo -e "\n Zlib-devel"
					echo -e "   Required for compiling packages."
					echo -e "   Install zlib-devel package(e.g yum install zlib-devel)."
					;;

				libxml2-devel)
						echo -e "\n libxml2-devel"
						echo -e "   Required for compiling packages."
						echo -e "   Install libxml2-devel packages(e.g yum install libxml2-devel)."
						;;

			esac
		done

		for package in $missing_packages; do
			logger "Installing $package ..." 0 1
			yum install -y $package
			if [ $? -ne 0 ]; then
				show_status FAILED 0 1
				logger "ERROR: Install $package online failed. Please check the network.\n" 1 0
				exit 1
			else
				show_status OK 0 1
			fi
		done
	fi

}

# Install libpri
install_libpri()
{
	mkdir -p $LIBPRI_INSTALL_DIR

	if [ ! -f $CODE_SRC_DIR/libpri*.tar.gz ]; then
		logger "ERROR: Libpri package lost.\n" 1 0
		return 1
	else
		if [ -d $LIBPRI_INSTALL_DIR/libpri* ]; then
			rm -rf $LIBPRI_INSTALL_DIR/libpri*
		fi
		tar -zxf $CODE_SRC_DIR/libpri*.tar.gz -C $LIBPRI_INSTALL_DIR
		cd $LIBPRI_INSTALL_DIR/libpri*

		make 
		if [ $? -ne 0 ]; then
			return 1
		fi

		make install 
		if [ $? -ne 0 ]; then
			return 1
		fi

	fi
}

# Install dahdi
install_dahdi()
{
	mkdir -p $DAHDI_INSTALL_DIR

	if [ ! -f $CODE_SRC_DIR/dahdi*.tar.gz ]; then
		logger "ERROR: Dahdi package lost.\n" 1 0
		return 1
	else
		if [ -d $DAHDI_INSTALL_DIR/dahdi* ]; then
			rm -rf $DAHDI_INSTALL_DIR/dahdi*
		fi
		tar -zxf $CODE_SRC_DIR/dahdi*.tar.gz -C $DAHDI_INSTALL_DIR
		cd $DAHDI_INSTALL_DIR/dahdi*

		make 
		if [ $? -ne 0 ]; then
			return 1
		fi

		make install 
		if [ $? -ne 0 ]; then
			return 1
		fi

		make config
		if [ $? -ne 0 ]; then
			return 1
		fi
		
	fi
}

# Install ffmpeg
install_ffmpeg()
{
	mkdir -p $FFMPEG_INSTALL_DIR

	if [ ! -f $CODE_SRC_DIR/ffmpeg*.tar.bz2 ]; then
		logger "ERROR: Ffmpeg package lost.\n" 1 0
		return 1
	else
		if [ -d $FFMPEG_INSTALL_DIR/ffmpeg* ]; then
			rm -rf $FFMPEG_INSTALL_DIR/ffmpeg*
		fi

		tar -jxf $CODE_SRC_DIR/ffmpeg*.tar.bz2 -C $FFMPEG_INSTALL_DIR
		
		cd $FFMPEG_INSTALL_DIR/ffmpeg*

		./configure
		if [ $? -ne 0 ]; then
			return 1
		fi

		make
		if [ $? -ne 0 ]; then
			return 1
		fi

		make install
		if [ $? -ne 0 ]; then
			return 1
		fi

	fi
}

# Install ceictserver
install_ceictserver()
{
	mkdir -p $AST_INSTALL_DIR

	ls $CODE_SRC_DIR/ceictserver*.tar.gz > /dev/null 2>&1
	if [ $? -ne 0 ] ;then
	    logger "ERROR: ceictserver package lost.\n" 1 0
	    return 1
	else
	    ls $AST_INSTALL_DIR/ceictserver* > /dev/null 2>&1
	    if [ $? -eq 0 ]; then
	        rm -rf $AST_INSTALL_DIR/ceictserver*
	    fi
		tar -zxf $CODE_SRC_DIR/ceictserver*.tar.gz -C $AST_INSTALL_DIR

		chmod -R +x $AST_INSTALL_DIR/ceictserver*
		cd $AST_INSTALL_DIR/ceictserver*
		./configure
		if [ $? -ne 0 ]; then
			return 1
		fi

		make
		if [ $? -ne 0 ]; then
			return 1
		fi

		make install
		if [ $? -ne 0 ]; then
			return 1
		fi
		
		make samples
		if [ $? -ne 0 ]; then
			return 1
		fi

		make config
		if [ $? -ne 0 ]; then
			return 1
		fi
	fi
}

fun_source_install()
{
	if [ "$LIBPRI_AUTO_INSTALL" == "YES" ]; then
		logger "Installling libpri ..." 0 1
		install_libpri
		if [ $? -eq 0 ]; then
			show_status OK 0 1
		else
			show_status FAILED 0 1
			logger "ERROR: Install libpri failed!\n" 1 0
			exit 1
		fi

	fi
	
	if [ "$DAHDI_AUTO_INSTALL" == "YES" ]; then
		logger "Installling dahdi ..." 0 1
		install_dahdi
		if [ $? -eq 0 ]; then
			show_status OK 0 1
			service dahdi start
		else
			show_status FAILED 0 1
			logger "ERROR: Install dahdi failed!\n" 1 0
			exit 1
		fi
	fi

	if [ "$FFMPEG_AUTO_INSTALL" == "YES" ]; then
		logger "Installling ffmpeg ..." 0 1
		install_ffmpeg
		if [ $? -eq 0 ]; then
		    show_status OK 0 1
		else
			show_status FAILED 0 1
			logger "ERROR: Install ffmpeg failed!\n" 1 0
		fi
	fi

	if [ "$AST_AUTO_INSTALL" == "YES" ]; then
		logger "Installling ceictserver ..." 0 1 
		install_ceictserver
		if [ $? -eq 0 ]; then
			show_status OK 0 1
		else
			show_status FAILED 0 1
			logger "ERROR: Install ceictserver failed!\n" 1 0
			exit 1
		fi

	fi	
}

config_file()
{
	\cp $FILE_SRC_DIR/*.conf /etc/ceictims/
	touch /etc/ceictims/sip_ceict.conf
	touch /etc/ceictims/sip_custom_post.conf
	touch /etc/ceictims/extensions_ceict.conf
	touch /etc/ceictims/extensions_ptt.conf
	touch /etc/ceictims/extensions_custom.conf
	touch /etc/ceictims/ptt_intercom_group.conf
	touch /etc/ceictims/ptt_default_group.conf
	touch /etc/ceictims/ptt_group_options.conf
}

sh_file()
{
	chmod +x $FILE_SRC_DIR/*.sh
	\cp $FILE_SRC_DIR/*.sh /var/lib/ceictims/agi-bin/

	mkdir -p /var/lib/ceictims/agi-bin/zdzt
	chmod 775 /var/lib/ceictims/agi-bin/zdzt
	groupadd ceictims
	useradd ceictims -g ceictims
	chown ceictims:ceictims /var/lib/ceictims/agi-bin/zdzt

}

deploy_files()
{
	config_file
	sh_file
}

deploy_mysql()
{
	service mysqld start

	mysqladmin -u root password '2011ceict'
	mysql -u root -p2011ceict < $MYSQL_SRC_DIR/allowlocalhost.sql 
				
	\cp $MYSQL_SRC_DIR/my.cnf /etc/
											
	service mysqld restart

	mysql -u root -p2011ceict < $MYSQL_SRC_DIR/ims.sql
}

#---------------------------------------------------------------------------------------

# Check user
if [ "$UID" -ne "$ROOT_UID" ]; then
    logger "ERROR: Must be root to run this script!\n" 1 0
    exit 1
fi

# Check OS
check_os
if [ $? -ne 0 ]; then
	logger "ERROR: This script must be run on $OS system\n" 1 0
	exit 1
fi

# Modify the system time
logger "modify the system time ..."
modify_time
if [ $? -eq 0 ]; then
	show_status OK 
else
	show_status FAILED
fi

# Check dependences
redhat_check_dependencies

# Install source code
fun_source_install

# Close SElinux
sed -i '/SELINUX=enforcing/s/enforcing/disabled/' /etc/selinux/config

# Deploy files
deploy_files

# Deploy mysql
deploy_mysql

# Close iptable
service iptables stop
service ip6tables stop
chkconfig iptables off
chkconfig ip6tables off

# Mysql auto run
chkconfig --level 35 mysqld on

#reboot

