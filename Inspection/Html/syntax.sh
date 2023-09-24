#!/bin/bash

. config.sh

echo "#################################################"
echo "Start html syntax inspection"
echo "#################################################"

#
echo "Image alt missing:" > ${INSPECTION_PATH}/Modules/html_syntax.log
grep -rlnP '(\<img)((?!.*?alt=).)*(>)' --include \*.tpl.php Modules >> ${INSPECTION_PATH}/Modules/html_syntax.log

echo "Input type missing:" >> ${INSPECTION_PATH}/Modules/html_syntax.log
grep -rlnP '(<input)((?!.*?type=).)*(>)' --include \*.tpl.php Modules >> ${INSPECTION_PATH}/Modules/html_syntax.log

echo "Input name missing:" >> ${INSPECTION_PATH}/Modules/html_syntax.log
grep -rlnP '(<input|<select|<textarea)((?!.*?name=).)*(>)' --include \*.tpl.php Modules >> ${INSPECTION_PATH}/Modules/html_syntax.log

echo "Form id missing:" >> ${INSPECTION_PATH}/Modules/html_syntax.log
grep -rlnP '(\<form)((?!.*?(name|id)=).)*(>)' --include \*.tpl.php Modules >> ${INSPECTION_PATH}/Modules/html_syntax.log

#
echo "Image alt missing:" > ${INSPECTION_PATH}/Web/html_syntax.log
grep -rlnP '(\<img)((?!.*?alt=).)*(>)' --include \*.tpl.php Web >> ${INSPECTION_PATH}/Web/html_syntax.log

echo "Input type missing:" >> ${INSPECTION_PATH}/Web/html_syntax.log
grep -rlnP '(<input)((?!.*?type=).)*(>)' --include \*.tpl.php Web >> ${INSPECTION_PATH}/Web/html_syntax.log

echo "Input name missing:" >> ${INSPECTION_PATH}/Web/html_syntax.log
grep -rlnP '(<input|<select|<textarea)((?!.*?name=).)*(>)' --include \*.tpl.php Web >> ${INSPECTION_PATH}/Web/html_syntax.log

echo "Form id missing:" >> ${INSPECTION_PATH}/Web/html_syntax.log
grep -rlnP '(\<form)((?!.*?(name|id)=).)*(>)' --include \*.tpl.php Web >> ${INSPECTION_PATH}/Web/html_syntax.log