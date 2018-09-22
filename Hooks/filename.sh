#!/bin/bash

isValidFileName() {
    if test $(git diff --cached --name-only --diff-filter=A -z "$1" |
            LC_ALL=C tr -d '[ -~]\0' | wc -c) != 0
    then
        echo 0
        return 0
    fi

    echo 1
    return 1
}