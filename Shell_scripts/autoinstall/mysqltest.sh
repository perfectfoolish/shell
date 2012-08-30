#!/bin/bash

chkconfig --level 35 mysqld on

service mysqld start

mysqladmin -uroot -password 2011ceict

mysql -u root -p2011ceict < /root/src/allowlocalhost.sql

mysql -u root -p2011ceict < /root/src/ims.sql