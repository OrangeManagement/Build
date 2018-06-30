#!/bin/bash

git diff --cached --name-only | while read FILE; do

if [[ "$FILE" =~ ^.+(php)$ ]]; then
    if [[ -f $FILE ]]; then
        # php lint
        php -l "$FILE" 1> /dev/null
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tPhp linting error.\e[0m" >&2
            exit 1
        fi
        
        # phpcs
        ${rootpath}/vendor/bin/phpcs --standard="${rootpath}/Build/Config/phpcs.xml" --encoding=utf-8 -n -p $FILE
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tCode Sniffer error.\e[0m" >&2
            exit 1
        fi
        
        # phpmd
        ${rootpath}/vendor/bin/phpmd $FILE text ${rootpath}/Build/Config/phpmd.xml --exclude *tests* --minimumpriority 1
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tMess Detector error.\e[0m" >&2
            exit 1
        fi
    fi
fi

if [[ "$FILE" =~ ^.+(sh)$ ]]; then
    if [[ -f $FILE ]]; then
        # sh lint
        bash -n "$FILE" 1> /dev/null
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tBash linting error.\e[0m" >&2
            exit 1
        fi
    fi
fi

done || exit $?
