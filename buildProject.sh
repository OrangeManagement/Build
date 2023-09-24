#!/bin/bash

# Include config
. config.sh

# Clean setup
echo "#################################################"
echo "Remove old setup"
echo "#################################################"

# Previous cleanup
rm -r -f ${ROOT_PATH}
rm -r -f ${BASE_PATH}/phpOMS
rm -r -f ${BASE_PATH}/jsOMS
rm -r -f ${BASE_PATH}/cssOMS
rm -r -f ${TOOLS_PATH}

rm -r -f ${INSPECTION_PATH}
mkdir -p ${INSPECTION_PATH}

cd ${BASE_PATH}

echo "#################################################"
echo "Setup repositories"
echo "#################################################"

# Create git repositories
for i in "${GITHUB_URL[@]}"
do
    git clone -b ${GIT_BRANCH} $i >/dev/null
done

cd ${ROOT_PATH}
git submodule update --init --recursive >/dev/null
git submodule foreach git checkout develop >/dev/null

echo "#################################################"
echo "Setup build output"
echo "#################################################"

# Creating directories for inspection
mkdir -p ${INSPECTION_PATH}/logs
mkdir -p ${INSPECTION_PATH}/Framework/logs
mkdir -p ${INSPECTION_PATH}/Framework/metrics
#mkdir -p ${INSPECTION_PATH}/Framework/pdepend
mkdir -p ${INSPECTION_PATH}/Framework/phpcs
mkdir -p ${INSPECTION_PATH}/Framework/phpcpd
mkdir -p ${INSPECTION_PATH}/Framework/linting
mkdir -p ${INSPECTION_PATH}/Framework/html

mkdir -p ${INSPECTION_PATH}/Modules/logs
mkdir -p ${INSPECTION_PATH}/Modules/metrics
#mkdir -p ${INSPECTION_PATH}/Modules/pdepend
mkdir -p ${INSPECTION_PATH}/Modules/phpcs
mkdir -p ${INSPECTION_PATH}/Modules/phpcpd
mkdir -p ${INSPECTION_PATH}/Modules/linting
mkdir -p ${INSPECTION_PATH}/Modules/html

mkdir -p ${INSPECTION_PATH}/Web/logs
mkdir -p ${INSPECTION_PATH}/Web/metrics
#mkdir -p ${INSPECTION_PATH}/Web/pdepend
mkdir -p ${INSPECTION_PATH}/Web/phpcs
mkdir -p ${INSPECTION_PATH}/Web/phpcpd
mkdir -p ${INSPECTION_PATH}/Web/linting
mkdir -p ${INSPECTION_PATH}/Web/html

mkdir -p ${INSPECTION_PATH}/Framework
mkdir -p ${INSPECTION_PATH}/Web
mkdir -p ${INSPECTION_PATH}/Model
mkdir -p ${INSPECTION_PATH}/Modules

mkdir -p ${INSPECTION_PATH}/Test/Php
mkdir -p ${INSPECTION_PATH}/Test/Js
mkdir -p ${INSPECTION_PATH}/Test/sitespeed

mkdir -p ${INSPECTION_PATH}/Sql

# Permission handling
chmod -R 777 ${ROOT_PATH}

# Setup tools for inspection
mkdir -p ${TOOLS_PATH}

echo "#################################################"
echo "Setup tools"
echo "#################################################"

cd ${ROOT_PATH}
composer install
npm install

cd ${BUILD_PATH}

# Run inspection
. ${BUILD_PATH}/Inspection/inspect.sh
