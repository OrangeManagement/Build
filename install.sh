#!/bin/bash

# create new user
adduser test
usermod -aG sudo test


# Debian
#wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
#echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list

apt-get update

apt-get install npm git php7.2 php7.2-cli php7.2-common php7.2-mysql php7.2-pgsql php7.2-xdebug php7.2-json php7.2-opcache php7.2-pdo php7.2-sqlite php7.2-mbstring php7.2-curl php7.2-imap php7.2-bcmath php7.2-zip php7.2-dom php7.2-xml php7.2-phar php7.2-gd php7.2-dev php-pear apache2 mysql-server postgresql postgresql-contrib

# USE mysql;
# mysql < 5.7
# UPDATE user SET plugin='mysql_native_password' WHERE User='root';
# FLUSH PRIVILEGES;
# exit;
# else mysql >= 5.7
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';

update-rc.d postgresql enable

a2enmod rewrite
a2enmod headers

pecl install ast

echo "extension=ast.so" | tee /etc/php/7.2/mods-available/ast.ini
phpenmod ast

# Install redis
sudo apt install redis-server
# /etc/redis/...conifg
# supervised systemd
# dir /var/lib/redis
systemctl restart redis

pecl install redis
echo "extension=redis.so" | tee /etc/php/7.2/mods-available/redis.ini
phpenmod redis

# Install memcached
apt-get install memcached libmemcached-dev libmemcached-tools
systemctl restart memcached
pecl install memcached
echo "extension=memcached.so" | tee /etc/php/7.2/mods-available/memcached.ini
phpenmod memcached

# Install email server for testing
apt-get install dovecot-imapd dovecot-pop3d
# protocls = pop3 pop3s imap imaps
# pop3_uidl_format = %08Xu%08Xv
/etc/init.d/dovecot start
sudo useradd -d /home/test -g mail -u 1001 -s /bin/bash test

# npm
npm install -D jasmine jasmine-node istanbul jasmine-console-reporter supertest jasmine-supertest

systemctl restart apache2

# FTP
apt-get install vsftpd

# /etc/vstftpd.conf
# write_enable=YES
# anon_upload_enable=YES
# connect_from_port_20=NO