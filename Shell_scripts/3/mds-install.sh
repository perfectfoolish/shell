#! /bin/sh
#
# mds-install.sh - Script of installing Multimedia Dispatching System server. Include:
# 		Trunk    --- The modified Asterisk source code.
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
RPMS_DIR=${PROD_HOME}/RPMS

# Install Path
LIBPRI_INSTALL_DIR="/root/src/libpri"
DAHDI_INSTALL_DIR="/root/src/dahdi"
AST_INSTALL_DIR="/root/src/asterisk"
FFMPEG_INSTALL_DIR="/usr/local/include"

# Log file
LOG_ENABLE=YES
LOG_DIR="/root/src/log"
INSTALL_LOG="${LOG_DIR}/install.log.$(date +%F-%H-%M)"

LIBPRI_AUTO_INSTALL="YES"
DAHDI_AUTO_INSTALL="YES"
AST_AUTO_INSTALL="YES"
FFMPEG_AUTO_INSTALL="YES"

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

install_dependencies()
{
	KERNEL_VERSION=`uname -r`
	
	cd $RPMS_DIR
	if [ ! -d ./installed ]; then
		mkdir -p ./installed
	fi
	for filename in `ls *.rpm 2>/dev/null`; do
		packagename=${filename%.i[36]86.rpm}
		logger "Checking the package $packagename ..."
		rpm -q $packagename > /dev/null
		if [ $? -eq 0 ]; then
			show_status OK
			mv $filename ./installed
		else
			show_status FAILED
		fi
	done
	
	ls *.rpm 1>/dev/null 2>/dev/null && rpm -ivhU *.rpm | tee -a $INSTALL_LOG
	mv ./installed/*.rpm ./
	rm -rf ./installed
	sed -i "/default=1/s/1/0/" /boot/grub/menu.lst
	rpm -q kernel-devel-$KERNEL_VERSION > /dev/null
	if [ $? -ne 0 ]; then
		echo ""
		logger "NOTE: You should reboot your system NOW!\n" 1 0
		exit
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

# Install asterisk
install_asterisk()
{
	mkdir -p $AST_INSTALL_DIR

	if [ ! -f $CODE_SRC_DIR/trunk.tar.gz ]; then
	    logger "ERROR: Asterisk package lost.\n" 1 0
		return 1
	else
		if [ -d $AST_INSTALL_DIR/trunk ]; then
			rm -rf $AST_INSTALL_DIR/trunk
		fi
		tar -zxf $CODE_SRC_DIR/trunk.tar.gz -C $AST_INSTALL_DIR

		chmod -R +x $AST_INSTALL_DIR/trunk
		cd $AST_INSTALL_DIR/trunk
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
		logger "Installling asterisk ..." 0 1 
		install_asterisk
		if [ $? -eq 0 ]; then
			show_status OK 0 1
		else
			show_status FAILED 0 1
			logger "ERROR: Install asterisk failed!\n" 1 0
			exit 1
		fi

	fi	
}

config_file()
{
	\cp $FILE_SRC_DIR/*.conf /etc/asterisk/
	touch /etc/asterisk/sip_ceict.conf
	touch /etc/asterisk/sip_custom_post.conf
	touch /etc/asterisk/extensions_ceict.conf
	touch /etc/asterisk/extensions_ptt.conf
	touch /etc/asterisk/extensions_custom.conf
	touch /etc/asterisk/ptt_intercom_group.conf
	touch /etc/asterisk/ptt_default_group.conf
	touch /etc/asterisk/ptt_group_options.conf
}

sh_file()
{
	chmod +x $FILE_SRC_DIR/*.sh
	\cp $FILE_SRC_DIR/*.sh /var/lib/asterisk/agi-bin/

	mkdir -p /var/lib/asterisk/agi-bin/zdzt
	chmod 775 /var/lib/asterisk/agi-bin/zdzt
	groupadd asterisk
	useradd asterisk -g asterisk
	chown asterisk:asterisk /var/lib/asterisk/agi-bin/zdzt

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

# Check dependences
install_dependencies

# Install source code
fun_source_install

# Close SElinux
sed -i '/SELINUX=enforcing/s/enforcing/disabled/' /etc/selinux/config

# Deploy files
deploy_files

# Deploy mysql
deploy_mysql

# Close iptable
chkconfig --level 2345 iptables off

# Mysql auto run
chkconfig --level 35 mysqld on

reboot

