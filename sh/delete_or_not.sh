#!/usr/bin/env bash

if [ $# != 1 ]
then
    echo """
Error: missing operand
Usage: ./delete_or_not.sh PATHNAME
        """>&2
    exit 1
fi

cd $1
for file in `ls`
do
    echo -n "Want to delete:$file ? (Y/n): "
    read AAA
    if [ "${AAA:-y}" = "y" ];then
        echo delete $file
        rm $file
        echo ...done
    else
        echo pass
    fi
done
