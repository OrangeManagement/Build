#!/bin/bash

git diff --cached --name-only | while read FILE; do
if [[ ! -f "$FILE" ]]; then
    exit 0
fi
done

. ${rootpath}/Build/Hooks/logging.sh
. ${rootpath}/Build/Hooks/syntax.sh
. ${rootpath}/Build/Hooks/filename.sh
. ${rootpath}/Build/Hooks/tests.sh