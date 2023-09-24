#!/bin/bash

. config.sh

echo "#################################################"
echo "Start php stats inspection"
echo "#################################################"

#
php ${ROOT_PATH}/vendor/bin/phploc ${ROOT_PATH}/phpOMS/ > ${INSPECTION_PATH}/Framework/phploc.log
php ${ROOT_PATH}/vendor/bin/phploc ${ROOT_PATH}/Web/ > ${INSPECTION_PATH}/Web/phploc.log
php ${ROOT_PATH}/vendor/bin/phploc ${ROOT_PATH}/Modules/ > ${INSPECTION_PATH}/Modules/phploc.log
php ${ROOT_PATH}/vendor/bin/phploc ${ROOT_PATH}/Model/ > ${INSPECTION_PATH}/Model/phploc.log

#
php ${ROOT_PATH}/vendor/bin/phpmetrics --report-html=${INSPECTION_PATH}/Framework/metrics/metrics.html ${ROOT_PATH}/phpOMS/ >> ${INSPECTION_PATH}/Framework/build.log
php ${ROOT_PATH}/vendor/bin/phpmetrics --report-html=${INSPECTION_PATH}/Modules/metrics/metrics.html ${ROOT_PATH}/Modules/ >> ${INSPECTION_PATH}/Modules/build.log
