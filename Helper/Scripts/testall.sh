#!/bin/bash

CNTX="users"; NAME="Karaka-Management"; PAGE=1
curl "https://api.github.com/$CNTX/$NAME/repos?page=$PAGE&per_page=100" |
  grep -e 'clone_url*' |
  cut -d \" -f 4 |
  xargs -L1 git clone