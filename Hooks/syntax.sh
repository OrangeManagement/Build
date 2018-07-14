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
        php -d memory_limit=4G ${rootpath}/vendor/bin/phpcs --standard="${rootpath}/Build/Config/phpcs.xml" --encoding=utf-8 -n -p $FILE
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tCode Sniffer error.\e[0m" >&2
            exit 1
        fi

        # phpmd
        php -d memory_limit=4G ${rootpath}/vendor/bin/phpmd $FILE text ${rootpath}/Build/Config/phpmd.xml --exclude *tests* --minimumpriority 1
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tMess Detector error.\e[0m" >&2
            exit 1
        fi
    fi
fi

# Html/template checks
if [[ "$FILE" =~ ^.+(tpl\.php|html)$ ]]; then
    # Invalid and empty attributes
    if [[ -n $(grep -E '=\"[\#\$\%\^\&\*\(\)\\/\ ]*\"' $FILE) ]]; then
        echo -e "\e[1;31m\tFound invalid attribute.\e[0m" >&2
        grep -E '=\"[\#\$\%\^\&\*\(\)\\/\ ]*\"' $FILE >&2
        exit 1
    fi

    # Invalid class/id names
    if [[ -n $(grep -E '(id|class)=\"[a-zA-Z]*[\#\$\%\^\&\*\(\)\\/\ ]+[a-zA-Z]*\"' $FILE) ]]; then
        echo -e "\e[1;31m\tFound invalid class/id.\e[0m" >&2
        grep -E '(id|class)=\"[a-zA-Z]*[\#\$\%\^\&\*\(\)\\/\ ]+[a-zA-Z]*\"' $FILE >&2
        exit 1
    fi

    # Images must have a alt= attribute *error*
    if [[ -n $(grep -P '(\<img)((?!.*?alt=).)*(>)' $FILE) ]]; then
        echo -e "\e[1;31m\tFound missing image alt attribute.\e[0m" >&2
        grep -P '(\<img)((?!.*?alt=).)*(>)' $FILE >&2
        exit 1
    fi

    # Input elements must have a type= attribute *error*
    if [[ -n $(grep -P '(\<input)((?!.*?type=).)*(>)' $FILE) ]]; then
        echo -e "\e[1;31m\tFound missing input type attribute.\e[0m" >&2
        grep -P '(\<input)((?!.*?type=).)*(>)' $FILE >&2
        exit 1
    fi

    # Form fields must have a name *error*
    if [[ -n $(grep -P '(\<input|select|textarea)((?!.*?name=).)*(>)' $FILE) ]]; then
        echo -e "\e[1;31m\tFound missing form element name.\e[0m" >&2
        grep -P '(\<input|select|textarea)((?!.*?name=).)*(>)' $FILE >&2
        exit 1
    fi

    # Form must have a id, action and method *error*
    if [[ -n $(grep -P '(\<form)((?!.*?(action|method|id)=).)*(>)' $FILE) ]]; then
        echo -e "\e[1;31m\tFound missing form element action, method or id.\e[0m" >&2
        grep -P '(\<form)((?!.*?(action|method|id)=).)*(>)' $FILE >&2
        exit 1
    fi

    # Inline css is invalid *warning*
    if [[ -n $(grep -P '(style=)' $FILE) ]]; then
        echo -e "\e[1;31m\tFound missing form element action, method or id.\e[0m" >&2
        grep -P '(style=)' $FILE >&2
    fi

    # Attribute descriptions should not be hard coded *warning*
    if [[ -n $(grep -P '(value|title|alt|aria\-label)(=\")((?!\<\?).)*(>)' $FILE) ]]; then
        echo -e "\e[1;31m\tAttribute description should not be hard coded.\e[0m" >&2
        grep -P '(value|title|alt|aria\-label)(=\")((?!\<\?).)*(>)' $FILE >&2
    fi

    # Hard coded language *warning*
    if [[ -n $(grep -P '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+' $FILE) ]]; then
        echo -e "\e[1;31m\tFound hard coded text.\e[0m" >&2
        grep -P '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+' $FILE >&2
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

# text files in general
if [[ "$FILE" =~ ^.+(sh|js|php|json|css)$ ]]; then
    # Check whitespace end of line in code
    if [[ -n $(grep -P ' $' $FILE) ]]; then
        echo -e "\e[1;31m\tFound whitespace at end of line.\e[0m" >&2
        grep -P ' $' $FILE >&2
        exit 1
    fi

    # Check for tabs
    if [[ -n $(grep -P '\t' $FILE) ]]; then
        echo -e "\e[1;31m\tFound tab instead of whitespace.\e[0m" >&2
        grep -P '\t' $FILE >&2
        exit 1
    fi
fi

done || exit $?
