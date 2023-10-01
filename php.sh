#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/script2.sh"

# Include config
. "$SCRIPT_DIR/config.sh"

if [ $# -eq 0 ]; then
  echo "No parameters provided."
  exit 1
fi

INSPECTION_PATH="$1"
OUTPUT_PATH="$2"

# Run inspection
. ${BUILD_PATH}/Inspection/inspect.sh
