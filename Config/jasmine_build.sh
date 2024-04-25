#!/bin/bash

SEARCH_DIR=$1

FILES=$(find $SEARCH_DIR -type f -name "*Test.js")

for FILE in $FILES; do
    INPUT_PATH="$FILE"

    OUT_PATH="${INPUT_PATH/Test.js/Spec.js}"

    npx esbuild $INPUT_PATH --bundle --outfile=$OUT_PATH
done
