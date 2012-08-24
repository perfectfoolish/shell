#!/bin/bash

PS3="^_^"
select mobile in ipone4s NOKIA kk 
do
 case $mobile in 
 ipone4s)
      echo "you chppice is iphone4s"
      ;;
 NOKIA)

      echo "you chooice is NOKIA"
      ;;
 kk)
      echo "you chooece is kk"
      ;;
  *)
      echo "you no choose ok"
 esac
done
