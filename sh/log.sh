#!/bin/bash
#Program:
#  Use to log shell scripts rum status
#History:
# 2012/11/21 modified by az00000000@126.com  First release

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
        show_status OK_good  1 1
    else
        show_status FAILED_bad 1 1
    fi
}

logger "ls aa\n" 1 1
ls aa
check_succeed_fail
