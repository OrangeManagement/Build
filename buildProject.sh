#!/bin/bash

# Include config
. config.sh

# Clean setup
. setup.sh

cd ${BUILD_PATH}

# Run inspection
. ${BUILD_PATH}/Inspection/inspect.sh

# Build documentation
#php ${TOOLS_PATH}/documentor.phar -s ${ROOT_PATH}/phpOMS -d ${BASE_PATH}/Inspection/Test/Php/docblock -c ${INSPECTION_PATH}/Test/Php/coverage.xml -u ${INSPECTION_PATH}/Test/Php/junit_php.xml -b http://docs.orange-management.de
