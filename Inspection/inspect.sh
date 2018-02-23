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
php ${TOOLS_PATH}/phpunit.phar -v --configuration ${ROOT_PATH}/tests/phpunit_default.xml --log-junit ${INSPECTION_PATH}/Test/Php/junit_php.xml --testdox-html ${INSPECTION_PATH}/Test/Php/index.html --coverage-html ${INSPECTION_PATH}/Test/Php/coverage --coverage-clover ${INSPECTION_PATH}/Test/Php/coverage.xml > ${INSPECTION_PATH}/Test/Php/phpunit.log

# Stats & metrics
. Inspection/Php/stats.sh

# Linting
. Inspection/Php/linting.sh
. Inspection/Json/linting.sh

# Code style
. Inspection/Php/style.sh

# Custom html inspections
. Inspection/Html/tags.sh
. Inspection/Html/attributes.sh

# Custom php inspections
. Inspection/Php/security.sh

# Documentation
php ${TOOLS_PATH}/documentor.phar -s ${ROOT_PATH}/phpOMS -d ${BASE_PATH}/Inspection/Test/Php/docblock -c ${INSPECTION_PATH}/Test/Php/coverage.xml -u ${INSPECTION_PATH}/Test/Php/junit_php.xml -b http://docs.orange-management.de
