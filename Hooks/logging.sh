#!/bin/bash

hasPhpLogging() {
    RESULT=$(grep "var_dump(" "$1")
    if [ ! -z $RESULT ]; then
        echo 1
        return 1
    fi

    echo 0
    return 0
}

hasJsLogging() {
    RESULT=$(grep "console.log(" "$1")
    if [ ! -z $RESULT ]; then
        echo 1
        return 1
    fi

    echo 0
    return 0
}