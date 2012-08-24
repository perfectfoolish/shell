#!/bin/bash

echo "----------通讯薄---------"
echo "1)添加新记录 2）查看个人记录 3）删除个人记录 4）退出"
echo "请选择你将进行的操作(1/2/3/4): "
echo "-------------------------"

function add()
{
   ls ~/txl
   echo -n "请添加用户: "
   read name
   if [ -f ~/txl/$name ]
    then 
    echo "已经存在 "
   else
    mkdir -p ~/txl
    touch ~/txl/$name
  #  ls ~/txl/$name 
   
   echo -n "telephone: "
   read phone
   echo phone: $phone >> ~/txl/$name
 # 上下两行均可  echo phone: $phone >> ~/txl/$name
   echo -n "addres: "
   read adrs
   echo adrs: $adrs >> ~/txl/$name
   fi
}
function chakan()
{
   ls ~/txl
   echo "查看用户信息 "
   echo -n "name: "
   read name
   more ~/txl/$name
}
function delet()
{
   ls ~/txl
   echo -n "请输入用户: "
   read name
   if [ -f ~/txl/$name ]
    then
     echo "是否删除（Y/N）"
    read a
    if [ $a=Y ]
    then
    rm ~/txl/$name
    else
    :
    fi
   fi
}
echo "-------yong hu------- "
ls -p ~/txl

select c in "添加新记录" "查看个人记录" "删除个人记录" "退出"
do
 case $c in
 "添加新记录")
    add
     ;;
  "查看个人记录")
    chakan
     ;;
  "删除个人记录")
    delet
        ;;
  "退出")
    exit 
    ;;
   *)
    echo "Error!" 
 esac
done
