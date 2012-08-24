#!/bin/bash

function adddir()
{
   echo "input name:"
   read dirname
   if [ -d $dirname ]
    then
     echo "存在"
   else
     mkdir $dirname
     echo "添加成功"
  fi
}
function deletedir()
{
   echo "input name:"
   read dirname
   if [ -d $diname ]
    then
    rm -r $dirname
    echo "删除成功"
   else
    echo "文件不存在"
   fi
}
function changedir()
{
   echo "input dirname:"
   if [ -d $dirname ]
    then
    echo "存在"
   else
   mv $dirname var
    echo "改变成功"
   fi
}
function viewdir()
{
   echo "input dirname:"
   read $dirname
   if [ -d $dirname ]
    then
    echo "存在"
   else
    ls $dir
   fi
}
function myexit()
{
   $exit
}
   select c in "adddir" "deletedir" "changedir" "viewdir" "myexit"
   do
     case $c in
   "adddir")
    adddir
      ;;
   "deletedir")
     deletedir
      ;;
   "changedir")
     changedir
      ;;
   "viewdir")
     viewdir
      ;;
   "myexit")
     exit 0
      ;;
    *)   
   echo "invalid dir,try again"
      ;;
     esac
   done 

