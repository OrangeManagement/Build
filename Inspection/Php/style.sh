#!/bin/bash

. config.sh

echo "#################################################"
echo "Start php style inspection"
echo "#################################################"

php ${ROOT_PATH}/vendor/bin/phpcs ${ROOT_PATH}/phpOMS --standard="${BUILD_PATH}/Config/phpcs.xml" -s --report-full=${INSPECTION_PATH}/Framework/phpcs.log --report-junit=${INSPECTION_PATH}/Framework/phpcs.xml

php ${ROOT_PATH}/vendor/bin/phpcs ${ROOT_PATH}/Web --standard="${BUILD_PATH}/Config/phpcs.xml" -s --report-full=${INSPECTION_PATH}/Modules/phpcs.log --report-junit=${INSPECTION_PATH}/Modules/phpcs.xml

php ${ROOT_PATH}/vendor/bin/phpcs ${ROOT_PATH}/Modules --standard="${BUILD_PATH}/Config/phpcs.xml" -s --report-full=${INSPECTION_PATH}/Modules/phpcs.log --report-junit=${INSPECTION_PATH}/Modules/phpcs.xml

php ${ROOT_PATH}/vendor/bin/phpcs ${ROOT_PATH} --standard="${BUILD_PATH}/Config/phpcs.xml" -s --report-full=${INSPECTION_PATH}/Test/Php/phpcs.log --report-junit=${INSPECTION_PATH}/Test/Php/junit_php.xml

#php ${TOOLS_PATH}/phpmd.phar ${ROOT_PATH}/phpOMS text ${BUILD_PATH}/Config/phpmd.xml --exclude *tests* --minimumpriority 1