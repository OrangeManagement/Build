#!/bin/bash

. config.sh

echo "#################################################"
echo "Start html attributes inspection"
echo "#################################################"

# Find invalid attributes
find ${ROOT_PATH} -name "*tpl.php" | xargs grep -E '=\"[\#\$\%\^\&\*\(\)\\/\ ]*\"' > ${INSPECTION_PATH}/Modules/html/attributes_invalid.log
find ${ROOT_PATH} -name "*tpl.php" | xargs grep -E '(id|class)=\"[a-zA-Z]*[\#\$\%\^\&\*\(\)\\/\ ]+[a-zA-Z]*\"' >> ${INSPECTION_PATH}/Modules/html/attributes_invalid.log
find ${ROOT_PATH} -name "*tpl.php" | xargs grep -P '(\<img)((?!.*?alt=).)*(>)' >> ${INSPECTION_PATH}/Modules/html/attributes_invalid.log
