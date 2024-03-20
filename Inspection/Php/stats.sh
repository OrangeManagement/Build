#!/bin/bash

. "${BUILD_PATH}/config.sh"

echo "#################################################"
echo "Start php stats inspection"
echo "#################################################"

#
#php ${TOOLS_PATH}/vendor/bin/phploc ${INSPECTION_PATH} > ${OUTPUT_PATH}/phploc.log || true
php ${TOOLS_PATH}/vendor/bin/phpmetrics --config=${BUILD_PATH}/Config/phpmetrics.json --junit=${OUTPUT_PATH}/junit_php.xml --report-html=${OUTPUT_PATH}/metrics ${INSPECTION_PATH} || true