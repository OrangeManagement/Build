#!/bin/bash

. config.sh

echo "#################################################"
echo "Start php linting inspection"
echo "#################################################"

find ${INSPECTION_PATH} -name "*.php" | xargs -L1 php -l > ${OUTPUT_PATH}/temp.log
sed '/^No syntax.*/ d' < ${OUTPUT_PATH}/temp.log > ${OUTPUT_PATH}/linting_php.log

rm ${OUTPUT_PATH}/temp.log