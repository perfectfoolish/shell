#!/bin/bash

redhat_check_dependencies()
{
    missing_packages=" "
    eval "rpm -q wget > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "wget --version > /dev/null 2>&1"
        if [  $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"wget"
        fi
    fi

    eval "rpm -q tar > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "tar --version > /dev/null 2>&1"
        if [  $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"tar"
        fi
    fi

    eval "rpm -q jre > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        show_status OK
    else
        eval "java -version > /dev/null 2>&1"
        if [  $? -eq 0 ]; then
            show_status OK
        else
            show_status FAILED
            missing_packages=$missing_packages"jre"
        fi
    fi

    echo
    if [ "$missing_packages" != " " ]; then
        echo "WARNING: You are missing some prerequisites!!!"
        logger "Missing Packages $missing_packages\n"
        for package in $missing_packages
        do
            case $package in
                gcc)
                    echo -e "\n C Compiler (gcc)."
                    echo -e "	Required for compiling packages."
                    echo -e "	Install gcc package(e.g yum install gcc)."
                    ;;

            esac
        done

        echo 

        if [ $? -eq 0 ]; then
            for package in $missing_packages
            do
                echo "yum install -y $package"

                yum install -y $package
                sleep 3
            done
        fi
    fi


    return 0
}

