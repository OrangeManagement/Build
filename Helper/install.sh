#!/bin/bash

###############################################################
## General
###############################################################

# For every user .bash_profile
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> /var/www/html/backup/bash/$(date "+%Y-%m-%d").log; fi'

# Debian
#wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
#echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list

apt -y install software-properties-common
add-apt-repository ppa:ondrej/php

apt-get update

apt-get install php8.1 php8.1-dev php8.1-cli php8.1-common php8.1-mysql php8.1-pgsql php8.1-xdebug php8.1-opcache php8.1-pdo php8.1-sqlite php8.1-mbstring php8.1-curl php8.1-imap php8.1-bcmath php8.1-zip php8.1-dom php8.1-xml php8.1-phar php8.1-gd php-pear apache2 mysql-server wkhtmltopdf tesseract-ocr

a2enmod rewrite
a2enmod headers

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

###############################################################
## Jingga Server
###############################################################

apt-get install git borgbackup

### Install borg
borg init -v --encryption=repokey /var/www/html
borg key export /var/www/html repokey

###############################################################
## Developer
###############################################################

apt-get install npm git composer cmake postgresql postgresql-contrib pcov
composer install
composer update
npm install -D jasmine jasmine-node istanbul jasmine-console-reporter supertest jasmine-supertest selenium-webdriver chromedriver geckodriver eslint

### Setup postgresql

# /etc/postgresq/hba_..
# change from md5 to trust
# login to psql and \password define new password

update-rc.d postgresql enable
service postgresql start

# Install sqlsrv
# https://docs.microsoft.com/en-us/sql/connect/php/installation-tutorial-linux-mac?view=sql-server-2017
# https://www.sqlservercentral.com/blogs/reset-sa-password-on-sql-server-on-linux
# systemctl restart mssql-server

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
printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.1/mods-available/sqlsrv.ini
printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.1/mods-available/pdo_sqlsrv.ini
phpenmod -v 8.1 sqlsrv pdo_sqlsrv
service apache2 restart

pecl install ast

echo "extension=ast.so" | tee /etc/php/8.1/mods-available/ast.ini
phpenmod ast

# Install redis
sudo apt install redis-server
# /etc/redis/...config
# supervised systemd
# dir /var/lib/redis
systemctl restart redis

pecl install redis
echo "extension=redis.so" | tee /etc/php/8.1/mods-available/redis.ini
phpenmod redis

# Install memcached
apt-get install memcached libmemcached-dev libmemcached-tools php8.1-memcached
systemctl restart memcached
pecl install memcached
echo "extension=memcached.so" | tee /etc/php/8.1/mods-available/memcached.ini
phpenmod memcached

# create new user
#adduser test
#usermod -aG sudo test

# Install email server for testing
apt-get install dovecot-imapd dovecot-pop3d
# protocls = pop3 pop3s imap imaps
# pop3_uidl_format = %08Xu%08Xv
/etc/init.d/dovecot start
sudo useradd -d /home/test -g mail -u 1001 -s /bin/bash test
# Make sure no ssh is possible for this user

# FTP
apt-get install vsftpd

# /etc/vstftpd.conf
# write_enable=YES
# anon_upload_enable=YES
# connect_from_port_20=NO
