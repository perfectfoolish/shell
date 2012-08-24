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

rm -rf MCSS_Server CMT*
git clone git://192.168.0.23/MCSS_Server
chmod -R +x MCSS_Server
mv ./MCSS_Server/ceictserver CMT-1.1.3.`date +%Y%m%d`
tar zcf CMT-1.1.3.`date +%Y%m%d`.tar.gz CMT-1.1.3.`date +%Y%m%d`
mv CMT-1.1.3.`date +%Y%m%d`.tar.gz SOURCES/
sed -i "s/^Version:.*/Version: 1.1.3.`date +%Y%m%d`/" SPECS/CMT.spec
rpmbuild --define '_topdir '`pwd` -ba SPECS/CMT.spec
