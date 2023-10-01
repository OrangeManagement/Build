#!/bin/bash

. config.sh

echo "#################################################"
echo "Start php stats inspection"
echo "#################################################"

#
php ${TOOLS_PATH}/vendor/bin/phploc ${INSPECTION_PATH} > ${OUTPUT_PATH}/phploc.log
php ${TOOLS_PATH}/vendor/bin/phpmetrics --config=${BUILD_PATH}/Config/phpmetrics.json --report-html=${OUTPUT_PATH}/metrics ${INSPECTION_PATH}