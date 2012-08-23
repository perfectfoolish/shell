#! /bin/bash

DIR=/sdcard/logs
max_dirno=0

for dirname in `ls $DIR`; do
	dirno=${dirname#log}
	if [ $dirno -gt $max_dirno ]; then
		max_dirno=$dirno
	fi
done

mkdir $DIR/log$((max_dirno + 1))
