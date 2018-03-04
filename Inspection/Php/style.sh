#!/bin/bash

. ${BUILD_PATH}/config.sh

php ${TOOLS_PATH}/phpcs.phar ${ROOT_PATH}/phpOMS --standard="${BUILD_PATH}/Config/phpcs.xml" -s --report=full
php ${TOOLS_PATH}/phpmd.phar ${ROOT_PATH}/phpOMS text ${BUILD_PATH}/Config/phpmd.xml --exclude *tests* --minimumpriority 1