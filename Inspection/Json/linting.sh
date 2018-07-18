#!/bin/bash

. config.sh

echo "Start json linting inspection"

#find ${ROOT_PATH} -name "*.json" | xargs -L1 jsonlint -q > ${INSPECTION_PATH}/Modules/linting/linting_json.log