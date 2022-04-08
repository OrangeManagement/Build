#!/bin/bash

# Include config
. config.sh

# Clean setup
. setup.sh

cd ${BUILD_PATH}

# Run inspection
. ${BUILD_PATH}/Inspection/inspect.sh
