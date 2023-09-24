#!/bin/bash

# Include config
. config.sh

# Setup database
echo "#################################################"
echo "Setup database"
echo "#################################################"
mysql -e 'drop database if exists oms;' -u ${DB_USER} --password="${DB_PASSWORD}"
mysql -e 'create database oms;' -u ${DB_USER} --password="${DB_PASSWORD}"

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

# Build internal test report
echo "#################################################"
echo "Internal test report"
echo "#################################################"

echo -e "Internal test report"                                  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "Unit test"                                                > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Test/Php/phpunit.log > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "Static test"                                              > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Framework/phpstan.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/phpstan.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Model/phpstan.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/phpstan.log  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "PHP style test"                                           > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Framework/phpcs.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/phpcs.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Model/phpcs.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/phpcs.log  > ${INSPECTION_PATH}/internal_test_report.txt

cat ${INSPECTION_PATH}/Framework/rector.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/rector.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Model/rector.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/rector.log  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "JS style test"                                            > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Framework/eslint.txt  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "Stats"                                                    > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Framework/phploc.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/phploc.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Model/phploc.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/phploc.log  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "PHP security tests"                                       > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Framework/critical_php.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/critical_php.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Model/critical_php.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/critical_php.log  > ${INSPECTION_PATH}/internal_test_report.txt

cat ${INSPECTION_PATH}/Framework/strict_missing_php.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/strict_missing_php.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Model/strict_missing_php.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/strict_missing_php.log  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "JS security tests"                                        > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Framework/critical_js.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/critical_js.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/critical_js.log  > ${INSPECTION_PATH}/internal_test_report.txt

cat ${INSPECTION_PATH}/Framework/strict_missing_js.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/strict_missing_js.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Model/strict_missing_js.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/strict_missing_js.log  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "Linting tests"                                            > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Framework/linting_php.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/linting_php.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Model/linting_php.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/linting_php.log  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "DB queries"                                               > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat  ${INSPECTION_PATH}/Sql/slow_queries.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat  ${INSPECTION_PATH}/Sql/locked_queries.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat  ${INSPECTION_PATH}/Sql/query_details.log  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "Html tags"                                                > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Framework/html_tags.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/html_tags.log  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "Html syntax"                                              > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/html_syntax.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/html_syntax.log  > ${INSPECTION_PATH}/internal_test_report.txt

echo -e "\n\n#################################################" > ${INSPECTION_PATH}/internal_test_report.txt
echo "Static text"                                              > ${INSPECTION_PATH}/internal_test_report.txt
echo -e "#################################################\n\n" > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Modules/static_text.log  > ${INSPECTION_PATH}/internal_test_report.txt
cat ${INSPECTION_PATH}/Web/static_text.log  > ${INSPECTION_PATH}/internal_test_report.txt

# Build external test report
echo "#################################################"
echo "Test report"
echo "#################################################"
php {TOOLS_PATH}/TestReportGenerator/src/index.php \
-b ${ROOT_PATH} \
-l ${BUILD_PATH}/Config/reportLang.php \
-s ${INSPECTION_PATH}/Test/Php/junit_phpcs.xml \
-sj ${INSPECTION_PATH}/Test/Js/junit_eslint.xml \
-a ${INSPECTION_PATH}/Test/Php/phpstan.json \
-c ${INSPECTION_PATH}/Test/Php/coverage.xml \
-u ${INSPECTION_PATH}/Test/Php/junit_php.xml \
-d ${INSPECTION_PATH}/Test/ReportExternal \
--version 1.0.0
