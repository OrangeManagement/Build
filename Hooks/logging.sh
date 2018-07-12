#!/bin/bash

git diff --cached --name-only | while read FILE; do
if [[ "$FILE" =~ ^.+(php)$ ]]; then
    RESULT=$(grep "var_dump(" "$FILE")
    if [ ! -z $RESULT ]; then
      echo -e "\e[1;33m\tWarning, the commit contains a call to var_dump() in '$FILE'. Commit was not aborted, however.\e[0m" >&2
    fi
fi
done

git diff --cached --name-only | while read FILE; do
if [[ "$FILE" =~ ^.+(js)$ ]]; then
    RESULT=$(grep "console.log(" "$FILE")
    if [ ! -z $RESULT ]; then
      echo -e "\e[1;33m\tWarning, the commit contains a call to console.log() in '$FILE'. Commit was not aborted, however.\e[0m" >&2
    fi
fi

done || exit $?