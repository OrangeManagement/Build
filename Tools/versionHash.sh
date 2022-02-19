#!/bin/bash

find ./phpOMS -type f -name "*.php" -exec md5sum {} \; > hashs.txt
find ./cssOMS -type f -name "*.css" -exec md5sum {} \; >> hashs.txt
find ./cssOMS -type f -name "*.scss" -exec md5sum {} \; >> hashs.txt
find ./jsOMS -type f -name "*.js" -exec md5sum {} \; >> hashs.txt
find ./Modules -type f -name "*.php" -exec md5sum {} \; >> hashs.txt
find ./Modules -type f -name "*.js" -exec md5sum {} \; >> hashs.txt
find ./Model -type f -name "*.php" -exec md5sum {} \; >> hashs.txt
find ./Model -type f -name "*.js" -exec md5sum {} \; >> hashs.txt
find ./Web -type f -name "*.php" -exec md5sum {} \; >> hashs.txt
find ./Web -type f -name "*.js" -exec md5sum {} \; >> hashs.txt
find ./Developer-Guide -type f -name "*.md" -exec md5sum {} \; >> hashs.txt
find ./Documentation -type f -name "*.md" -exec md5sum {} \; >> hashs.txt
