#!/bin/bash

###############################################################
## General
###############################################################

# For every user .bash_profile/.bashrc

export PROMPT_COMMAND='echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> /var/www/html/backup/bash/$(date "+%d").log'

apt-get update
apt-get upgrade
apt-get install git snapd ufw software-properties-common composer nodejs npm

# Security

apt-get install ufw
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

apt-get install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
service fail2ban restart

# SSH

# upload ssh key and disable password login if successful
# https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04

# copy the public key (e.g. *.pub to the file ~/.ssh/authorized_keys of the respective user)
# change /etc/ssh/sshd_config PasswordAuthentication no
# systemctl restart ssh

###############################################################
## Web
###############################################################

apt-get install php8.1 php8.1-dev php8.1-cli php8.1-common php8.1-mysql php8.1-pgsql php8.1-xdebug php8.1-opcache php8.1-pdo php8.1-sqlite php8.1-mbstring php8.1-curl php8.1-imap php8.1-bcmath php8.1-zip php8.1-dom php8.1-xml php8.1-phar php8.1-gd php-pear apache2 libapache2-mpm-itk apache2-utils mariadb-server mariadb-client wkhtmltopdf tesseract-ocr poppler-utils

pecl install pcov
#echo "extension=pcov.so" > /etc/php/cli/conf.d/20-xdebug.ini

mkdir -p /var/cache/apache2
mkdir -p /var/cache/apache2/tmrank
chown -R www-data:www-data /var/cache/apache2

systemctl enable apache2
a2enmod rewrite
a2enmod expires
a2enmod headers
a2enmod cache
a2enmod cache_disk
a2enmod mpm_itk
systemctl restart apache2
systemctl start apache-htcacheclean

# Database

mysql_secure_installation
systemctl start mariadb
systemctl enable mariadb

mysql -u root -p

CREATE USER 'jingga'@'%' IDENTIFIED BY 'dYg8#@wLiWJ3vE';
CREATE USER 'demo'@'%' IDENTIFIED BY 'orange';
CREATE USER 'test'@'%' IDENTIFIED BY 'orange';

CREATE DATABASE jingga';
CREATE DATABASE demo';
CREATE DATABASE omt';

GRANT ALL PRIVILEGES ON jingga.* TO 'jingga'@'%';
GRANT ALL PRIVILEGES ON demo.* TO 'demo'@'%';
GRANT ALL PRIVILEGES ON omt.* TO 'test'@'%';

FLUSH PRIVILEGES;

# Apache2

# Remove %h in apache2.conf (this logs the ip addresses)

cat << EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName jingga.app
    ServerAlias www.jingga.app
    ServerAlias api.jingga.app

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

cat << EOF > /etc/apache2/sites-available/000-shop.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName jingga.shop
    ServerAlias www.jingga.shop
    ServerAlias shop.jingga.app

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

cat << EOF > /etc/apache2/sites-available/000-demo.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga_demo
    ServerName demo.jingga.app

    SetEnv OMS_STRIPE_SECRET 1
    SetEnv OMS_STRIPE_PUBLIC 2
    SetEnv OMS_STRIPE_WEBHOOK 3
    SetEnv OMS_PRIVATE_KEY_I 4

    <Directory /var/www/html/jingga_demo>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <IfModule mpm_itk_module>
        AssignUserId www-demo www-data
    </IfModule>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

cat << EOF > /etc/apache2/sites-available/000-dev.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/dev
    ServerName dev.jingga.app

    <Directory /var/www/html/dev>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

cat << EOF > /etc/apache2/sites-available/000-services.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName jingga.services
    ServerAlias www.jingga.services
    ServerAlias services.jingga.app

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

cat << EOF > /etc/apache2/sites-available/000-software.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName jingga.software
    ServerAlias www.jingga.software

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

cat << EOF > /etc/apache2/sites-available/000-systems.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName jingga.systems
    ServerAlias www.jingga.systems

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

cat << EOF > /etc/apache2/sites-available/000-solutions.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName jingga.solutions
    ServerAlias www.jingga.solutions

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

cat << EOF > /etc/apache2/sites-available/001-orw.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName orw.jingga.app

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
    ServerName jingga.watch
    ServerAlias www.jingga.watch

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

cat << EOF > /etc/apache2/sites-available/001-invoicing.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName invoicing.jingga.app

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
    ServerName jingga.sale
    ServerAlias www.jingga.sale

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

cat << EOF > /etc/apache2/sites-available/001-fleet.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName fleetmanagement.jingga.app

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
    ServerName jingga.autos
    ServerAlias www.jingga.autos

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

cat << EOF > /etc/apache2/sites-available/001-contract.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName contractmanagement.jingga.app

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
    ServerName jingga.media
    ServerAlias www.jingga.media

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

cat << EOF > /etc/apache2/sites-available/001-support.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName support.jingga.app

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
    ServerName jingga.support
    ServerAlias www.jingga.support

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

cat << EOF > /etc/apache2/sites-available/001-wiki.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/jingga
    ServerName wiki.jingga.app

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
    ServerName jingga.wiki
    ServerAlias www.jingga.wiki

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

cat << EOF > /etc/apache2/sites-available/002-gaming.conf
<VirtualHost *:80>
    ServerAdmin info@jingga.app
    DocumentRoot /var/www/html/tmrank
    ServerName tmrank.jingga.app

    <Directory /var/www/html/tmrank>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Important to have separate crontabs between production and demo apps
useradd www-demo
usermod -a -G www-data www-demo
usermod -d /var/demo www-demo
mkdir -p /var/demo
chown www-demo:www-data /var/demo

sudo -u www-data mkdir /var/www/html/jingga
sudo -u www-demo mkdir /var/www/html/jingga_demo
sudo -u www-data mkdir /var/www/html/tmrank
chown -R www-data:www-data /var/www

mkdir -p /var/www/html/backup/bash

chmod -R 766 /var/www/html/backup

a2ensite 000-demo.conf
a2ensite 000-dev.conf
a2ensite 000-shop.conf
a2ensite 000-services.conf
a2ensite 000-software.conf
a2ensite 000-systems.conf
a2ensite 000-solutions.conf

a2ensite 001-orw.conf
a2ensite 001-invoicing.conf
a2ensite 001-fleet.conf
a2ensite 001-contract.conf
a2ensite 001-support.conf
a2ensite 001-wiki.conf

a2ensite 002-gaming.conf

systemctl reload apache2
systemctl restart apache2

snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
certbot --apache
certbot renew --dry-run

###############################################################
## Security
###############################################################

### Install borg

apt-get install borgbackup

mkdir /backup
borg init -v --encryption=repokey /backup
borg key export /backup repokey

###############################################################
## vscode
###############################################################

apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

apt install apt-transport-https
apt update
apt install code

###############################################################
## Content
###############################################################

cd /var/www/html/jingga
sudo -u www-data git clone --recurse-submodules https://github.com/Karaka-Management/Karaka.git .
sudo -u www-data git clone --recurse-submodules https://github.com/Karaka-Management/privateSetup.git

sudo -u www-data git submodule foreach "git checkout develop || true"

cd /var/www/html/jingga_demo
sudo -u www-data git clone --recurse-submodules https://github.com/Karaka-Management/Karaka.git .
sudo -u www-data git clone --recurse-submodules https://github.com/Karaka-Management/demoSetup.git

sudo -u www-data git submodule foreach "git checkout develop || true"
chown -R www-data /var/www

# crontab www-data
# * 2 * * * git -C /var/www/html/jingga_demo submodule foreach git pull; git -C /var/www/html/jingga_demo/setupDemo git pull; /var/www/html/jingga_demo/setupDemo/setup.php; pkill -9 -f wkhtmltoimage;
# 0 1 * * * /var/www/html/tmrank/scripts/run.sh > /var/www/html/tmrank/test.log

# crontab root
# 0 0 1 * * certbot renew --quiet