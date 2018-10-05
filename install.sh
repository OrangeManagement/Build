#!/bin/bash

apt-get update

apt-get install git php7.2 php7.2-cli php7.2-common php7.2-mysql php7.2-xdebug php7.2-json php7.2-opcache php7.2-pdo php7.2-sqlite php7.2-mbstring php7.2-curl php7.2-imap php7.2-bcmath php7.2-zip php7.2-dom php7.2-xml php7.2-phar php7.2-gd php7.2-dev php-pear apache2 mysql-server

a2enmod rewrite
a2enmod headers

pecl install ast

echo "extension=ast.so" | tee /etc/php/7.2/mods-available/ast.ini
phpenmod ast

systemctl restart apache2

# Install redis
apt-get install apt-get install build-essential tcl
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make
make test
make install
mkdir /etc/redis
cp /tmp/redis-stable/redis.conf /etc/redis
nano /etc/redis/redis.conf
# supervised systemd
# dir /var/lib/redis
nano /etc/systemd/system/redis.service
echo "[Unit]" >> /etc/systemd/system/redis.service
echo "Description=Redis In-Memory Data Store" >> /etc/systemd/system/redis.service
echo "After=network.target" >> /etc/systemd/system/redis.service
echo "[Service]" >> /etc/systemd/system/redis.service
echo "User=redis" >> /etc/systemd/system/redis.service
echo "Group=redis" >> /etc/systemd/system/redis.service
echo "ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf" >> /etc/systemd/system/redis.service
echo "ExecStop=/usr/local/bin/redis-cli shutdown" >> /etc/systemd/system/redis.service
echo "Restart=always" >> /etc/systemd/system/redis.service
echo "[Install]" >> /etc/systemd/system/redis.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/redis.service
adduser --system --group --no-create-home redis
mkdir /var/lib/redis
chown redis:redis /var/lib/redis
chmod 770 /var/lib/redis
systemctl start redis
systemctl enable redis

pecl install redis
echo "extension=redis.so" | tee /etc/php/7.2/mods-available/redis.ini
phpenmod redis

# Install memcached
apt-get install memcached libmemcached-dev libmemcached-tools
systemctl restart memcached
pecl install memcached
echo "extension=memcached.so" | tee /etc/php/7.2/mods-available/memcached.ini
phpenmod memcached