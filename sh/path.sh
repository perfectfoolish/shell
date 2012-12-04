#!/bin/bash

path=$PATH:/bin:/sbin:/usr/bin:/usr/sbin
echo $PATH
echo $path
FULL_PATH="$0"
echo $FULL_PATH
echo ${FULL_PATH%/*}
PROD_HOME=$(cd ${FULL_PATH%/*}; pwd)
echo $PROD_HOME
