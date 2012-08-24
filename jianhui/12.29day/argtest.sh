#!/bin/bash


echo ".............\$*............."
for var in $*
do 
  echo $var
done
  echo "............\$@............."
for var2 in $@
do 
  echo "$@"
done
