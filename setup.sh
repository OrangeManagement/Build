#!/bin/bash

. config.sh

# Previous cleanup
rm -r -f ${ROOT_PATH}
rm -r -f ${BASE_PATH}/Website
rm -r -f ${BASE_PATH}/phpOMS
rm -r -f ${BASE_PATH}/jsOMS
rm -r -f ${BASE_PATH}/cssOMS

rm -r -f ${INSPECTION_PATH}
mkdir -p ${INSPECTION_PATH}

cd ${BASE_PATH}

# Create git repositories
for i in "${GITHUB_URL[@]}"
do
    git clone -b ${GIT_BRANCH} $i
done

cd ${ROOT_PATH}
git submodule update --init --recursive
git submodule foreach git checkout develop

# Creating directories for inspection
mkdir -p ${INSPECTION_PATH}/logs
mkdir -p ${INSPECTION_PATH}/Framework/logs
mkdir -p ${INSPECTION_PATH}/Framework/metrics
mkdir -p ${INSPECTION_PATH}/Framework/pdepend
mkdir -p ${INSPECTION_PATH}/Framework/phpcs
mkdir -p ${INSPECTION_PATH}/Framework/phpcpd
mkdir -p ${INSPECTION_PATH}/Framework/linting
mkdir -p ${INSPECTION_PATH}/Framework/html

mkdir -p ${INSPECTION_PATH}/Modules/logs
mkdir -p ${INSPECTION_PATH}/Modules/metrics
mkdir -p ${INSPECTION_PATH}/Modules/pdepend
mkdir -p ${INSPECTION_PATH}/Modules/phpcs
mkdir -p ${INSPECTION_PATH}/Modules/phpcpd
mkdir -p ${INSPECTION_PATH}/Modules/linting
mkdir -p ${INSPECTION_PATH}/Modules/html

mkdir -p ${INSPECTION_PATH}/Framework
mkdir -p ${INSPECTION_PATH}/Web
mkdir -p ${INSPECTION_PATH}/Model
mkdir -p ${INSPECTION_PATH}/Modules

mkdir -p ${INSPECTION_PATH}/Test/Php
mkdir -p ${INSPECTION_PATH}/Test/Js

# Permission handling
chmod -R 777 ${ROOT_PATH}

cd ${ROOT_PATH}

# Setup tools for inspection
if [ ! -d "$TOOLS_PATH" ]; then
    mkdir -p ${TOOLS_PATH}

    cd ${TOOLS_PATH}

    # Downloading tools
    wget -nc https://getcomposer.org/composer.phar
    wget -nc https://phar.phpunit.de/phploc.phar
    wget -nc https://phar.phpunit.de/phpunit.phar
    wget -nc https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.2.2/phpcs.phar
    wget -nc http://static.phpmd.org/php/latest/phpmd.phar
    wget -nc https://github.com/Halleck45/PhpMetrics/raw/master/build/phpmetrics.phar
    wget -nc http://static.pdepend.org/php/latest/pdepend.phar
    wget -nc http://dl.google.com/closure-compiler/compiler-latest.tar.gz
    wget -nc https://github.com/Orange-Management/Documentor/releases/download/1.1.0/documentor.phar
    wget -nc https://github.com/phpstan/phpstan/releases/download/0.9.2/phpstan.phar
    tar -zxvf compiler-latest.tar.gz

    chmod -R 777 ${TOOLS_PATH}
    cp ${ROOT_PATH}/composer.json ${TOOLS_PATH}/composer.json

    php ${TOOLS_PATH}/composer.phar install --working-dir=${ROOT_PATH}/
fi
