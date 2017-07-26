#!/bin/bash

# JS files
LIB_SRC[0]="/var/www/html/Orange-Management/jsOMS/Uri/Http.js"
LIB_SRC[1]="/var/www/html/Orange-Management/jsOMS/Uri/UriFactory.js"

# JS files
LIB_OUT="/home/pi/output.js"

echo "" > ${LIB_OUT}
for i in "${LIB_SRC[@]}"
do
    cat $i >> ${LIB_OUT}
    echo "" >> ${LIB_OUT}
done

# Remove spaces at end of line
sed -i -e 's/[[:blank:]]*$//g' ${LIB_OUT}
# Make single line
sed -i -e ':a;N;$!ba;s/\n/ /g' ${LIB_OUT}
# Remove multiple spaces
sed -i -e 's/  */ /g' ${LIB_OUT}
# Remove double js initialization
sed -i -e 's/(function *(jsOMS) *{ *"use strict";//g' ${LIB_OUT}
sed -i -e 's/} *(window.jsOMS = window.jsOMS || {}));//g' ${LIB_OUT}

echo "(function(jsOMS){\"use strict\";$(cat ${LIB_OUT})}(window.jsOMS = window.jsOMS || {}));" > ${LIB_OUT}