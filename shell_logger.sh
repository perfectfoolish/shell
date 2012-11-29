#!/bin/sh

## created by gembler.
#http://gembler.iteye.com/blog/319525
##--------------------##
## initialize logger. ##
##--------------------##

usage()
{
    echo "Usage: $0 {--log-level|--log-file}"
    exit 1
}

[ $# -gt 0 ] || usage

RESOLVED=
resolve_arg(){
    RESOLVED=`expr "X$1" : '[^=]*=\(.*\)'`
}

#[ off => 0 ],[ error => 1 ],[ info => 2 ],[ debug => 3 ]
LOG_LEVEL_OFF=0
LOG_LEVEL_ERROR=1
LOG_LEVEL_INFO=2
LOG_LEVEL_DEBUG=3
LOG_LEVEL=$LOG_LEVEL_INFO
LOG_FILE=
print_log_msg(){
    if [ "x$LOG_FILE" == "x" ]; then
        echo "[`date +'%Y-%m-%d %R:%S'`]$*"
    else
        echo "[`date +'%Y-%m-%d %R:%S'`]$*" >> $LOG_FILE
    fi
}
debug() {
    if [ $LOG_LEVEL -ge 3 ]; then
        print_log_msg "<DEBUG> $*"
    fi
}
info() {
    if [ $LOG_LEVEL -ge 2 ]; then
        print_log_msg "<IN FO> $*"
    fi
}
error() {
    if [ $LOG_LEVEL -ge 1 ]; then
        print_log_msg "<ERROR> $*"
    fi
}

for ac_option in $* ; do
    resolve_arg $ac_option
    case $ac_option in
        --log-level=*)
        case $RESOLVED in
            debug)
            LOG_LEVEL=$LOG_LEVEL_DEBUG
            ;;
            info)
            LOG_LEVEL=$LOG_LEVEL_INFO
            ;;
            error)
            LOG_LEVEL=$LOG_LEVEL_ERROR
            ;;
            off)
            LOG_LEVEL=$LOG_LEVEL_OFF
            ;;
            *)
            LOG_LEVEL=$LOG_LEVEL_INFO
            ;;
        esac
        ;;
        --log-file=*)
        resolve_arg $ac_option
        LOG_FILE=$RESOLVED
        ;;
        *)
        usage
        ;;
    esac
done
