#!/bin/bash

# Include
. var.sh
. ${ROOT_PATH}/private.sh
. ${ROOT_PATH}/${BUILD_PATH}/setup.sh

# Executing unit tests
php ${ROOT_PATH}/phpunit.phar --configuration ${ROOT_PATH}/${TEST_PATH}/PHPUnit/phpunit_default.xml > ${ROOT_PATH}/${BUILD_PATH}/logs/phpunit.log

# Stats & metrics
php ${ROOT_PATH}/phploc.phar ${ROOT_PATH}/phpOMS/ > ${ROOT_PATH}/${BUILD_PATH}/stats/phpOMS.log
php ${ROOT_PATH}/phploc.phar ${ROOT_PATH}/Modules/ > ${ROOT_PATH}/${BUILD_PATH}/stats/ModulesStats.log

php ${ROOT_PATH}/phpmetrics.phar --report-html=${ROOT_PATH}/${BUILD_PATH}/stats/ReportFramework.html ${ROOT_PATH}/phpOMS/ >> ${ROOT_PATH}/${BUILD_PATH}/logs/build.log
php ${ROOT_PATH}/phpmetrics.phar --report-html=${ROOT_PATH}/${BUILD_PATH}/stats/ReportModules.html ${ROOT_PATH}/Modules/ >> ${ROOT_PATH}/${BUILD_PATH}/logs/build.log

php ${ROOT_PATH}/pdepend.phar --summary-xml=${ROOT_PATH}/${BUILD_PATH}/stats/phpOMSSummary.xml --jdepend-chart=${ROOT_PATH}/${BUILD_PATH}/stats/phpOMSDepend.svg --overview-pyramid=${ROOT_PATH}/${BUILD_PATH}/stats/phpOMSPryramid.svg ${ROOT_PATH}/phpOMS
php ${ROOT_PATH}/pdepend.phar --summary-xml=${ROOT_PATH}/${BUILD_PATH}/stats/modulesSummary.xml --jdepend-chart=${ROOT_PATH}/${BUILD_PATH}/stats/modulesDepend.svg --overview-pyramid=${ROOT_PATH}/${BUILD_PATH}/stats/modulesPyramid.svg ${ROOT_PATH}/Modules

# Documentation
php ${ROOT_PATH}/phpDocumentor.phar -d ${ROOT_PATH} --ignore "*/phpOMS/Localization/*" -t ${ROOT_PATH}/${BUILD_PATH}/docs

# Local inspection
php phpcs.phar --report-file=${ROOT_PATH}/${BUILD_PATH}/logs/phpcsFramework.log --ignore=${ROOT_PATH}/phpOMS/Localization --standard=${ROOT_PATH}/${BUILD_PATH}/phpcs.xml ${ROOT_PATH}/phpOMS
php phpcs.phar --report-file=${ROOT_PATH}/${BUILD_PATH}/logs/phpcsModules.log --standard=${ROOT_PATH}/${BUILD_PATH}/phpcs.xml ${ROOT_PATH}/Modules
#php phpmd.phar ${ROOT_PATH}/phpOMS xml ${ROOT_PATH}/${BUILD_PATH}/phpmd.xml --reportfile ${ROOT_PATH}/${BUILD_PATH}/logs/phpmdFramework.log -- bzip missing
#php phpmd.phar ${ROOT_PATH}/Modules xml ${ROOT_PATH}/${BUILD_PATH}/phpmd.xml --reportfile ${ROOT_PATH}/${BUILD_PATH}/logs/phpmdModules.log -- bzip missing
php phpcpd.phar ${ROOT_PATH}/phpOMS --exclude Localization --no-interaction > ${ROOT_PATH}/${BUILD_PATH}/logs/phpcpdFramework.log
php phpcpd.phar ${ROOT_PATH}/Modules --no-interaction > ${ROOT_PATH}/${BUILD_PATH}/logs/phpcpdModules.log

# Linting
find ${ROOT_PATH}/phpOMS -name "*.php" | xargs -L1 php -l > ${ROOT_PATH}/${BUILD_PATH}/logs/temp.log
sed '/^No syntax.*/ d' < ${ROOT_PATH}/${BUILD_PATH}/logs/temp.log > ${ROOT_PATH}/${BUILD_PATH}/logs/phpLintFramework.log
find ${ROOT_PATH}/Modules -name "*.php" | xargs -L1 php -l > ${ROOT_PATH}/${BUILD_PATH}/logs/temp.log
sed '/^No syntax.*/ d' < ${ROOT_PATH}/${BUILD_PATH}/logs/temp.log > ${ROOT_PATH}/${BUILD_PATH}/logs/phpLintModules.log
rm ${ROOT_PATH}/${BUILD_PATH}/logs/temp.log
find ${ROOT_PATH} -name "*.json" | xargs -L1 jsonlint -q > ${ROOT_PATH}/${BUILD_PATH}/logs/jsonLint.log

# External inspection and build
#curl -H "Content-Type: application/json" -X POST -d '{"branch":"$GIT_BRANCH","access_token":"$SCRUTINIZER_TOKEN"}' https://scrutinizer-ci.com/api/repositories/g/spl1nes/oms/inspections?access_token=${SCRUTINIZER_TOKEN}
#curl --get --data api_token=$CODECLIMATE_TOKEN https://codeclimate.com/api/repos/oms/branches/$GIT_BRANCH/refresh -- Coming in the future... right now not available for free
#curl -s -X POST  -H "Content-Type: application/json" -H "Accept: application/json"  -H "Travis-API-Version: 3"  -H "Authorization: token $TRAVIS_TOKEN"  -d '{"request": {"branch":"$GIT_BRANCH"}}' https://api.travis-ci.org/repo/spl1nes%2FOrange-Management/requests

# Html tag inspection
TAG[0]="<\/html>"
TAG[1]="<\/body>"
TAG[2]="<\/head>"
TAG[3]="<\/thead>"
TAG[4]="<\/tbody>"
TAG[5]="<\/tfoot>"
TAG[6]="<\/tr>"
TAG[7]="<\/th>"
TAG[8]="<\/td>"
TAG[9]="<\/option>"
TAG[10]="<\/li>"
TAG[11]="<br\s*\/>"
TAG[12]="<meta.*\/>"
TAG[13]="<input.*\/>"
TAG[14]="<hr.*\/>"
TAG[15]="<img.*\/>"
TAG[16]="<link.*\/>"
TAG[17]="<source.*\/>"
TAG[18]="<embed.*\/>"

for i in "${TAG[@]}"
do
    echo "\nInsepcting $i:\n" >> ${ROOT_PATH}/${BUILD_PATH}/logs/htmlinspection.log
    grep -rln "$i" --include \*.tpl.php ${ROOT_PATH}/phpOMS >> ${ROOT_PATH}/${BUILD_PATH}/logs/htmlinspection.log
    grep -rln "$i" --include \*.tpl.php ${ROOT_PATH}/Modules >> ${ROOT_PATH}/${BUILD_PATH}/logs/htmlinspection.log
done

# Find empty attributes
grep -rln "=\"\"" --include \*.tpl.php ${ROOT_PATH} > ${ROOT_PATH}/${BUILD_PATH}/logs/unusedattributes.log
