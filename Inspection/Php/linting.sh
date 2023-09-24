#!/bin/bash

. config.sh

echo "#################################################"
echo "Start php linting inspection"
echo "#################################################"

find ${ROOT_PATH}/phpOMS -name "*.php" | xargs -L1 php -l > ${INSPECTION_PATH}/logs/temp.log
sed '/^No syntax.*/ d' < ${INSPECTION_PATH}/logs/temp.log > ${INSPECTION_PATH}/Framework/linting_php.log

find ${ROOT_PATH}/Web -name "*.php" | xargs -L1 php -l > ${INSPECTION_PATH}/logs/temp.log
sed '/^No syntax.*/ d' < ${INSPECTION_PATH}/logs/temp.log > ${INSPECTION_PATH}/Framework/linting_php.log

find ${ROOT_PATH}/Modules -name "*.php" | xargs -L1 php -l > ${INSPECTION_PATH}/logs/temp.log
sed '/^No syntax.*/ d' < ${INSPECTION_PATH}/logs/temp.log > ${INSPECTION_PATH}/Modules/linting_php.log

find ${ROOT_PATH}/Model -name "*.php" | xargs -L1 php -l > ${INSPECTION_PATH}/logs/temp.log
sed '/^No syntax.*/ d' < ${INSPECTION_PATH}/logs/temp.log > ${INSPECTION_PATH}/Model/linting_php.log

rm ${INSPECTION_PATH}/logs/temp.log