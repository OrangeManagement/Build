#!/bin/bash

. config.sh

php ${TOOLS_PATH}/phpcs.phar ${ROOT_PATH}/phpOMS --colors --standard="${BUILD_PATH}/phpcs.xml" -s --report=full
php ${TOOLS_PATH}/phpmd.phar ${ROOT_PATH}/phpOMS text ${BUILD_PATH}/phpmd.xml --exclude *tests* --minimumpriority 1