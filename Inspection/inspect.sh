#!/bin/bash

# Include config
. config.sh

# Setting up database for demo and testing
mysql -e 'drop database if exists oms;' -u ${DB_USER} --password="${DB_PASSWORD}"
mysql -e 'create database oms;' -u ${DB_USER} --password="${DB_PASSWORD}"

# Build js
#. Js/build.sh

# Executing unit tests
echo "#################################################"
echo "PHP tests"
echo "#################################################"

. ${BUILD_PATH}/Inspection/Php/tests.sh

# Stats & metrics
echo "#################################################"
echo "PHP stats"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Php/stats.sh

# Linting
echo "#################################################"
echo "Json and PHP linting"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Php/linting.sh
. ${BUILD_PATH}/Inspection/Json/linting.sh

# Code style
echo "#################################################"
echo "PHP coding style"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Php/style.sh

# Custom html inspections
echo "#################################################"
echo "Custom html inspection"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Html/tags.sh
. ${BUILD_PATH}/Inspection/Html/attributes.sh

# Custom php inspections
echo "#################################################"
echo "Custom php inspection"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Php/security.sh

# Build external test report
echo "#################################################"
echo "PHP test report"
echo "#################################################"
php ${TOOLS_PATH}/testreportgenerator.phar -b ${ROOT_PATH} -l ${BUILD_PATH}/Config/reportLang.php -c ${INSPECTION_PATH}/Test/Php/coverage.xml -u ${INSPECTION_PATH}/Test/Php/junit_php.xml -s ${INSPECTION_PATH}/Test/Php/junit_phpcs.xml -a ${INSPECTION_PATH}/Test/Php/phpstan.json -d ${INSPECTION_PATH}/Test/ReportExternal --version 1.0.0