#!/bin/bash

apt-get update

apt-get install git php7.2 php7.2-cli php7.2-common php7.2-json php7.2-opcache php7.2-pdo php7.2-sqlite php7.2-mbstring php7.2-curl php7.2-imap php7.2-bcmath php7.2-zip php7.2-dom php7.2-xml php7.2-phar php7.2-gd php7.2-dev php-pear apache2 mysql-server

a2enmod rewrite
a2enmod headers

pecl install ast

echo "extension=ast.so" | sudo tee /etc/php/7.2/mods-available/ast.ini
phpenmod ast

systemctl restart apache2
