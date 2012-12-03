#!/bin/sh

VERSION=`ceictims -rx 'core show version'`
echo $VERSION | cut -c 1-16 

