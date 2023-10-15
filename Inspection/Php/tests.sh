#!/bin/bash

. "${BUILD_PATH}/config.sh"

echo "#################################################"
echo "Start php unit tests inspection"
echo "#################################################"

php -dpcov.enabled=1 -dxdebug.mode=coverage ${TOOLS_PATH}/vendor/bin/phpunit -v --configuration ${INSPECTION_PATH}/tests/phpunit_default.xml --log-junit ${OUTPUT_PATH}/junit_php.xml --testdox-html ${OUTPUT_PATH}/phpunit.html --coverage-html ${OUTPUT_PATH}/coverage --coverage-clover ${OUTPUT_PATH}/coverage.xml > ${OUTPUT_PATH}/phpunit.log || true

echo "#################################################"
echo "Start php static inspection"
echo "#################################################"

php -dmemory_limit=4G ${TOOLS_PATH}/vendor/bin/phpstan analyse --error-format=prettyJson --no-progress -l 9 -c ${BUILD_PATH}/Config/phpstan.neon ${INSPECTION_PATH} > ${OUTPUT_PATH}/phpstan.json || true

# Cli debugging
# php -dzend_extension=xdebug.so -dxdebug.mode=debug -dxdebug.profiler_enable=1