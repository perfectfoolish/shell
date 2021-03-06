#!/bin/bash
#Program:
#  Use to install all the service by rpm
#History:
# 2012/11/21 modified by az00000000@126.com  First release

ROOT_UID=0
OS="Red Hat"

# Log file
LOG_ENABLE=YES
LOG_DIR="/root/log"
INSTALL_LOG="${LOG_DIR}/install.log.$(date +%F-%H-%M)"

# Create log dir
mkdir -p $LOG_DIR

# Clear log file
cat /dev/null > "$INSTALL_LOG"

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
check_succeed_fail()
{
    if [ $? -eq 0 ]; then
        show_status OK 
    else
        show_status FAILED
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
#ntp server
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
    if [ $? -ne 0 ]; then
        return 1
    fi
}

# check the version of kernel and kernel-devel
check_install_kernel()
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
        logger "NOTE: You MUST reboot your system NOW! then run script onece more !\n" 1 0

        exit 1
    fi
}

redhat_check_dependencies()
{
    missing_packages=" "

    logger "Checking for vsftpd ..."
    rpm -q vsftpd > /dev/null
    if [ $? -eq 0 ]; then
        show_status OK
    else
        show_status FAILED
        missing_packages=$missing_packages"vsftpd"
    fi

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

    logger "Checking for rpm-build..."
    rpm -q rpm-build > /dev/null
    if [ $? -eq 0 ]; then
        show_status OK
    else
        show_status FAILED
        missing_packages=$missing_packages"rpm-build "
    fi

    if [ "$missing_packages" != " " ]; then
        echo "WARNING: You are missing some prerequisites!!!"
        logger "Missing Packages $missing_packages\n"
        for package in $missing_packages; do
            case $package in
                vsftpd)
                echo -e "\n vsftpd."
                echo -e "   Required for vsftpd packages."
                echo -e "   Install vsftpd package(e.g yum install vsftpd)."
                ;;
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

#--------------Start---------------------------------------
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
check_succeed_fail

#check and intall the lastest kernel and kernel-devel
check_install_kernel

# Close SElinux
sed -i '/SELINUX=enforcing/s/enforcing/disabled/' /etc/selinux/config
check_succeed_fail

# Close Iptable
service iptables stop
service ip6tables stop
chkconfig iptables off
chkconfig ip6tables off

#Uninstall java enviromment in the system
rpm -qa | grep java 
if [ $? -eq 0 ] ; then
    rpm -qa | grep java | xargs yum -y remove
else
   :
fi

#if [ $? -ne 0 ]; then
#    show_status FAILED 0 1
#    logger "ERROR: Uninstall java failed.\n" 1 0
#    exit 1
#else
#    show_status OK 0 1
#fi
#
redhat_check_dependencies

#create rpm for dahdi
cp ./dahdi/dahdi-linux* /usr/src/redhat/SOURCES/
check_succeed_fail

rpmbuild -bb ./dahdi/dahdi.spec
check_succeed_fail

cp /usr/src/redhat/RPMS/i386/*.rpm /root/CMT_INSTALL/RPMS
check_succeed_fail

#install libpri
rpm -ivh /root/CMT_INSTALL/RPMS/libpri*
check_succeed_fail

#install dahdi
rpm -ivh /root/CMT_INSTALL/RPMS/dahdi*
check_succeed_fail

#program to generate modules.dep and map files.
depmod

#start dahdi
service dahdi start
check_succeed_fail

#
rpm -ivh /root/CMT_INSTALL/RPMS/ceict*
check_succeed_fail

rpm -ivh /root/CMT_INSTALL/RPMS/jdk*
check_succeed_fail

rpm -ivh /root/CMT_INSTALL/RPMS/jetty*
check_succeed_fail

rpm -ivh /root/CMT_INSTALL/RPMS/CMT*
check_succeed_fail

logger "NOTE: You MUST reboot your system NOW! then install seccessfully !\n" 1 0
#--------------End---------------------------------------
echo -e "\033[30;32m green color \033[0m"
