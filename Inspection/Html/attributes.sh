#!/bin/bash

. ../../config.sh

echo "Start html attributes inspection\n"

# Find empty attributes
grep -rln "=\"\"" --include \*.tpl.php ${ROOT_PATH} > ${INSPECTION_PATH}/Modules/html/attributes_empty.log

# Find invalid attributes
find ${ROOT_PATH} -name "*tpl.php" | xargs grep '(id=")([\ ]*)(")' > ${INSPECTION_PATH}/Modules/html/attributes_invalid.log
find ${ROOT_PATH} -name "*tpl.php" | xargs grep '(min=")([a-zA-Z]*)(")' >> ${INSPECTION_PATH}/Modules/html/attributes_invalid.log
find ${ROOT_PATH} -name "*tpl.php" | xargs grep '(max=")([a-zA-Z]*)(")' >> ${INSPECTION_PATH}/Modules/html/attributes_invalid.log
find ${ROOT_PATH} -name "*tpl.php" | xargs grep '(=")([#$%^&*\(\)\\/]*)(")' >> ${INSPECTION_PATH}/Modules/html/attributes_invalid.log
find ${ROOT_PATH} -name "*tpl.php" | xargs grep '(<img(?!.*?alt=(["]).*?\2)[^>]*?)(/?>)' >> ${INSPECTION_PATH}/Modules/html/attributes_invalid.log
