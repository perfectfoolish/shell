#!/bin/bash
# Program:
#  jenkins to build rpm 
# History:
# 2012/08/24    lilulei   First release
#-------------------------------------------------------------------------------
# cron field definitions
#
# *     *     *     *     *  command to be executed
# -     -     -     -     -
# |     |     |     |     |
# |     |     |     |     +----- day of week (0 - 6) (Sunday=0)
# |     |     |     +------- month (1 - 12)
# |     |     +--------- day of month (1 - 31)
# |     +----------- hour (0 - 23)
# +------------- min (0 - 59)
#
#-------------------------------------------------------------------------------
#
#00 00 * * 1,3


#!/bin/bash

VERSION=1.1.3.`date +%Y%m%d`

rm -rf MCSS_Server CMT*
git clone git://192.168.0.23/MCSS_Server
chmod -R +x MCSS_Server
mv ./MCSS_Server/ceictserver CMT-$VERSION
tar zcf CMT-$VERSION.tar.gz CMT-$VERSION
mv CMT-$VERSION.tar.gz SOURCES/
sed -i "s/^Version:.*/Version: $VERSION/" SPECS/CMT.spec
rpmbuild --define '_topdir '`pwd` -ba SPECS/CMT.spec

/var/lib/jenkins/tools/Maven/maven/bin/mvn deploy:deploy-file -X -Durl=http://192.168.0.20:8081/nexus/content/repositories/releases/ -DrepositoryId=ceict -DgroupId=com.ceict -DartifactId=CMT -Dpackaging=rpm -Dfile=/var/lib/jenkins/jobs/CMT_build/workspace/RPMS/i386/CMT-$VERSION-1.i386.rpm -Dversion=$VERSION

/var/lib/jenkins/tools/Maven/maven/bin/mvn deploy:deploy-file -X -Durl=http://192.168.0.20:8081/nexus/content/repositories/releases/ -DrepositoryId=ceict -DgroupId=com.ceict -DartifactId=CMT -Dpackaging=tar.gz -Dfile=/var/lib/jenkins/jobs/CMT_build/workspace/RPMS/i386/CMT-$VERSION-1.i386.tar.gz
-Dversion=$VERSION
