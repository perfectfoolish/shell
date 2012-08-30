#! /bin/sh

if [[ "$1" == "" ]]; then
	echo "Please enter the directory!"
	exit 1
fi

if [[ "$2" == "" ]]; then
	echo "Please enter the src string!"
	exit 1
fi

if [[ "$3" == "" ]]; then
	echo "Please enter the dst string!"
	exit 1
fi

change_filename()
{
#	pwd
	cd $1
	for old in `find ./ -name "*$2*"`; do
		if [[ -f $old ]]; then
			new="${old//$2/$3}"
			mv $old $new
		elif [[ -d $old ]]; then
			new="${old//$2/$3}"
			mv $old $new
			change_filename $new $2 $3
		fi
	done
		
	cd ..

	return 0
}

change_filecontent()
{
#	pwd
	cd $1
	for filename in `find ./ -type f -exec grep -il "$2" {} \;`; do
		sed -i "s/$2/$3/g" $filename
	done

	return 0
}

change_filename $1 $2 $3
change_filecontent $1 $2 $3

