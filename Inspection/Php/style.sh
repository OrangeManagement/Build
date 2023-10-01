#!/bin/bash

. "$BUILD_PATH/config.sh"

echo "#################################################"
echo "Start php style inspection"
echo "#################################################"

php ${TOOLS_PATH}/vendor/bin/phpcs ${INSPECTION_PATH} --standard="${BUILD_PATH}/Config/phpcs.xml" -s --report-full=${OUTPUT_PATH}/phpcs.log --report-junit=${OUTPUT_PATH}/phpcs.xml

php ${TOOLS_PATH}/vendor/bin/rector --dry-run --config ${BUILD_PATH}/Config/rector.php process ${INSPECTION_PATH} > ${OUTPUT_PATH}/rector.log
