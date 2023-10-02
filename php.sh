#!/bin/bash

# Include config
BUILD_PATH="$(dirname "$(readlink -f "$0")")"
. "${BUILD_PATH}/config.sh"

if [ $# -eq 0 ]; then
    echo "No parameters provided."
    exit 1
fi

REPO_PATH="$1"
BASE_NAME=$(basename "$REPO_PATH" .git)
INSPECTION_PATH="$(realpath "$2")/${BASE_NAME}"
OUTPUT_PATH="$(realpath "$2")/${BASE_NAME}/build"

if [ "$OUTPUT_PATH" == "/" ] || [ "$INSPECTION_PATH" == "/" ]; then
    echo "Bad path"
    exit 1
fi

rm -rf "${INSPECTION_PATH}"

git clone --recurse-submodules ${REPO_PATH} ${INSPECTION_PATH}
git -C ${INSPECTION_PATH} checkout develop
git -C ${INSPECTION_PATH} pull
git -C ${INSPECTION_PATH} submodule foreach 'git checkout develop || true'
git -C ${INSPECTION_PATH} submodule foreach 'git pull || true'

mkdir -p "${OUTPUT_PATH}"
mkdir -p "${OUTPUT_PATH}/ReportExternal"
mkdir -p "${OUTPUT_PATH}/coverage"
mkdir -p "${OUTPUT_PATH}/phpunit"
mkdir -p "${OUTPUT_PATH}/metrics"

if [[ ${BASE_NAME} == *"oms-"* ]]; then
    git clone --recurse-submodules https://github.com/Karaka-Management/Karaka.git ${INSPECTION_PATH}/MainRepository
    git -C ${INSPECTION_PATH}/MainRepository checkout develop
    git -C ${INSPECTION_PATH}/MainRepository pull
    git -C ${INSPECTION_PATH}/MainRepository submodule foreach 'git checkout develop || true'
    git -C ${INSPECTION_PATH}/MainRepository submodule foreach 'git pull || true'
fi

# Run inspection
. ${BUILD_PATH}/Inspection/inspect.sh
