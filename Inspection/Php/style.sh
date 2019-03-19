#!/bin/bash

. config.sh

echo "Start php style inspection"

php ${TOOLS_PATH}/phpcs.phar ${ROOT_PATH}/phpOMS --standard="${BUILD_PATH}/Config/phpcs.xml" -s --report=full --report-file=${INSPECTION_PATH}/Framework/phpcs.log

php ${TOOLS_PATH}/phpcs.phar ${ROOT_PATH}/Web --standard="${BUILD_PATH}/Config/phpcs.xml" -s --report=full --report-file=${INSPECTION_PATH}/Modules/phpcs.log

php ${TOOLS_PATH}/phpcs.phar ${ROOT_PATH}/Modules --standard="${BUILD_PATH}/Config/phpcs.xml" -s --report=full --report-file=${INSPECTION_PATH}/Modules/phpcs.log

#php ${TOOLS_PATH}/phpmd.phar ${ROOT_PATH}/phpOMS text ${BUILD_PATH}/Config/phpmd.xml --exclude *tests* --minimumpriority 1