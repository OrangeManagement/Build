#!/bin/bash

. "$BUILD_PATH/config.sh"

echo "#################################################"
echo "Start html syntax inspection"
echo "#################################################"

#
echo "Image alt missing:" > ${OUTPUT_PATH}/html_syntax.log
grep -rlnP '(\<img)((?!.*?alt=).)*(>)' --include \*.tpl.php ${INSPECTION_PATH} >> ${OUTPUT_PATH}/html_syntax.log

echo "Input type missing:" >> ${OUTPUT_PATH}/html_syntax.log
grep -rlnP '(<input)((?!.*?type=).)*(>)' --include \*.tpl.php ${INSPECTION_PATH} >> ${OUTPUT_PATH}/html_syntax.log

echo "Input name missing:" >> ${OUTPUT_PATH}/html_syntax.log
grep -rlnP '(<input|<select|<textarea)((?!.*?name=).)*(>)' --include \*.tpl.php ${INSPECTION_PATH} >> ${OUTPUT_PATH}/html_syntax.log

echo "Form id missing:" >> ${OUTPUT_PATH}/html_syntax.log
grep -rlnP '(\<form)((?!.*?(name|id)=).)*(>)' --include \*.tpl.php ${INSPECTION_PATH} >> ${OUTPUT_PATH}/html_syntax.log