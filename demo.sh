#!/bin/bash

. var.sh
. ${ROOT_PATH}/private.sh

# Setting up database for demo and testing
mysql -e 'drop database if exists oms;' -u root -p${DB_PASSWORD}
mysql -e 'create database oms;' -u root -p${DB_PASSWORD}
#echo "USE mysql;\nUPDATE user SET password=PASSWORD('123456') WHERE user='root';\nFLUSH PRIVILEGES;\n" | mysql -u root

curl --connect-timeout 600 --max-time 601 ${WEB_URL}/Admin/Install
