#!/bin/bash

hasInvalidPhpSyntax() {
    # php lint
    php -l "$1"
    if [ $? -ne 0 ]; then
        return 1
    fi

    # phpcs
    php -d memory_limit=4G ${rootpath}/vendor/bin/phpcs --standard="${rootpath}/Build/Config/phpcs.xml" --encoding=utf-8 -n -p "$1"
    if [ $? -ne 0 ]; then
        return 2
    fi

    # phpmd
    php -d memory_limit=4G ${rootpath}/vendor/bin/phpmd "$1" text ${rootpath}/Build/Config/phpmd.xml --exclude *tests* --minimumpriority 1
    if [ $? -ne 0 ]; then
        return 3
    fi

    return 0;
}

hasInvalidHtmlTemplateContent() {
    # Images must have a alt= attribute *error*
    if [[ -n $(grep -P '(\<img)((?!.*?alt=).)*(>)' "$1") ]]; then
        return 1
    fi

    # Input elements must have a type= attribute *error*
    if [[ -n $(grep -P '(<input)((?!.*?type=).)*(>)' "$1") ]]; then
        return 2
    fi

    # Form fields must have a name *error*
    if [[ -n $(grep -P '(<input|<select|<textarea)((?!.*?name=).)*(>)' "$1") ]]; then
        return 3
    fi

    # Form must have a id, action and method *error*
    if [[ -n $(grep -P '(\<form)((?!.*?(action|method|id)=).)*(>)' "$1") ]]; then
        return 4
    fi

    # Inline css is invalid *warning*
    if [[ -n $(grep -P '(style=)' "$1") ]]; then
        return 5
    fi

    # Attribute descriptions should not be hard coded *warning*
    if [[ -n $(grep -P '(value|title|alt|aria\-label)(=\")((?!\<\?).)*(>)' "$1") ]]; then
        return 6
    fi

    # Hard coded language *warning*
    if [[ -n $(grep -P '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+' "$1") ]]; then
        return 7
    fi

    return 0
}

isValidBashScript() {
    bash -n "$1" 1> /dev/null
    if [ $? -ne 0 ]; then
        return 0
    fi

    return 1
}

hasInvalidBasicSyntax() {


    # Check for tabs
    if [[ -n $(grep -P '\t' "$1") ]]; then
        return 2
    fi

    return 0
}