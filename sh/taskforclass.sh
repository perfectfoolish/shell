#!/bin/bash
#
#
#
#
#

#-----------------------------------------------
# For debugging
#-----------------------------------------------
debugging()
{
    if [ -z "$1" ]; then
        set -x
        echo "ERROR: Insufficient Args"
        exit 1
        set +x
    fi
}

#-----------------------------------------------
# Initialize logger
#-----------------------------------------------


#-----------------------------------------------
# Clear the screen 
#-----------------------------------------------


#-----------------------------------------------
# Color the STDOUT 
#-----------------------------------------------
color()
{
    echo -e "\033[30;33m $1 \033[0m" #yellow
}

#-----------------------------------------------
# Display Banner
#-----------------------------------------------
banner()  
{  
    clear

    color "##########################################################"  
    color "#              Script for replacing                      #"  
    color "#                   V$PROD_VERSION                               #"  
    color "#                                                        #"  
    color "#                Shell Enthusiast                        #"  
    color "#      No any warrant of this script,please note!        #"  
    color "##########################################################"  

    echo ""  

    return 0  
}  

#-----------------------------------------------
# Check Bash
#-----------------------------------------------
check_bash()
{
    BASH_SUPPORT=`echo $BASH_VERSION | cut -d'.' -f1 2> /dev/null`
    test -z $BASH_SUPPORT && color "Bash doesn't exist!" && exit 1 
}

#-----------------------------------------------
# Usage
#-----------------------------------------------
change_filename()
{
    cd $1
    for old in `find ./ -iname "*$2*"`; do
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

#-----------------------------------------------
# Usage
#-----------------------------------------------
change_filecontent()
{
    cd $1
    for filename in `find ./ -type f -exec grep -il "$2" {} \;`; do
        sed -i "s/$2/$3/g" $filename
    done

    return 0
}

#************************************************
#  The beginning of script
#************************************************
PROD_VERSION='1.0.0'
check_bash
banner

if [[ "$1" == "" ]]; then
    color "Usage: ./replace.sh PATHNAME srcstring dststring"
    exit 1
fi

if [[ "$2" == "" ]]; then
    color "Usage: ./replace.sh PATHNAME srcstring dststring"
    exit 1
fi

if [[ "$3" == "" ]]; then
    color "Usage: ./replace.sh PATHNAME srcstring dststring"
    exit 1
fi

change_filename $1 $2 $3
change_filecontent $1 $2 $3
