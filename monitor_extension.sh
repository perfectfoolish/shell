#!/bin/bash

# Program:
#   Monitoring the status of extension
# History:
# 2012/08/23 lifulei First release

if [[ "$1" == "" ]]; then
    echo -e " Useage: Monitoring the status of extension \n\t example ./monitor_extension.sh 1001"
    exit 1
fi

while [[ true ]]; do

    ceictims -rx "sip show peers like $1" | grep $1
    sleep 1
done
