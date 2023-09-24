#!/bin/bash

. config.sh

echo "#################################################"
echo "Start static text inspection"
echo "#################################################"

grep -rlnP '(title|alt|aria\-label)(=\")((?!\<\?).)*(>)' --include \*.tpl.php Modules >> ${INSPECTION_PATH}/Modules/static_text.log
grep -rlnP '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+' --include \*.tpl.php Modules >> ${INSPECTION_PATH}/Modules/static_text.log
