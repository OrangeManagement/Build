#!/bin/bash

# create new user
adduser test
usermod -aG sudo test

# Debian
#wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
#echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list

apt -y install software-properties-common
add-apt-repository ppa:ondrej/php

apt-get update

apt-get install npm git php8.0 php8.0-dev php8.0-cli php8.0-common php8.0-mysql php8.0-pgsql php8.0-xdebug php8.0-opcache php8.0-pdo php8.0-sqlite php8.0-mbstring php8.0-curl php8.0-imap php8.0-bcmath php8.0-zip php8.0-dom php8.0-xml php8.0-phar php8.0-gd php-pear apache2 mysql-server postgresql postgresql-contrib pcov

# USE mysql;
# mysql < 5.7
# UPDATE user SET plugin='mysql_native_password' WHERE User='root';
# UPDATE user SET password=PASSWORD("") WHERE User='root';
# FLUSH PRIVILEGES;
# exit;
# else mysql >= 5.7
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';
# else mysql even newer
# UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
# flush privileges;
# update mysql.user set plugin='' where user='root';
# flush privileges;

# /etc/postgresq/hba_..
# change from md5 to trust
# login to psql and \password define new password

update-rc.d postgresql enable
service postgresql start

# Install sqlsrv
# https://docs.microsoft.com/en-us/sql/connect/php/installation-tutorial-linux-mac?view=sql-server-2017
# https://www.sqlservercentral.com/blogs/reset-sa-password-on-sql-server-on-linux
# systemctl restart mssql-server

a2enmod rewrite
a2enmod headers

pecl install ast

echo "extension=ast.so" | tee /etc/php/8.0/mods-available/ast.ini
phpenmod ast

# Install redis
sudo apt install redis-server
# /etc/redis/...config
# supervised systemd
# dir /var/lib/redis
systemctl restart redis

pecl install redis
echo "extension=redis.so" | tee /etc/php/8.0/mods-available/redis.ini
phpenmod redis

# Install memcached
apt-get install memcached libmemcached-dev libmemcached-tools php8.0-memcached
systemctl restart memcached
pecl install memcached
echo "extension=memcached.so" | tee /etc/php/8.0/mods-available/memcached.ini
phpenmod memcached

# Install email server for testing
apt-get install dovecot-imapd dovecot-pop3d
# protocls = pop3 pop3s imap imaps
# pop3_uidl_format = %08Xu%08Xv
/etc/init.d/dovecot start
sudo useradd -d /home/test -g mail -u 1001 -s /bin/bash test
# Make sure no ssh is possible for this user

# npm
npm install -D jasmine jasmine-node istanbul jasmine-console-reporter supertest jasmine-supertest selenium-webdriver chromedriver geckodriver

# FTP
apt-get install vsftpd

#OCR
sudo apt-get install tesseract-ocr
#tesseract ../copyright.png -c preserve_interword_spaces=1 stdout

# /etc/vstftpd.conf
# write_enable=YES
# anon_upload_enable=YES
# connect_from_port_20=NO

systemctl restart apache2

# consider:
# "mb_str_functions": true,
# "phpdoc_add_missing_param_annotation": true,

#Mssql
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)"
apt-get update
apt-get install -y mssql-server
/opt/mssql/bin/mssql-conf setup
systemctl status mssql-server --no-pager
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
apt-get install libodbc1 unixodbc unixodbc-dev msodbcsql
https://packages.microsoft.com/config/ubuntu/18.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo apt-get install mssql-tools unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
sudo pecl install sqlsrv
sudo pecl install pdo_sqlsrv
printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.0/mods-available/sqlsrv.ini
printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.0/mods-available/pdo_sqlsrv.ini
phpenmod -v 8.0 sqlsrv pdo_sqlsrv
service apache2 restart

npm install -g sitespeed.io
sitespeed.io Build/Helper/sitespeedUrls.txt -n 1 --preScript Build/Helper/sitespeedAuth.js --outputFolder Build/sitespeed