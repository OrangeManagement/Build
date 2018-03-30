#!/bin/bash

# Include config
. config.sh

# Setting up database for demo and testing
mysql -e 'drop database if exists oms;' -u ${DB_USER} -p${DB_PASSWORD}
mysql -e 'create database oms;' -u ${DB_USER} -p${DB_PASSWORD}
#echo "USE mysql;\nUPDATE user SET password=PASSWORD('123456') WHERE user='root';\nFLUSH PRIVILEGES;\n" | mysql -u root

# Build js
#. Js/build.sh

# Executing unit tests
. ${BUILD_PATH}/Inspection/Php/tests.sh

# Stats & metrics
. ${BUILD_PATH}/Inspection/Php/stats.sh

# Linting
. ${BUILD_PATH}/Inspection/Php/linting.sh
. ${BUILD_PATH}/Inspection/Json/linting.sh

# Code style
. ${BUILD_PATH}/Inspection/Php/style.sh

# Custom html inspections
. ${BUILD_PATH}/Inspection/Html/tags.sh
. ${BUILD_PATH}/Inspection/Html/attributes.sh

# Custom php inspections
. ${BUILD_PATH}/Inspection/Php/security.sh
