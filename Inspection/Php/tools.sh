#!/bin/bash

. ../../config.sh

php ${TOOLS_PATH}/phpcs.phar --report-file=${INSPECTION_PATH}/Framework/phpcs/phpcs.log --ignore=${ROOT_PATH}/phpOMS/Localization --standard=${INSPECTION_PATH}/Configs/phpcs.xml ${ROOT_PATH}/phpOMS
php ${TOOLS_PATH}/phpcs.phar --report-file=${INSPECTION_PATH}/Modules/phpcs/phpcs.log --standard=${INSPECTION_PATH}/Configs/phpcs.xml ${ROOT_PATH}/Modules
#php ${TOOLS_PATH}/phpmd.phar ${ROOT_PATH}/phpOMS xml ${INSPECTION_PATH}/Configs/phpmd.xml --reportfile ${INSPECTION_PATH}/logs/phpmdFramework.log -- bzip missing
#php ${TOOLS_PATH}/phpmd.phar ${ROOT_PATH}/Modules xml ${INSPECTION_PATH}/Configs/phpmd.xml --reportfile ${INSPECTION_PATH}/logs/phpmdModules.log -- bzip missing
php ${TOOLS_PATH}/phpcpd.phar ${ROOT_PATH}/phpOMS --exclude Localization --no-interaction > ${INSPECTION_PATH}/Framework/phpcpd/phpcpd.log
php ${TOOLS_PATH}/phpcpd.phar ${ROOT_PATH}/Modules --no-interaction > ${INSPECTION_PATH}/Modules/phpcpd/phpcpd.log