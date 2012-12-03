#!/bin/bash
# Program:
#   Checking if a script is already running
#   It's often important to exit a script if another instance is already running.
#   File locking can be used for this, but it gets untidy. Here's a simple, yet
#   effective way of checking.
# History:
# 2012/08/24    lifulei     First release

progName=`basename $0`
progPid=$$

# Exit if we are already running
if [[ $( ps -ef | grep $progName | grep -v $progPid | wc -l ) -gt 1 ]]; then
    echo Program is already running. Exiting
    exit 0
fi

# The rest of the script goes here...
