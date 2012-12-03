#!/bin/bash

rm -rf MCSS_Server CMT* RPMS/i386/*.rpm SOURCES/*.tar.gz
git clone git://192.168.0.23/MCSS_Server

VER=`egrep '[0-9]{1}\.[0-9]{1}\.[0-9]{1}\.[0-9]{1}' MCSS_Server/ceictserver/.version | cut -c 1-6`
TODAY=`date +%Y%m%d`
VERSION=$VER$TODAY
RELEASE=1

chmod -R +x MCSS_Server

if [ ! -f release ]; then
    echo "DATE=$TODAY" > release

    echo "don't have release! touch release today first build 1"
    mv ./MCSS_Server/ceictserver CMT-$VERSION-$RELEASE
    tar zcf CMT-$VERSION-$RELEASE.tar.gz CMT-$VERSION-$RELEASE
    mv CMT-$VERSION-$RELEASE.tar.gz SOURCES/
    sed -i "s/^Version:.*/Version: $VERSION/" SPECS/CMT.spec
    sed -i "s/^Release:.*/Release: $RELEASE/" SPECS/CMT.spec
    rpmbuild --define '_topdir '`pwd` -bb SPECS/CMT.spec
    RELEASE=$(($RELEASE+1))
    echo "Release=$RELEASE" >> release

else

    TIME=`sed -n "/DATE=/s/DATE=//p" release`
    NO=`sed -n "/Release=/s/Release=//p" release`
    if [ "$TIME" -eq "$TODAY" ]; then

        echo "today next build time $TIME $NO"
        mv ./MCSS_Server/ceictserver CMT-$VERSION-$NO
        tar zcf CMT-$VERSION-$NO.tar.gz CMT-$VERSION-$NO
        mv CMT-$VERSION-$NO.tar.gz SOURCES/
        sed -i "s/^Version:.*/Version: $VERSION/" SPECS/CMT.spec
        sed -i "s/^Release:.*/Release: $NO/" SPECS/CMT.spec
        rpmbuild --define '_topdir '`pwd` -bb SPECS/CMT.spec
        RELEASE=$(($NO+1))
        sed -i "s/^Release=.*/Release=$RELEASE/" release
    else

        echo "already have release! today first 1 time $TIME $NO"
        mv ./MCSS_Server/ceictserver CMT-$VERSION-$RELEASE
        tar zcf CMT-$VERSION-$RELEASE.tar.gz CMT-$VERSION-$RELEASE
        mv CMT-$VERSION-$RELEASE.tar.gz SOURCES/
        sed -i "s/^Version:.*/Version: $VERSION/" SPECS/CMT.spec
        sed -i "s/^Release:.*/Release: $RELEASE/" SPECS/CMT.spec
        rpmbuild --define '_topdir '`pwd` -bb SPECS/CMT.spec
        sed -i "s/^DATE=.*/DATE=$TODAY/" release
        RELEASE=$(($RELEASE+1))
        sed -i "s/^Release=.*/Release=$RELEASE/" release
    fi
fi
rm -rf MCSS_Server CMT*
