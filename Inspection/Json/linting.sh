#!/bin/bash

. config.sh

echo "#################################################"
echo "Start json linting inspection"
echo "#################################################"

#find ${ROOT_PATH} -name "*.json" | xargs -L1 jsonlint -q > ${INSPECTION_PATH}/Modules/linting/linting_json.log