#! /bin/bash
# Program:
#     Shell scripts debuging methods. 
# History:
# 2012/11/27    First release
# Methods:
# First:
#   $ sh -x ./script.sh
# Second:
#   #! /bin/bash -x
# Third:
# #! /bin/bash
# if [ -z "$1" ]; then
#     set -x
#     echo "ERROR: Insufficient Args."
#     exit 1
#     set +x
# fi

echo -e "\033[30;32m green color \033[0m"
if [ -z "$1" ]; then
    set -x
    echo "ERROR: Insufficient Args."
    exit 1
    set +x
fi
