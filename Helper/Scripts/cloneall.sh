#!/bin/bash

CNTX="users"; NAME="Karaka-Management"; PAGE=1
curl "https://api.github.com/$CNTX/$NAME/repos?page=$PAGE&per_page=100" |
  grep -e 'clone_url*' |
  cut -d \" -f 4 |
  xargs -L1 git clone

find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && git checkout develop" \;
find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && git submodule foreach 'git checkout develop || true'" \;
find ./src -maxdepth 1 -type d \( ! -name . \) -exec bash -c "git -C '{}' pull" \;
find ./src -maxdepth 1 -type d \( ! -name . \) -exec bash -c "Build/php.sh '{}' '{}/build'" \;