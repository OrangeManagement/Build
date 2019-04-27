#!/bin/bash

# create new user
adduser test
usermod -aG sudo test

# Debian
#wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
#echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list

apt-get update

apt-get install npm git php7.3 php7.3-cli php7.3-common php7.3-mysql php7.3-pgsql php7.3-xdebug php7.3-json php7.3-opcache php7.3-pdo php7.3-sqlite php7.3-mbstring php7.3-curl php7.3-imap php7.3-bcmath php7.3-zip php7.3-dom php7.3-xml php7.3-phar php7.3-gd php7.3-dev php-pear apache2 mysql-server postgresql postgresql-contrib

# USE mysql;
# mysql < 5.7
# UPDATE user SET plugin='mysql_native_password' WHERE User='root';
# UPDATE user SET password=PASSWORD("") WHERE User='root';
# FLUSH PRIVILEGES;
# exit;
# else mysql >= 5.7
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';

# /etc/postgresq/...
# change from md5 to trust

update-rc.d postgresql enable
service postgresql start

# Install sqlsrv
# https://docs.microsoft.com/en-us/sql/connect/php/installation-tutorial-linux-mac?view=sql-server-2017

a2enmod rewrite
a2enmod headers

pecl install ast

echo "extension=ast.so" | tee /etc/php/7.3/mods-available/ast.ini
phpenmod ast

# Install redis
sudo apt install redis-server
# /etc/redis/...conifg
# supervised systemd
# dir /var/lib/redis
systemctl restart redis

pecl install redis
echo "extension=redis.so" | tee /etc/php/7.3/mods-available/redis.ini
phpenmod redis

# Install memcached
apt-get install memcached libmemcached-dev libmemcached-tools
systemctl restart memcached
pecl install memcached
echo "extension=memcached.so" | tee /etc/php/7.3/mods-available/memcached.ini
phpenmod memcached

# Install email server for testing
apt-get install dovecot-imapd dovecot-pop3d
# protocls = pop3 pop3s imap imaps
# pop3_uidl_format = %08Xu%08Xv
/etc/init.d/dovecot start
sudo useradd -d /home/test -g mail -u 1001 -s /bin/bash test
# Make sure no ssh is possible for this user

# npm
npm install -D jasmine jasmine-node istanbul jasmine-console-reporter supertest jasmine-supertest

# FTP
apt-get install vsftpd

# /etc/vstftpd.conf
# write_enable=YES
# anon_upload_enable=YES
# connect_from_port_20=NO

systemctl restart apache2

php php-cs-fixer.phar fix phpOMS/ --rules='{"array_syntax": {"syntax": "short"}, "blank_line_after_namespace": true, "cast_spaces": {"space": "single"}, "combine_consecutive_issets": true, "compact_nullable_typehint": true, "declare_strict_types": true, "elseif": true, "encoding": true, "explicit_indirect_variable": true, "explicit_string_variable": true, "function_to_constant": true, "implode_call": true, "increment_style": {"style": "pre"}, "is_null": {"use_yoda_style": false}, "line_ending": true, "logical_operators": true, "lowercase_cast": true, "lowercase_constants": true, "lowercase_keywords": true, "modernize_types_casting": true, "native_constant_invocation": true, "native_function_casing": true, "native_function_invocation": true, "new_with_braces": true, "no_alias_functions": true, "no_closing_tag": true, "no_empty_comment": true, "no_empty_phpdoc": true, "no_empty_statement": true, "no_homoglyph_names": true, "no_mixed_echo_print": {"use": "echo"}, "no_php4_constructor": true, "no_singleline_whitespace_before_semicolons": true, "no_spaces_inside_parenthesis": true, "no_trailing_whitespace": true, "no_unneeded_final_method": true, "no_unused_imports": true, "no_useless_return": true, "no_whitespace_before_comma_in_array": true, "no_whitespace_in_blank_line": true, "non_printable_character": true, "ordered_imports": {"sort_algorithm": "alpha"}, "php_unit_construct": true, "php_unit_internal_class": true, "php_unit_ordered_covers": true, "php_unit_set_up_tear_down_visibility": true, "phpdoc_align": {"align": "vertical"}, "phpdoc_annotation_without_dot": true, "phpdoc_scalar": true, "phpdoc_trim_consecutive_blank_line_separation": true, "random_api_migration": true, "self_accessor": true, "set_type_to_cast": true, "short_scalar_cast": true, "single_blank_line_at_eof": true, "single_line_after_imports": true, "standardize_increment": true, "trailing_comma_in_multiline_array": true, "trim_array_spaces": true, "visibility_required": true, "void_return": true}' --allow-risky=yes

# consider:
# "mb_str_functions": true,
# "phpdoc_add_missing_param_annotation": true,