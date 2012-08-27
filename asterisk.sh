#!/bin/bash
#
# install.sh - Script of installing Asterisk and DAHDI Sources.
#
# Modified by joe.yeung<yangjiazhi@live.com>
#
# $Id$
# NOTES:
# This program is free software, no any warrant.Author of this script will not 
# accept any responsibilies if it brings hazards to you. The main purpose of this script
# is using for telephony communication.Meanwhile,please contact me right away if it
# infringes your copyright(s).
#------------------------------------------------------------------------
# Clear the screen
#------------------------------------------------------------------------

clearscr()
{
    if [ $SETUP_INSTALL_QUICK = "YES" ]; then
        return
    fi

    if test $NONINTERACTIVE; then
        return
    fi
    # Check if the terminal environment was set up
    [ "$TERM" ] && clear 2> /dev/null
}

# ----------------------------------------------------------------------
# Check Bash
# ----------------------------------------------------------------------

check_bash()
{
    BASH_SUPPORT=`echo $BASH_VERSION | cut -d'.' -f1 2> /dev/null`
    test -z $BASH_SUPPORT && echo "Bash doesn't exist!" && exit 1
}

# ---------------------------------------------------------------------
# Display Banner
# ---------------------------------------------------------------------

banner()
{
    if test -z $NONINTERACTIVE; then
        clearscr
    fi

    echo -e "##########################################################"
    echo -e "#         Script of Installing Asterisk and DAHDI        #"
    echo -e "#                   V$PROD_VERSION                               #"
    echo -e "#                                                        #"
    echo -e "#             AsteriskVoIP Enthusiast                    #"
    echo -e "#      No any warrant of this script,please note!        #"
    echo -e "##########################################################"

    echo ""

    return 0
}
# ---------------------------------------------------------------------
# Save Logger Information
# ---------------------------------------------------------------------

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

# --------------------------------------------------------------------
# Display Error Messages
# --------------------------------------------------------------------
error()
{
    echo -ne "Error: $*" >&2

    if [ "$LOG_ENABLE" == "YES" ]; then
        echo -ne "$(LANG = C date) : Error: $*" >> "$INSTALL_LOG"
    fi
}

# ----------------------------------------------------------------------------
# Pause.
# ----------------------------------------------------------------------------
pause()
{
    [ $# -ne 0 ] && sleep $1 >&2 >> /dev/null && return 0
    echo -e "Press [Enter] to continue...\c"
    read tmp

    return 0
}

# --------------------------------------------------------------------
# Prompt Users To Input Information
# --------------------------------------------------------------------

prompt()
{
    if test $NONINTERACTIVE; then
        return 0
    fi

    echo -ne "$*" >&2
    read CMD rest            
    return 0
}

# -------------------------------------------------------------------
# Get YES/NO input
# -------------------------------------------------------------------

getyn()
{
    if test $NONINTERACTIVE; then
        return 0
    fi

    while prompt "$* (y/n) "
    do	case $CMD in
        [Yy]) return 0
        ;;
    [Nn]) return 1
        ;;
    *) echo -e "\n Please input y or n" >&2
        ;;
esac
    done
}

# -------------------------------------------------------------------
# Select an item from the list(s).
# $SEL: the available choices
# Return:   0 -selection is in $SEL
#           1 -quit or empty list
# -------------------------------------------------------------------

get_select()
{
    [ $# -eq 0 ] && return 1

    while prompt "Please enter your selection (1...$# or q) ->"
    do	case ${CMD:="0"} in
        [0-9]|[0-9][0-9])
        [ $CMD -lt 1 -o $CMD -gt $# ] && echo -e "\n Error: Invalid Option,input a value between 1 and $# \n" && continue
        SEL=$CMD
        return 0
        ;;
    q|Q)
        SEL="q"
        return 1
        ;;
esac
    done
}

# -------------------------------------------------------------------
# Select an item from the list(s).
# -------------------------------------------------------------------

select_list()
{
    [ $# -eq 0 ] && return 1

    col=`expr $# / 10 + 1`
    cnt=0

    for option in "$@"
    do 
        cnt=`expr $cnt + 1`
        echo -en "\t$cnt) $option"
        [ `expr $cnt % $col` -eq 0 ] && echo ""
    done
    echo -e "\tq) quit\n"
    get_select "$@"
}

show_status()
{
    if [ "$LOG_ENABLE" == "YES" ]; then
        echo "" >> "$INSTALL_LOG"
        echo -ne "$(LANG=C date) : \t\t\t\t\t\t[ $1 ]\n" >> "$INSTALL_LOG"
    fi
    logger "\r\t\t\t\t\t\t\t\t[ $1 ]\n" 1 0
}

error_compile()
{
    echo 
    tail -n 50 "$INSTALL_LOG"
    echo "--------------------------------------------------"
    logger "$1"
    show_status Failed
    echo "--------------------------------------------------"
    exit 1
}

backup_file()
{
    \cp -a "$1" "$1.$(date +%F-%k-%M)"
    if [ $? -ne 0 ]; then
        return 1
    fi
}

check_file()
{
    if [ ! -f "$1"]; then
        echo "-----------------------------------------------------"
        error "$1 not found\n"
        echo "-----------------------------------------------------"
        return 1
    fi
}

check_dahdi_tool_config_files()
{
    local flag
    flag=0

    if [ ! -d "$DAHDI_LINUX_COMPLETE_SOURCE_DIR" ]; then
        error "$DAHDI_LINUX_COMPLETE_SOURCE_DIR not found\n"
        return 1
    fi

    cd "$DAHDI_LINUX_COMPLETE_SOURCE_DIR"

    for file in $*
    do
        check_file "$DAHDI_LINUX_COMPLETE_SOURCE_DIR/$file"
        if [ $? -ne 0 ]; then
            flag=1
        fi
    done

    if [ $flag -eq 1 ]; then
        exit 1
    fi

    echo 
    echo "--------------------------------------------------------"
    logger "Checking dahdi_tool configuration files..."
    show_status OK
    echo "--------------------------------------------------------"

    cd "$PROD_HOME"

    pause 1
}

check_asterisk_config_files()
{
    local flag
    flag=0

    if [ ! -d "$AST_SOURCE_DIR" ]; then
        error "$AST_SOURCE_DIR not found\n"
        return 1
    fi

    cd "$AST_SOURCE_DIR"

    for file in $*
    do
        check_file "$AST_SOURCE_DIR/$file"
        if [ $? -ne 0 ]; then
            flag=1
        fi
    done

    if [ $flag -eq 1 ]; then
        exit 1
    fi

    echo 
    echo "----------------------------------------------------"
    logger "Checking asterisk configuration files..."
    show_status OK
    echo "----------------------------------------------------"

    cd "$PROD_HOME"

    pause 1
}

backup_dahdi_tool_config_files()
{
    local flag
    flag=0

    cd "$DAHDI_LINUX_COMPLETE_SOURCE_DIR"

    for file in $*
    do
        backup_file "$file"
        if [ $? -ne 0 ]; then
            flag=1
        fi
    done

    if [ $flag -eq 1 ]; then
        exit 1
    fi

    echo 
    echo "------------------------------------------------------"
    logger "Backuping dahdi_tool configuration files..."
    show_status OK
    echo "------------------------------------------------------"

    cd "$PROD_HOME"

    pause 1
}

backup_asterisk_config_files()
{
    local flag
    flag=0

    cd "$AST_SOURCE_DIR"

    for file in $*
    do 
        backup_file "$file"
        if [ $? -ne 0 ]; then
            flag=1
        fi
    done

    if [ $flag -eq 1 ]; then
        exit 1
    fi

    echo
    echo "--------------------------------------------------------"
    logger "Backuping asterisk configuration files..."
    show_status OK
    echo "--------------------------------------------------------"

    cd "$PROD_HOME"

    pause 1
}


redhat_check_dependencies()
{
    missing_packages=" "
    logger "Checking for C development tools ..."
    eval "rpm -q gcc > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "gcc --version > /dev/null 2>&1"
        if [  $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"gcc "
        fi
    fi

    logger "Checking for C++ development tools..."
    eval "rpm -q gcc-c++ > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "g++ --version > /dev/null 2>&1"
        if [ $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"gcc-c++ "
        fi
    fi

    logger "Checking for Make Utility..."
    eval "rpm -q make > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "make --version > /dev/null 2>&1"
        if [ $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"make "
        fi
    fi

    logger "Checking for Ncurses Library..."
    eval "rpm -q ncurses > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "type clear > /dev/null 2>&1"
        if [ $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"ncurses "
        fi
    fi

    logger "Checking for ncurses-devel library..."
    eval "rpm -q ncurses-devel > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        if [ ! -f "/usr/include/ncurses.h"] && [ ! -f "/usr/include/ncurses/ncurses.h" ]; then
            show_status FAILED
            missing_packages=$missing_packages"ncurses-devel "
        else
            show_status OK
        fi
    fi

    logger "Checking for Perl development tools ..."
    eval "rpm -q perl > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "perl --version > /dev/null > 2>&1"
        if [ $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"perl "
        fi
    fi

    logger "Checking for Patch ..."
    eval "rpm -q patch > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "patch --version > /dev/null 2>&1"
        if [ $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"patch "
        fi
    fi

    logger "Checking for bison ..."
    eval "rpm -q bison > /dev/null"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "type bison > /dev/null 2>&1"
        if [ $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"bison "
        fi
    fi

    logger "Checking for bison-devel ..."
    eval "rpm -q bison-devel > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        if [ -f /usr/lib/liby.a ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"bison-devel "
        fi
    fi

    logger "Checking for openssl ..."
    eval "rpm -q openssl > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "type openssl > /dev/null 2>&1"
        if [ $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"openssl "
        fi
    fi

    logger "Checking for openssl-devel..."
    eval "rpm -q openssl-devel > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        if [ -f /usr/include/openssl/ssl.h ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"openssl-devel "
        fi
    fi

    logger "Checking for gnutls-devel..."
    eval "rpm -q gnutls-devel > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        if [ -f /usr/include/gnutls/gnutls.h ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"gnutls-devel "
        fi
    fi

    logger "Checking for zlib..."
    eval "rpm -q zlib > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        if [ -f /usr/lib/libz.so.1 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_package"zlib "
        fi
    fi

    logger "Checking for zlib-devel..."
    eval "rpm -q zlib-devel > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        if [ -f /usr/include/zlib.h ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_package"zlib-devel "
        fi
    fi

    logger "Checking for kernel development packages..."
    eval "rpm -q kernel-devel-$(uname -r) > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        show_status FAILED
        missing_packages=$missing_packages"kernel-devel-$(uname -r) "
    fi

    logger "Checking for libxml2-devel..."
    eval "rpm -q libxml2-devel > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        show_status FAILED
        missing_packages=$missing_packages"libxml2-devel "
    fi

    echo
    if [ "$missing_packages" != " " ]; then
        echo "WARNING: You are missing some prerequisites!!!"
        logger "Missing Packages $missing_packages\n"
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

                perl)
                    echo -e "\n Perl development tools."
                    echo -e "	Required for compiling packages."
                    echo -e "	Install Perl package (e.g yum install perl)."
                    ;;

                patch)
                    echo -e "\n Patch."
                    echo -e "	Required for compiling packages."
                    echo -e "	Install Patch package(e.g yum install patch)."
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
        getyn "Would you like to install the missing packages now?"
        if [ $? -eq 0 ]; then
            for package in $missing_packages
            do
                echo "yum install -y $package"

                yum install -y $package
                sleep 3
            done
        fi
    fi

    pause

    return 0
}



# ---------------------------------------------------------------------------------
# Looking for DAHDI Directory
# ---------------------------------------------------------------------------------
find_dahdi_dirs()
{
    local dahdi_linux_dirs
    local dahdi_linux_array
    local dahdi_linux_complete_dirs
    local dahdi_linux_complete_array
    local dahdi_tools_dirs
    local dahdi_tools_array

    dahdi_linux_complete_dirs=$1

    clearscr
    banner

    SETUP_INSTALL_QUICK="NO"

    # find dahdi-linux-complete in /usr/src
    echo 
    logger "Looking for dahdi-linux-complete directory in /usr/src...\n"
    echo 
    if [ "$dahdi_linux_complete_dirs" == "" ]; then
        dahdi_linux_complete_dirs=`find /usr/src/ -maxdepth 2 -type d -name 'dahdi-linux-complete*' | xargs`
        if [ -d "$DAHDI_LINUX_COMPLETE_DFLT_INSTALL_DIR" ]; then
            dahdi_linux_complete_dirs="$DAHDI_LINUX_COMPLETE_DFLT_INSTALL_DIR" "$dahdi_linux_complete_dirs"
        fi
    fi

    # find dahdi-linux and dahdi-tools in /usr/src if dahdi-linux-complete not found.
    #	if [ "$dahdi_linux_complete_dirs" == "" ]; then
    #		# find dahdi_linux in /usr/src
    #		echo 
    #		echo "Looking for dahdi-linux directory in /usr/src..."
    #		echo 
    #		if [ "$dahdi_linux_dirs" == "" ]; then
    #			dahdi_linux_dirs=`find /usr/src/ maxdepth 2 -type d -name 'dahdi-linux*' | xargs`
    #			if [ -d "$DAHDI_LINUX_DFLT_INSTALL_DIR" ]; then
    #				dahdi_linux_dirs="$DAHDI_LINUX_DFLT_INSTALL_DIR" "$dahdi_linux_dirs"
    #			fi
    #		fi

    #		# find DAHDI-tools in /usr/src
    #		echo 
    #		echo "Looking for dahdi-tools directory in /usr/src/..."
    #		echo 
    #		if [ "$dahdi_tools_dirs" == "" ]; then
    #			dahdi_tools_dirs=`find /usr/src/ -maxdepth 2 -type d -name 'dahdi-tools*' | xargs`
    #			if [ -d "$DAHDI_TOOLS_DFLT_INSTALL_DIR" ]; then
    #				dahdi_tools_dirs="$DAHDI_TOOLS_DFLT_INSTALL_DIR" "$dahdi_tools_dirs"
    #			fi
    #		fi
    #	fi

    # To move back and forth in dahdi-linux-complete dirs
    cnt=1
    for dir in $dahdi_linux_complete_dirs
    do
        # check the directory
        if [ ! -d "$dir" ]; then
            continue
        fi

        if [ ! -f "$dir/linux/include/dahdi/kernel.h" ]; then
            continue
        fi

        # if [ -h "$dir" ]; then
        # continue
        # fi

        logger "$cnt : $dir\n"
        dahdi_linux_complete_array[$cnt]=$dir
        cnt=$((cnt+1))
    done

    # if DAHDI-linux-complete was not found in /usr/src/
    if [ "$cnt" -eq 1 ]; then
        echo
        logger "There was not dahdi-linux-complete directory in /usr/src/\n"
        logger "Please download the dahdi-linux-complete or manually enter the new dahdi-linux-complete path\n"
        echo
    fi

    echo "---------------------------------------------------------------------------"
    echo "n : Download and install dahdi-linux-complete-2.5.0+2.5.0.tar.gz [Default installation]"
    echo "m : Manually enter your own dahdi-linux-complete diretory path"
    echo "d : Download the latest version of dahdi-linux-complete from Asterisk official website"
    echo "q : Skip this step"
    echo "(ctrl-c to exit)"
    echo -n "Please select the working dahdi-linux-complete directory [1-$((cnt-1)), n,m,d,q]:"

    read response
    logger "Please select the working dahdi-linux-complete directory [1-$((cnt-1)), n,m,d,q: $response\n]" 0

    if [ ! "$response" ]; then
        echo 
        error "Invalid Response $response\n"
        echo
        find_dahdi_dirs "$dahdi_linux_complete_dirs"
        return 0
    fi

    if [ "$response" == "n" ]; then
        cd /usr/src
        DAHDI_LINUX_COMPLETE_SOURCE_DIR="dahdi-linux-complete-2.5.0+2.5.0"
        wget -c "http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/releases/$DAHDI_LINUX_COMPLETE_SOURCE_DIR"".tar.gz"
        if [ $? -ne 0 ]; then
            error "Downloading $DAHDI_LINUX_COMPLETE_SOURCE_DIR was Failed!!!\n"
            DAHDI_LINUX_COMPLETE_SOURCE_DIR=""
        else
            logger "Downloading $DAHDI_LINUX_COMPLETE_SOURCE_DIR was successful!!!\n"
            tar -xvzf "$DAHDI_LINUX_COMPLETE_SOURCE_DIR"".tar.gz"
            DAHDI_LINUX_COMPLETE_SOURCE_DIR="/usr/src/$DAHDI_LINUX_COMPLETE_SOURCE_DIR"
        fi

        cd $PROD_HOME
    elif [ "$response"  == "m" ]; then
        echo 
        echo "-->If you have downloaded package DAHDI_LINUX_COMPLETE, please input its exact directory here:[e.g /usr/src/$DAHDI_LINUX_COMPLETE_DFLT_INSTALL_DIR]"
        echo "-->If you would like to install your own version, please input its version here:[e.g dahdi-linux-complete-2.5.0+2.5.0]"
        echo "-->If dahdi-linux-complete was not found that you input, the script will download it from http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/"
        echo -n "#> "

        read response
        if [ $response == "" ]; then
            DAHDI_LINUX_COMPLETE_SOURCE_DIR=$DAHDI_LINUX_COMPLETE_DFLT_INSTALL_DIR
        else
            DAHDI_LINUX_COMPLETE_SOURCE_DIR=$response
            logger"Please enter dahdi-linux-complete direcoty path: $DAHDI_LINUX_COMPLETE_SOURCE_DIR\n"
            if [ ! -d "$DAHDI_LINUX_COMPLETE_SOURCE_DIR" ]; then
                cd /usr/src
                DAHDI_LINUX_COMPLETE_SOURCE_DIR=`basename $DAHDI_LINUX_COMPLETE_SOURCE_DIR`
                DAHDI_LINUX_COMPLETE_SOURCE_DIR=${DAHDI_LINUX_COMPLETE_SOURCE_DIR%.tar.gz}
                if [ ! -f "$DAHDI_LINUX_COMPLETE_SOURCE_DIR.tar.gz" ]; then
                    logger "Downloading $DAHDI_LINUX_COMPLETE_SOURCE_DIR from http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/releases/$DAHDI_LINUX_COMPLETE_SOURCE_DIR.tar.gz\n"
                    wget -c "http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/releases/$DAHDI_LINUX_COMPLETE_SOURCE_DIR"".tar.gz"
                    if [ $? -ne 0 ]; then
                        error "Downloading $DAHDI_LINUX_COMPLETE_SOURCE_DIR was failed!!!\n"
                        DAHDI_LINUX_COMPLETE_SOURCE_DIR=""
                    else
                        logger "Downloading $DAHDI_LINUX_COMPLETE_SOURCE_DIR was successful!!!\n"
                        tar -xvzf "$DAHDI_LINUX_COMPLETE_SOURCE_DIR"".tar.gz"
                        DAHDI_LINUX_COMPLETE_SOURCE_DIR="/usr/src/$DAHDI_LINUX_COMPLETE_SOURCE_DIR"
                    fi
                else
                    tar -xvzf "$DAHDI_LINUX_COMPLETE_SOURCE_DIR"".tar.gz"
                    DAHDI_LINUX_COMPLETE_SOURCE_DIR="/usr/src/$DAHDI_LINUX_COMPLETE_SOURCE_DIR"
                fi

                cd $PROD_HOME
                #		find_dahdi_dirs
                return 0
            fi
        fi
    elif [ "$response" == "d" ]; then
        cd /usr/src
        wget -c http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
        if [ $? -ne 0 ]; then
            error "Downloading dahdi-linux-complete-current.tar.gz was failed!!!\n"
            DAHDI_LINUX_COMPLETE_SOURCE_DIR=""
        else
            logger "Downloading dahdi-linux-complete-current.tar.gz was successful!!!\n"
            tar -xvzf dahdi-linux-complete-current.tar.gz
            DAHDI_LINUX_COMPLETE_SOURCE_DIR=`tar -tf dahdi-linux-complete-current.tar.gz | xargs | cut -d '' -f1`
            DAHDI_LINUX_COMPLETE_SOURCE_DIR="/usr/src/""${DAHDI_LINUX_COMPLETE_SOURCE_DIR}"
        fi
        cd $PROD_HOME
    elif [ "$response" = "q" ]; then
        DAHDI_LINUX_COMPLETE_SOURCE_DIR=""
        DAHDI_AUTO_INSTALL="NO"
        logger "Skipped dahdi-linux-complete installation\n"
        return 0
    elif [ "$response" -gt 0 -a "$response" -lt $cnt ]; then
        DAHDI_LINUX_COMPLETE_SOURCE_DIR=${dahdi_linux_complete_array[$response]}
    else
        echo
        error "Invalid Response $response\n"
        echo
        find_dahdi_dirs "$dahdi_linux_complete_dirs"
        return 0
    fi

    DAHDI_KERNEL_H_PATH="${DAHDI_LINUX_COMPLETE_SOURCE_DIR}/linux/include/dahdi/kernel.h"
    if [ ! -f "$DAHDI_KERNEL_H_PATH" ]; then
        clearscr
        error "kernel.h was not found in $DAHDI_LINUX_COMPLETE_SOURCE_DIR\n"
        SETUP_INSTALL_QUICK="YES"
        find_dahdi_dirs"$dahdi_linux_complete_dirs"
        return 0
    fi
}

# ------------------------------------------------------------------------------------
# Looking for asterisk directory
# ------------------------------------------------------------------------------------

find_ast_dirs()
{
    local ast_dirs
    local astdir_array
    ast_dirs=$1

    clearscr
    banner

    SETUP_INSTALL_QUICK="NO"

    # find asterisk pacakge in /usr/src/
    echo 
    logger "Looking for Asterisk directory in /usr/src...\n"
    echo 
    if [ "$ast_dirs" == "" ]; then
        astdirs=`find /usr/src/ -maxdepth 2 -type d -name 'asterisk*' | xargs`
        if [ -d "$AST_DFLT_INSTALL_DIR" ]; then
            astdirs="$AST_DFLT_INSTALL_DIR "$astdirs
        fi
    fi
    #To move back and forth in Asterisk directory
    cnt=1
    for dir in $astdirs
    do 
        # check the directory
        if [ ! -d "$dir" ]; then
            continue
        fi

        if [ ! -f "$dir/include/asterisk.h" ]; then
            continue
        fi

        logger "$cnt : $dir\n"
        astdir_array[$cnt]=$dir
        cnt=$((cnt+1))
    done

    if [ "$cnt" -eq 1 ]; then
        echo
        logger "There was not Asterisk directory in /usr/src/\n"
        logger "Please download the asterisk or enter the new asterisk path!"
        echo
    fi

    echo "------------------------------------------------------------------------------------"
    echo "n : Download and install asterisk-1.8-current.tar.gz[Default installation]"
    echo "m : Manually enter Asterisk direcotry path"
    echo "q : Skip this step"
    echo "(ctl-c to Exit)"
    echo -n "Please select working Asterisk directory [1-$((cnt-1)), n, m, d, q]: "

    read response
    logger "Please select working Asterisk directory [1-$((cnt-1)), n, m, d, q]: $response\n" 0

    if [ ! "$response" ]; then
        echo
        error "Invalid Response $response\n"
        echo
        find_ast_dirs "$astdirs"
        return 0
    fi

    if [ "$response" == "n" ]; then
        cd /usr/src
        AST_SOURCE_DIR="asterisk-1.8-current"
        wget -c "http://downloads.asterisk.org/pub/telephony/asterisk/$AST_SOURCE_DIR"".tar.gz"
        if [ $? -ne 0 ]; then
            error "Downloading $AST_SOURCE_DIR was failed!!!\n"
        else
            logger "Downloading $AST_SOURCE_DIR was successful!!!\n"
            tar -xvzf "$AST_SOURCE_DIR"".tar.gz"
        fi

        find_ast_dirs
    elif [ "$response" == "m" ]; then
        echo
        echo "Please enter Asterisk directory path: [Default: $AST_DFLT_INSTALL_DIR]"

        echo "If Asterisk was not found, the script download it from http://downloads.asterisk.org/pub/telephony/asterisk"
        echo -n "#> "
        read response
        if [ "$response" == "" ]; then
            AST_SOURCE_DIR=$AST_DFLT_INSTALL_DIR
        else
            AST_SOURCE_DIR=$response
            if [ ! -d "$AST_SOURCE_DIR" ]; then
                cd /usr/src
                AST_SOURCE_DIR=`basename $AST_SOURCE_DIR`
                AST_SOURCE_DIR=${AST_SOURCE_DIR%.tar.gz}
                if [ ! -f "$AST_SOURCE_DIR.tar.gz" ]; then
                    logger "Downloading $AST_SOURCE_DIR from http://downloads.asterisk.org/pub/telephony/asterisk/releases/$AST_SOURCE_DIR.tar.gz\n"
                    wget -c "http://downloads.asterisk.org/pub/telephony/asterisk/releases/$AST_SOURCE_DIR"".tar.gz"
                    if [ $? -ne 0 ]; then
                        error "Downloading $AST_SOURCE_DIR was failed!!!\n"
                        AST_SOURCE_DIR=""
                    else
                        logger "Downloading $AST_SOURCE_DIR was successful!!!\n"
                        tar -xzvf "$AST_SOURCE_DIR"".tar.gz"
                        AST_SOURCE_DIR="/usr/src/$AST_SOURCE_DIR"
                    fi
                else
                    tar -xvzf "$AST_SOURCE_DIR"".tar.gz"
                    AST_SOURCE_DIR="/usr/src/$AST_SOURCE_DIR"
                fi

                cd $PROD_HOME
                return 0
            fi
        fi
    elif [ "$response" == "q" ]; then
        AST_SOURCE_DIR=""
        exit 0
    elif [ "$response" -gt 0 -a "$response" -lt $cnt ]; then
        AST_SOURCE_DIR=${astdir_array[$response]}
    else
        echo
        error "Invalid Response $response\n"
        echo 
        find_ast_dirs "$astdirs"
        return 0
    fi

    if [ ! -f "$AST_SOURCE_DIR/include/asterisk.h" ]; then
        clearscr
        error "asterisk.h was not found in $AST_SOURCE_DIR\n"
        SETUP_INSTALL_QUICK="YES"
        find_ast_dirs "$astdirs"
        return 0
    fi
}


install_dahdi()
{
    echo

    DAHDI_KERNEL_H_PATH="${DAHDI_LINUX_COMPLETE_SOURCE_DIR}/linux/include/dahdi/kernel.h"

    if [ ! -d $DAHDI_LINUX_COMPLETE_SOURCE_DIR ]; then
        error "$DAHDI_LINUX_COMPLETE_SOURCE_DIR is not a directory\n"
        exit 1
    fi

    if [ ! -f $DAHDI_KERNEL_H_PATH ]; then
        error "kernel.h was not found in $DAHDI_LINUX_COMPLETE_SOURCE_DIR\n"
        exit 1
    fi

    cd $DAHDI_LINUX_COMPLETE_SOURCE_DIR

    make 2>> "$INSTALL_LOG"
    if [ $? -ne 0 ]; then
        echo 
        error_compile "Installing $DAHDI_LINUX_COMPLETE_SOURCE_DIR: make ..."
    fi

    make install 2>> "$INSTALL_LOG"
    if [ $? -ne 0 ]; then
        echo 
        error_compile "Installing $DAHDI_LINUX_COMPLETE_SOURCE_DIR: make install ..."
    fi

    make config
    if [ $? -ne 0 ]; then
        echo
        error_compile "Installing $DAHDI_LINUX_COMPLETE_SOURCE_DIR: make config ..."
    fi


    echo
    echo "------------------------------------------------------------------------------------"
    logger "Installing $DAHDI_LINUX_COMPLETE_SOURCE_DIR ..."
    show_status OK
    echo "------------------------------------------------------------------------------------"

    cd $PROD_HOME

    pause 3
}

get_dahdi_version()
{
    DAHDI_VER_STR=`cat $DAHDI_LINUX_COMPLETE_SOURCE_DIR/.version`

    for (( i = 0; i < ${#DAHDI_VER_STR}; i++ ))
    do 
        tmp=${DAHDI_VER_STR:$i:1}

        if [ $tmp = "+" ]
        then
            break;
        elif [ $tmp = "-" ]
        then
            break;
        fi

        if [ "${tmp##[0-9]*} " = " " ]
        then
            DAHDI_VER_NUM+=$tmp
        fi
    done

    for (( i =${#DAHDI_VER_NUM}; i < 4; i++ ))
    do
        DAHDI_VER_NUM+="0"
    done
}




install_asterisk()
{
    echo

    cd $AST_SOURCE_DIR

    ./configure 2>> "$INSTALL_LOG"
    if [ $? -ne 0 ]; then
        echo
        error_compile "Installing Asterisk: ./configure ..."
    fi

    make 2>> "$INSTALL_LOG"
    if [ $? -ne 0 ]; then
        echo
        error_compile "Installing Asterisk: make ..."
    fi

    make install 2>> "$INSTALL_LOG"
    if [ $? -ne 0 ]; then
        echo
        error_compile "Installing Asterisk: make install ..."
    fi

    #################################################################################################
    # Apply to Operation System 64bits
    #################################################################################################

    if [ -d "/usr/lib64/asterisk/modules" ]; then
        if [ ` getconf LONG_BIT` = "64" ]; then
            \cp -rf /usr/lib/asterisk/modules/*.so /usr/lib64/asterisk/modules/
        fi
    fi
    #################################################################################################

    getyn "Would you like to install the asterisk configuration files?"
    if [ $? -eq 0 ]; then
        make samples 2>> "$INSTALL_LOG"
        if [ $? -ne 0 ]; then
            echo
            error_compile "Installing Asterisk: make samples ..."
        fi
    fi

    echo
    echo "------------------------------------------------------------------------------------------"
    logger "Installing Asterisk ..."
    show_status OK
    echo "------------------------------------------------------------------------------------------"

    cd $PROD_HOME

}

fun_source_install()
{
    find_dahdi_dirs

    #install dahdi
    if [ "$DAHDI_AUTO_INSTALL" == "YES" ]; then
        install_dahdi
    fi

    find_ast_dirs

    # Install Asterisk
    if [ "$AST_AUTO_INSTALL" == "YES" ]; then
        install_asterisk
    fi	
}


get_server_environment()
{	
    echo "get_server_environment"
}


OS="redhat"
check_os()
{
    cat /proc/version |grep 'Red Hat' > /dev/null
    if [ $? -eq 0 ]; then
        OS="redhat"
        return 
    fi
}

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin
KERNEL_VERSION=`uname -r`
KERNEL_ARCH=`uname -m`

FULL_PATH="$0"
PROD_HOME=$(cd ${FULL_PATH%/*}; pwd)

PROD_VERSION='1.0.0'

INSTALL_WAY="source"


DRIVER_SRC_DIR=$PROD_HOME/src/
LOG_DIR=$PROD_HOME/log

#log file
INSTALL_LOG="$LOG_DIR/install.log.$(date +%F-%H-%M)"

ROOT_UID=0
SUPERUSER=NO
LOG_ENABLE=YES

#asterisk and dahdi source code path
AST_DFLT_INSTALL_DIR="/usr/src/asterisk/"
DAHDI_LINUX_DFLT_INSTALL_DIR="/usr/src/dahdi-linux/"
DAHDI_TOOLS_DFLT_INSTALL_DIR="/usr/src/dahdi-tools/"
DAHDI_LINUX_COMPLETE_DFLT_INSTALL_DIR="/usr/src/dahdi-linux-complete"
DAHDI_LINUX_SOURCE_DIR=$DAHDI_LINUX_DFLT_INSTALL_DIR
DAHDI_TOOLS_SOURCE_DIR=$DAHDI_TOOLS_DFLT_INSTALL_DIR
DAHDI_LINUX_COMPLETE_SOURCE_DIR=$DAHDI_LINUX_DFLT_COMPLETE_INSTALL_DIR
AST_SOURCE_DIR=$AST_DFLT_INSTALL_DIR

DAHDI_AUTO_INSTALL="YES"
AST_AUTO_INSTALL="YES"

#ENVIRONMENT INFO
ENVIRON_LSB_COMPLIANT="YES"
ENVIRON_SYSTEM_RELEASE=""
ENVIRON_SYSTEM_VERSION=""
ENVIRON_SYSTEM_ARCH=""
ENVIRON_SYSTEM_LOCALE=""
ENVIRON_SYSTEM_=""
SYSTEM_VERSION=""

SETUP_INSTALL_QUICK="NO"

#Create log dir
mkdir -p $LOG_DIR

#clear log file
cat /dev/null > "$INSTALL_LOG"

#check superuser
if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "Must be root to run this script!!!"
    exit 1
else
    superuser=YES
fi


# Check OS
check_os

# show banner
banner

# Check Bash Version
check_bash

# Check dependences
if [ $OS = "redhat" ]; then
    redhat_check_dependencies
fi

# Show banner
banner




select_list "Source code install"
case $SEL in
    1)
        INSTALL_WAY="source"
        fun_source_install
        ;;

    q) 
        exit 1
esac
