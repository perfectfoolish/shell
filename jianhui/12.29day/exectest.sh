#!/bin/bash

exec 6>&1
exec 1>$1
pwd
echo "hello world"
exec 1>&6
