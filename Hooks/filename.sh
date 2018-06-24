#!/bin/bash

allownonascii="false"

git diff --cached --name-only | while read FILE; do

if [ "$allownonascii" != "true" ] &&
	test $(git diff --cached --name-only --diff-filter=A -z $FILE |
	    LC_ALL=C tr -d '[ -~]\0' | wc -c) != 0
then
    echo -e "\e[1;31m\tInvalid file name.\e[0m" >&2
    exit 1
fi

done || exit $?