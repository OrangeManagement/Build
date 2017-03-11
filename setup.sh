#!/bin/bash

. config.sh

# Previous cleanup
rm -r -f ${ROOT_PATH}
mkdir -p ${ROOT_PATH}

rm -r -f ${INSPECTION_PATH}
mkdir -p ${INSPECTION_PATH}

rm -r -f ${TOOLS_PATH}
mkdir -p ${TOOLS_PATH}

rm -r -f ${BUILD_PATH}
mkdir -p ${BUILD_PATH}

# Handling git
c=0;
for i in "${GITHUB_URL[@]}"
do
    if [ "$c" -eq 0 ]
    then
        cd ${BASE_PATH}
    fi

    if [ "$c" -eq 1 ]
    then
        cd ${ROOT_PATH}
    fi

    git clone -b ${GIT_BRANCH} $i
    c=$((c+1))
done

# Creating directories
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

# Permission handling
chmod -R 777 ${ROOT_PATH}

# Setting up database for demo and testing
mysql -e 'drop database if exists oms;' -u ${DB_USER} -p${DB_PASSWORD}
mysql -e 'create database oms;' -u ${DB_USER} -p${DB_PASSWORD}
#echo "USE mysql;\nUPDATE user SET password=PASSWORD('123456') WHERE user='root';\nFLUSH PRIVILEGES;\n" | mysql -u root

cd ${ROOT_PATH}
touch private.php

cd ${TOOLS_PATH}

# Downloading tools
wget -nc https://getcomposer.org/composer.phar
wget -nc https://phar.phpunit.de/phploc.phar
wget -nc https://phar.phpunit.de/phpunit.phar
wget -nc https://github.com/Halleck45/PhpMetrics/raw/master/build/phpmetrics.phar
wget -nc http://phpdoc.org/phpDocumentor.phar
wget -nc http://static.pdepend.org/php/latest/pdepend.phar
wget -nc https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
wget -nc http://static.phpmd.org/php/latest/phpmd.phar
wget -nc https://phar.phpunit.de/phpcpd.phar
wget -nc http://dl.google.com/closure-compiler/compiler-latest.tar.gz
tar -zxvf compiler-latest.tar.gz

php composer.phar install

# Installing tools
[[ $(jsonlint -h) != *"Usage: jsonlint"* ]] && npm install jsonlint -g
