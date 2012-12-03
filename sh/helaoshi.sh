#!/bin/bash

# Log file
LOG_ENABLE=YES
LOG_DIR="/root/src/log"
INSTALL_LOG="${LOG_DIR}/install.log.$(date +%F-%H-%M)"

# Create log dir
mkdir -p $LOG_DIR

# Clear log file
cat /dev/null > "$INSTALL_LOG"

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

redhat_check_dependencies()
{
    missing_packages=" "
    eval "rpm -q wget > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "wget --version > /dev/null 2>&1"
        if [  $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"wget"
        fi
    fi

    eval "rpm -q tar > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "tar --version > /dev/null 2>&1"
        if [  $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"tar"
        fi
    fi

    eval "rpm -q jre > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "java -version > /dev/null 2>&1"
        if [  $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"jre"
        fi
    fi

    missing_packages=$missing_packages"your_tar.gz"
    echo
    if [ "$missing_packages" != " " ]; then
        echo "WARNING: You are missing some prerequisites!!!"
        logger "Missing Packages $missing_packages\n"
        for package in $missing_packages
        do
            case $package in
                wget)
                echo -e "\n wget"
                ;;
                tar)
                echo -e "\n tar"
                ;;
                jre)
                echo -e "\n jre"
                ;;
                your_tar.gz)
                echo -e "\n your_tar.gz"
                ;; 
            esac
        done

    fi


    return 0
}

