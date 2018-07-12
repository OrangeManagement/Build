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

# Html checks
if [[ "$FILE" =~ ^.+(tpl\.php|html)$ ]]; then
    if [[ -n $(grep -E '=\"[\#\$\%\^\&\*\(\)\\/\ ]+\"' $FILE) ]]; then
        echo -e "\e[1;31m\tFound invalid attribute.\e[0m" >&2
        exit 1
    fi

    if [[ -n $(grep -E '(id|class)=\"[a-zA-Z]*[\#\$\%\^\&\*\(\)\\/\ ]+[a-zA-Z]*\"' $FILE) ]]; then
        echo -e "\e[1;31m\tFound invalid class/id.\e[0m" >&2
        exit 1
    fi

    if [[ -n $(grep -P '(\<img)((?!.*?alt=).)*(>)' $FILE) ]]; then
        echo -e "\e[1;31m\tFound missing image alt attribute.\e[0m" >&2
        exit 1
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

# Check whitespace end of line in code
if [[ "$FILE" =~ ^.+(sh|js|php)$ ]]; then
    if [[ -n $(find $FILE -type f -exec egrep -l " +$" {} \;) ]]; then
        echo -e "\e[1;31m\tFound whitespace at end of line.\e[0m" >&2
        exit 1
    fi
fi

done || exit $?
