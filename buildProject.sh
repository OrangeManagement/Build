#!/bin/bash

# Include config
. config.sh

# Clean setup
. setup.sh

cd ${ROOT_PATH}

# Setting up database for demo and testing
mysql -e 'drop database if exists oms;' -u ${DB_USER} -p${DB_PASSWORD}
mysql -e 'create database oms;' -u ${DB_USER} -p${DB_PASSWORD}
#echo "USE mysql;\nUPDATE user SET password=PASSWORD('123456') WHERE user='root';\nFLUSH PRIVILEGES;\n" | mysql -u root

# Run inspection
. Inspection/inspect.sh

# Build documentation
php ${TOOLS_PATH}/documentor.phar -s ${ROOT_PATH}/phpOMS -d ${BASE_PATH}/Inspection/Test/Php/docblock -c ${INSPECTION_PATH}/Test/Php/coverage.xml -u ${INSPECTION_PATH}/Test/Php/junit_php.xml -b http://docs.orange-management.de
