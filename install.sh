#!/bin/bash

. config.sh

apt-get update

apt-get install php7.2-dev php-pear

pecl install ast

echo "extension=ast.so" > /etc/php/7.2/mods-available/ast.ini
phpenmod ast