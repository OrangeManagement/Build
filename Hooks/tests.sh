#!/bin/bash

git diff --cached --name-only | while read FILE; do

if [[ "$FILE" =~ ^.+(php)$ ]]; then
    if [[ -f $FILE ]]; then
        # phan
        ${rootpath}/vendor/bin/phan -k ${rootpath}/Build/Config/phan.php -f $FILE
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tPhan warning.\e[0m" >&2
        fi

        # phpstan
        php -d memory_limit=4G ${rootpath}/vendor/bin/phpstan analyse --autoload-file=${rootpath}/phpOMS/Autoloader.php -l 7 -c ${rootpath}/Build/Config/phpstan.neon $FILE
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tPhp stan warning.\e[0m" >&2
        fi
    fi
fi

done || exit $?
