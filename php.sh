#!/bin/bash

# Include config
BUILD_PATH="$(dirname "$(readlink -f "$0")")"
. "${BUILD_PATH}/config.sh"

if [ $# -eq 0 ]; then
  echo "No parameters provided."
  exit 1
fi

INSPECTION_PATH="$1"
OUTPUT_PATH="$2"

if [ "$OUTPUT_PATH" == "/" ] || [ "$OUTPUT_PATH" == "/etc" ]; then
    echo "Bad path"
    exit 1
fi

rm -rf ${OUTPUT_PATH}
mkdir -p ${OUTPUT_PATH}
mkdir -p ${OUTPUT_PATH}/ReportExternal
mkdir -p ${OUTPUT_PATH}/coverage
mkdir -p ${OUTPUT_PATH}/phpunit
mkdir -p ${OUTPUT_PATH}/metrics

# Run inspection
. ${BUILD_PATH}/Inspection/inspect.sh
