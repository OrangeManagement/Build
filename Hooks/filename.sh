#!/bin/bash

isValidFileName() {
    if test $(git diff --cached --name-only --diff-filter=A-z "$1" |
            LC_ALL=C tr -d '[ -~]\0' | wc -c) != 0
    then
        return 0
    fi

    return 1
} 