#!/bin/bash

hasPhpLogging() {
    RESULT=$(grep "var_dump(" "$1")
    if [ ! -z $RESULT ]; then
        return 1
    fi

    return 0;
}

hasJsLogging() {
    RESULT=$(grep "console.log(" "$1")
    if [ ! -z $RESULT ]; then
        return 1;
    fi

    return 0;
}