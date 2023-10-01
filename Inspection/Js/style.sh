#!/bin/bash

. "$BUILD_PATH/config.sh"

echo "#################################################"
echo "Start js style inspection"
echo "#################################################"

npx eslint ${INSPECTION_PATH} -c ${BUILD_PATH}/Config/.eslintrc.json -o ${OUTPUT_PATH}/eslint.txt
