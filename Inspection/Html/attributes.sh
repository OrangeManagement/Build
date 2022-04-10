#!/bin/bash

. config.sh

echo "#################################################"
echo "Start html inspection"
echo "#################################################"

# Find invalid html
find {ROOT_PATH}/Web {ROOT_PATH}/phpOMS {ROOT_PATH}/Build {ROOT_PATH}/Modules -name "*tpl.php" | xargs grep -E '=\"[\#\$\%\^\&\*\(\)\\/\ ]*\"' > ${INSPECTION_PATH}/Modules/html/invalid_html.log
find {ROOT_PATH}/Web {ROOT_PATH}/phpOMS {ROOT_PATH}/Build {ROOT_PATH}/Modules -name "*tpl.php" | xargs grep -P '(\<img)((?!.*?alt=).)*(>)' >> ${INSPECTION_PATH}/Modules/html/invalid_html.log
find {ROOT_PATH}/Web {ROOT_PATH}/phpOMS {ROOT_PATH}/Build {ROOT_PATH}/Modules -name "*tpl.php" | xargs grep -P '(<input)((?!.*?type=).)*(>)' >> ${INSPECTION_PATH}/Modules/html/invalid_html.log
find {ROOT_PATH}/Web {ROOT_PATH}/phpOMS {ROOT_PATH}/Build {ROOT_PATH}/Modules -name "*tpl.php" | xargs grep -P '(<input|<select|<textarea)((?!.*?name=).)*(>)' >> ${INSPECTION_PATH}/Modules/html/invalid_html.log
find {ROOT_PATH}/Web {ROOT_PATH}/phpOMS {ROOT_PATH}/Build {ROOT_PATH}/Modules -name "*tpl.php" | xargs grep -P '(style=)' >> ${INSPECTION_PATH}/Modules/html/invalid_html.log
find {ROOT_PATH}/Web {ROOT_PATH}/phpOMS {ROOT_PATH}/Build {ROOT_PATH}/Modules -name "*tpl.php" | xargs grep -P '(value|title|alt|aria\-label)(=\")((?!\<\?).)*(>)' >> ${INSPECTION_PATH}/Modules/html/invalid_html.log
find {ROOT_PATH}/Web {ROOT_PATH}/phpOMS {ROOT_PATH}/Build {ROOT_PATH}/Modules -name "*tpl.php" | xargs grep -P '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+)' >> ${INSPECTION_PATH}/Modules/html/invalid_html.log