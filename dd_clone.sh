/*
 * Copyright (C) 2012 Ceict Limited. All rights reserved.
 *
 * This file is property of Ceict with all rights reserved under the copyright laws.
 *
 */


#! /bin/bash

if [ $# -eq 0 ]
	then
		echo "Usage: ./dd_clone.sh device1 device2" 1>&2
		exit 1
fi

echo "cloning "

sudo dd if=/dev/$1 of=/dev/$2 conv=noerror,sync bs=1024k &

while sudo killall -USR1 dd; do sleep 5; done

echo " finish"   