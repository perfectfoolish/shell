#!/bin/bash
# Program:
#	Program shows the effect of shift function.
# History:
# 2009/02/17	VBird	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo "Total parameter number is ==> $#"
echo "Your whole parameter is   ==> '$@'"
shift   # �i��Ĥ@���y�@���ܼƪ� shift �z
echo "Total parameter number is ==> $#"
echo "Your whole parameter is   ==> '$@'"
shift 3 # �i��ĤG���y�T���ܼƪ� shift �z
echo "Total parameter number is ==> $#"
echo "Your whole parameter is   ==> '$@'"
