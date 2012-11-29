#!/usr/bin/env bash
>output.txt
for dir in /bin/usr /usr/bin/
do
    ls $dir &>>output.txt
done
