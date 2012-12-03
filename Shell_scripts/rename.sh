#!/bin/sh

function ergodic(){
	for file in ` ls $1 `
		do
			if [ -d $1"/"$file ]
				then
				ergodic $1"/"$file
			else
				local path=$1"/"$file   
				local name=$file     

				rename asterisk ceict_server $path   
				sed -i 's/asterisk/ceict_server/g' $path
				sed -i 's/Asterisk/Ceict_server/g' $path
				#sed -i 's/asterisk/ceict_server/g' $path
			fi
	done
}

INIT_PATH="/root/ceict_server_install"
rename $INIT_PATH/include/asterisk $INIT_PATH/include/ceictserver
ergodic $INIT_PATH  
