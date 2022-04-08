#!/bin/bash

. config.sh

echo "#################################################"
echo "Start js style inspection"
echo "#################################################"

npx eslint ${ROOT_PATH}/jsOMS -c ${BUILD_PATH}/Config/.eslintrc.json -o ${INSPECTION_PATH}/Framework/eslint.txt
npx eslint ${ROOT_PATH}/jsOMS -c ${BUILD_PATH}/Config/.eslintrc.json -o ${INSPECTION_PATH}/Test/Js/junit_eslint.xml -f junit
