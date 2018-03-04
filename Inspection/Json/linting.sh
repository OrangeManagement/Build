#!/bin/bash

. ${BUILD_PATH}/config.sh

echo "Start json linting inspection\n"

find ${ROOT_PATH} -name "*.json" | xargs -L1 jsonlint -q > ${INSPECTION_PATH}/Modules/linting/linting_json.log