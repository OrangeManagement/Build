#!/bin/bash

. config.sh

echo "#################################################"
echo "Start php unit tests inspection"
echo "#################################################"

php ${TOOLS_PATH}/phpunit.phar -v --configuration ${ROOT_PATH}/tests/phpunit_default.xml --log-junit ${INSPECTION_PATH}/Test/Php/junit_php.xml --testdox-html ${INSPECTION_PATH}/Test/Php/index.html --coverage-html ${INSPECTION_PATH}/Test/Php/coverage --coverage-clover ${INSPECTION_PATH}/Test/Php/coverage.xml > ${INSPECTION_PATH}/Test/Php/phpunit.log

echo "#################################################"
echo "Start php static inspection"
echo "#################################################"

php -d memory_limit=4G ${TOOLS_PATH}/phpstan.phar analyse --autoload-file=${ROOT_PATH}/phpOMS/Autoloader.php -l 7 -c ${BUILD_PATH}/Config/phpstan.neon ${ROOT_PATH}/phpOMS > ${INSPECTION_PATH}/Framework/phpstan.log
php -d memory_limit=4G ${TOOLS_PATH}/phpstan.phar analyse --autoload-file=${ROOT_PATH}/phpOMS/Autoloader.php -l 7 -c ${BUILD_PATH}/Config/phpstan.neon ${ROOT_PATH}/Modules > ${INSPECTION_PATH}/Modules/phpstan.log
php -d memory_limit=4G ${TOOLS_PATH}/phpstan.phar analyse --autoload-file=${ROOT_PATH}/phpOMS/Autoloader.php -l 7 -c ${BUILD_PATH}/Config/phpstan.neon ${ROOT_PATH}/Model > ${INSPECTION_PATH}/Model/phpstan.log
php -d memory_limit=4G ${TOOLS_PATH}/phpstan.phar analyse --autoload-file=${ROOT_PATH}/phpOMS/Autoloader.php -l 7 -c ${BUILD_PATH}/Config/phpstan.neon ${ROOT_PATH}/Web > ${INSPECTION_PATH}/Web/phpstan.log

php -d memory_limit=4G ${TOOLS_PATH}/phpstan.phar analyse --autoload-file=${ROOT_PATH}/phpOMS/Autoloader.php -l 7 -c ${BUILD_PATH}/Config/phpstan.neon --error-format=json ${ROOT_PATH}/phpOMS > ${INSPECTION_PATH}/Test/Php/phpstan.json
