#!/bin/bash

hasInvalidPhpSyntax() {
    # php lint
    $(php -l "$1" > /dev/null)
    if [[ $? != 0 ]]; then
        echo 1
        return 1
    fi

    # phpcs
    $(php -d memory_limit=4G ${rootpath}/vendor/bin/phpcs --standard="${rootpath}/Build/Config/phpcs.xml" --encoding=utf-8 -n -p "$1" > /dev/null)
    if [[ $? != 0 ]]; then
        echo 2
        return 2
    fi

    echo 0
    return 0
}

hasInvalidJsSyntax() {
    # eslint
    $(npx eslint "$1" -c ${rootpath}/Build/Config/.eslintrc.json > /dev/null)
    if [[ $? != 0 ]]; then
        echo 1
        return 1
    fi

    echo 0
    return 0
}

hasInvalidHtmlTemplateContent() {
    # Images must have a alt= attribute *error*
    if [[ -n $(grep -P '(\<img)((?!.*?alt=).)*(>)' "$1") ]]; then
        echo 1
        return 1
    fi

    # Input elements must have a type= attribute *error*
    if [[ -n $(grep -P '(<input)((?!.*?type=).)*(>)' "$1") ]]; then
        echo 2
        return 2
    fi

    # Form fields must have a name *error*
    if [[ -n $(grep -P '(<input|<select|<textarea)((?!.*?name=).)*(>)' "$1") ]]; then
        echo 3
        return 3
    fi

    # Form must have a id, action and method *error*
    if [[ -n $(grep -P '(\<form)((?!.*?(name|id)=).)*(>)' "$1") ]]; then
        echo 4
        return 4
    fi

    # Inline css is invalid *warning*
    if [[ -n $(grep -P '(style=)' "$1") ]]; then
        echo 5
        return 5
    fi

    # Attribute descriptions should not be hard coded *warning*
    if [[ -n $(grep -P '(value|title|alt|aria\-label)(=\")((?!\<\?).)*(>)' "$1") ]]; then
        echo 6
        return 6
    fi

    # Hard coded language *warning*
    if [[ -n $(grep -P '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+' "$1") ]]; then
        echo 7
        return 7
    fi

    echo 0
    return 0
}

isValidBashScript() {
    bash -n "$1" 1> /dev/null
    if [ $? -ne 0 ]; then
        echo 0
        return 0
    fi

    echo 1
    return 1
}

hasInvalidBasicSyntax() {
    # Check whitespace end of line in code
    if [[ -n $(grep -P ' $' "$1") ]]; then
        echo 1
        return 1
    fi

    # Check for tabs
    if [[ -n $(grep -P '\t' "$1") ]]; then
        echo 2
        return 2
    fi

    echo 0
    return 0
}