#!/bin/bash

# Include config
BUILD_PATH="$(dirname "$(readlink -f "$0")")"
. "$BUILD_PATH/config.sh"

if [ $# -eq 0 ]; then
  echo "No parameters provided."
  exit 1
fi

INSPECTION_PATH="$1"
OUTPUT_PATH="$2"

# Run inspection
. ${BUILD_PATH}/Inspection/inspect.sh
