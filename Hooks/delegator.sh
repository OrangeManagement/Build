#!/bin/bash

. ${rootpath}/Build/Hooks/logging.sh
. ${rootpath}/Build/Hooks/syntax.sh
. ${rootpath}/Build/Hooks/filename.sh
. ${rootpath}/Build/Hooks/tests.sh

git diff --cached --name-only | while read FILE; do
    if [[ ! -f "$FILE" ]]; then
        continue
    fi

    # Filename
    if [[ ! $(isValidFileName "$FILE") ]]; then
        echo -e "\e[1;31m\tInvalid file name.\e[0m" >&2
        exit 1
    fi

    # Logging
    if [[ "$FILE" =~ ^.+(php)$ ]] && [[ $(hasPhpLogging "$FILE") = 1 ]]; then
        echo -e "\e[1;33m\tWarning, the commit contains a call to var_dump() in '$FILE'. Commit was not aborted, however.\e[0m" >&2
    fi

    if [[ "$FILE" =~ ^.+(js)$ ]] && [[ $(hasJsLogging "$FILE") = 1 ]]; then
        echo -e "\e[1;33m\tWarning, the commit contains a call to console.log() in '$1'. Commit was not aborted, however.\e[0m" >&2
    fi

    # Tests
    if [[ "$FILE" =~ ^.+(php)$ ]] && [[ ! $(isPhanTestSuccessfull "$FILE") ]]; then
        echo -e "\e[1;31m\tPhan error.\e[0m" >&2
        exit 1
    fi

    if [[ "$FILE" =~ ^.+(php)$ ]] && [[ ! $(isPhpStanTestSuccessfull "$FILE") ]]; then
        echo -e "\e[1;31m\tPhp stan error.\e[0m" >&2
        exit 1
    fi

    # Syntax
    if [[ "$FILE" =~ ^.+(php)$ ]]; then
        PHP_SYNTAX = $(hasInvalidPhpSyntax "$FILE")

        if [[ $PHP_SYNTAX = 1 ]]; then
            echo -e "\e[1;31m\tPhp linting error.\e[0m" >&2
            exit 1
        fi

        if [[ $PHP_SYNTAX = 2 ]]; then
            echo -e "\e[1;31m\tCode Sniffer error.\e[0m" >&2
            exit 1
        fi

        if [[ $PHP_SYNTAX = 3 ]]; then
            echo -e "\e[1;31m\tMess Detector error.\e[0m" >&2
            exit 1
        fi
    fi

    if [[ "$FILE" =~ ^.+(sh)$ ]] && [[ ! $(isValidBashScript "$FILE") ]]; then
        echo -e "\e[1;31m\tBash linting error.\e[0m" >&2
        exit 1
    fi

    if [[ "$FILE" =~ ^.+(sh|js|php|json|css)$ ]]; then
        GEN_SYNTAX = $(hasInvalidBasicSyntax "$FILE")

        if [[ $GEN_SYNTAX = 1 ]]; then
            echo -e "\e[1;31m\tFound whitespace at end of line in $1.\e[0m" >&2
            grep -P ' $' $1 >&2
            exit 1
        fi

        if [[ $GEN_SYNTAX = 2 ]]; then
            echo -e "\e[1;31m\tFound tab instead of whitespace $1.\e[0m" >&2
            grep -P '\t' $1 >&2
            exit 1
        fi
    fi

    if [[ "$FILE" =~ ^.+(tpl\.php|html)$ ]]; then
        TPL_SYNTAX = $(hasInvalidHtmlTemplateContent "$FILE")

        if [[ $TPL_SYNTAX = 1 ]]; then
            echo -e "\e[1;31m\tFound missing image alt attribute.\e[0m" >&2
            grep -P '(\<img)((?!.*?alt=).)*(>)' "$FILE" >&2
            exit 1
        fi

        if [[ $TPL_SYNTAX = 2 ]]; then
            echo -e "\e[1;31m\tFound missing input type attribute.\e[0m" >&2
            grep -P '(<input)((?!.*?type=).)*(>)' "$FILE" >&2
            exit 1
        fi

        if [[ $TPL_SYNTAX = 3 ]]; then
            echo -e "\e[1;31m\tFound missing form element name.\e[0m" >&2
            grep -P '(<input|<select|<textarea)((?!.*?name=).)*(>)' "$FILE" >&2
            exit 1
        fi

        if [[ $TPL_SYNTAX = 4 ]]; then
            echo -e "\e[1;31m\tFound missing form element action, method or id.\e[0m" >&2
            grep -P '(\<form)((?!.*?(action|method|id)=).)*(>)' "$FILE" >&2
            exit 1
        fi

        if [[ $TPL_SYNTAX = 5 ]]; then
            echo -e "\e[1;31m\tFound inline styles.\e[0m" >&2
            grep -P '(style=)' "$FILE" >&2
        fi

        if [[ $TPL_SYNTAX = 6 ]]; then
            echo -e "\e[1;31m\tAttribute description should not be hard coded.\e[0m" >&2
            grep -P '(value|title|alt|aria\-label)(=\")((?!\<\?).)*(>)' "$FILE" >&2
        fi

        if [[ $TPL_SYNTAX = 7 ]]; then
            echo -e "\e[1;31m\tFound hard coded text.\e[0m" >&2
            grep -P '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+' "$FILE" >&2
        fi
    fi
done

exit 0