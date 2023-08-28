#!/bin/bash

###############################################################
## General
###############################################################

# For every user .bash_profile

export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> /var/www/html/backup/bash/$(date "+%Y-%m-%d").log; fi'

apt-get update

apt-get install git snapd ufw

# Security

apt-get install ufw
ufw allow ssh
ufw allow http
ufw allow https

apt-get install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
service fail2ban restart

# SSH

# TODO: upload ssh key and disable password login if successful
# https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04

###############################################################
## Web
###############################################################

apt-get install php8.1 php8.1-dev php8.1-cli php8.1-common php8.1-mysql php8.1-pgsql php8.1-xdebug php8.1-opcache php8.1-pdo php8.1-sqlite php8.1-mbstring php8.1-curl php8.1-imap php8.1-bcmath php8.1-zip php8.1-dom php8.1-xml php8.1-phar php8.1-gd php-pear apache2 mysql-server wkhtmltopdf tesseract-ocr

a2enmod rewrite
a2enmod headers

# Apache2

cat << EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga

    SetEnv OMS_STRIPE_SECRET 1
    SetEnv OMS_STRIPE_PUBLIC 2
    SetEnv OMS_STRIPE_WEBHOOK 3
    SetEnv OMS_PRIVATE_KEY_I 4

    <Directory /var/www/html/jingga>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

cat << EOF > /etc/apache2/sites-available/001-saas.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName orw.jingga.app
    ServerAlias www.orw.jingga.app

    SetEnv OMS_STRIPE_SECRET 1
    SetEnv OMS_STRIPE_PUBLIC 2
    SetEnv OMS_STRIPE_WEBHOOK 3
    SetEnv OMS_PRIVATE_KEY_I 4

    <Directory /var/www/html/jingga>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName invoicing.jingga.app
    ServerAlias www.invoicing.jingga.app

    SetEnv OMS_STRIPE_SECRET 1
    SetEnv OMS_STRIPE_PUBLIC 2
    SetEnv OMS_STRIPE_WEBHOOK 3
    SetEnv OMS_PRIVATE_KEY_I 4

    <Directory /var/www/html/jingga>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName fleetmanagement.jingga.app
    ServerAlias www.fleetmanagement.jingga.app

    SetEnv OMS_STRIPE_SECRET 1
    SetEnv OMS_STRIPE_PUBLIC 2
    SetEnv OMS_STRIPE_WEBHOOK 3
    SetEnv OMS_PRIVATE_KEY_I 4

    <Directory /var/www/html/jingga>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

a2ensite 001-saas.conf
a2ensite 000-saas.conf
service apache2 reload
service apache2 restart

snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
certbot --apache
certbot renew --dry-run

###############################################################
## Security
###############################################################

### Install borg

apt-get install borgbackup

borg init -v --encryption=repokey /var/www/html
borg key export /var/www/html repokey

###############################################################
## Content
###############################################################
