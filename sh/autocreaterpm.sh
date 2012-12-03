#! /bin/bash

git clone git://192.168.0.23/MCSS_Server

cd MCSS_Server

chmod -R +x ceictserver

mv ceictserver ceictserver-

tar ceictserver- .tar.gz ceictserver

mv ceictserver .tar.gz /usr/src/redhat/SOURCES

cd

rpm -ba CMT.spec

