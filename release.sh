#!/bin/bash

RELEASE=1
TODAY=`date +%Y%m%d`

if [ ! -f release ]; then
    echo "DATE=$TODAY" > release

    echo "don't have release! touch release first 1"

    RELEASE=$(($RELEASE+1))
    echo "Release=$RELEASE" >> release

else

    TIME=`sed -n "/DATE=/s/DATE=//p" release`
    NO=`sed -n "/Release=/s/Release=//p" release`
    if [ "$TIME" -eq "$TODAY" ]; then

        echo "today second 2 time $TIME $NO"

        RELEASE=$(($NO+1))
        sed -i "s/^Release=.*/Release=$RELEASE/" release
    else

        echo "already have release! today first 1 time $TIME $NO"

        sed -i "s/^DATE=.*/DATE=$TODAY/" release
        RELEASE=$(($RELEASE+1))
        sed -i "s/^Release=.*/Release=$RELEASE/" release
    fi
fi
