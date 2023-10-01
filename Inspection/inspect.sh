#!/bin/bash

# Include config
. config.sh

# Setup database
echo "#################################################"
echo "Setup database"
echo "#################################################"
mysql -e 'drop database if exists omb;' -u ${DB_USER} --password="${DB_PASSWORD}"
mysql -e 'create database omb;' -u ${DB_USER} --password="${DB_PASSWORD}"

# Build js
#. Js/build.sh

# Executing unit tests
echo "#################################################"
echo "PHP tests"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Php/tests.sh

# Executing query inspections AFTER the unit test which also runs queries
# This requires MYSQL with query logging enabled
echo "#################################################"
echo "MYSQL queries"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Sql/performance.sh

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
echo "PHP and JS coding style"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Php/style.sh
. ${BUILD_PATH}/Inspection/Js/style.sh

# Custom html inspections
echo "#################################################"
echo "Custom html inspection"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Html/tags.sh
. ${BUILD_PATH}/Inspection/Html/syntax.sh
. ${BUILD_PATH}/Inspection/Html/static_text.sh

# Custom php inspections
echo "#################################################"
echo "Custom php inspection"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Php/security.sh

# Custom js inspections
echo "#################################################"
echo "Custom js inspection"
echo "#################################################"
. ${BUILD_PATH}/Inspection/Js/security.sh

# Build external test report
echo "#################################################"
echo "Test report"
echo "#################################################"
php ${TOOLS_PATH}/TestReportGenerator/src/index.php \
-b ${ROOT_PATH} \
-l ${BUILD_PATH}/Config/reportLang.php \
-s ${OUTPUT_PATH}/junit_phpcs.xml \
-sj ${OUTPUT_PATH}/junit_eslint.xml \
-a ${OUTPUT_PATH}/phpstan.json \
-c ${OUTPUT_PATH}/coverage.xml \
-u ${OUTPUT_PATH}/junit_php.xml \
-d ${OUTPUT_PATH}/ReportExternal \
--version 1.0.0
