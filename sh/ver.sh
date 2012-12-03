#!/bin/bash

rm -rf MCSS_Server CMT*
git clone git://192.168.0.23/MCSS_Server

VER=`egrep '[0-9]{1}\.[0-9]{1}\.[0-9]{1}\.[0-9]{1}' MCSS_Server/ceictserver/.version | cut -c 1-6`
TIME=`date +%Y%m%d`
VERSION=$VER$TIME
RELEASE=1

chmod -R +x MCSS_Server
if [[ -f /SOURCES/CMT-$VERSION-$RELEASE.tar.gz ]]; then
    RELEASE=$(($RELEASE+1))
    mv ./MCSS_Server/ceictserver CMT-$VERSION-$RELEASE
    tar zcf CMT-$VERSION-$RELEASE.tar.gz CMT-$VERSION-$RELEASE
    mv CMT-$VERSION-$RELEASE.tar.gz SOURCES/
    sed -i "s/^Version:.*/Version: $VERSION/" SPECS/CMT.spec
    sed -i "s/^Release:.*/Release: $RELEASE/" SPECS/CMT.spec
else
    mv ./MCSS_Server/ceictserver CMT-$VERSION-$RELEASE
    tar zcf CMT-$VERSION-$RELEASE.tar.gz CMT-$VERSION-$RELEASE
    mv CMT-$VERSION-$RELEASE.tar.gz SOURCES/
    sed -i "s/^Version:.*/Version: $VERSION/" SPECS/CMT.spec
    sed -i "s/^Release:.*/Release: $RELEASE/" SPECS/CMT.spec
fi
