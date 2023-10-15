#!/bin/bash

. "${BUILD_PATH}/config.sh"

echo "#################################################"
echo "Start static text inspection"
echo "#################################################"

grep -rlnP '(title|alt|aria\-label)(=\")((?!\<\?).)*(>)' --include \*.tpl.php ${INSPECTION_PATH} >> ${OUTPUT_PATH}/static_text.log
grep -rlnP '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+' --include \*.tpl.php ${INSPECTION_PATH} >> ${OUTPUT_PATH}/static_text.log
