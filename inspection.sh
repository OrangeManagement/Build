#!/bin/bash

# Include private
. var.sh
. $ROOT_PATH/private.sh

# Previous cleanup
rm -r -f $ROOT_PATH/$BUILD_PATH/logs
rm -r -f $ROOT_PATH/$BUILD_PATH/stats
rm -r -f $ROOT_PATH/$BUILD_PATH/docs

# Creating directories
mkdir -p $ROOT_PATH/$BUILD_PATH/logs
mkdir -p $ROOT_PATH/$BUILD_PATH/stats >> $ROOT_PATH/$BUILD_PATH/logs/build.log
mkdir -p $ROOT_PATH/$BUILD_PATH/docs >> $ROOT_PATH/$BUILD_PATH/logs/build.log

# Handling git
cd $ROOT_PATH && git fetch --all && git reset --hard origin/$GIT_BRANCH && git pull >> $ROOT_PATH/$BUILD_PATH/logs/build.log

# Setting up database for demo and testing
mysql -e 'drop database if exists oms;' -u root -p$DB_PASSWORD
mysql -e 'create database oms;' -u root -p$DB_PASSWORD
#echo "USE mysql;\nUPDATE user SET password=PASSWORD('123456') WHERE user='root';\nFLUSH PRIVILEGES;\n" | mysql -u root

curl --connect-timeout 600 --max-time 601 $WEB_URL/Admin/Install

# Downloading tools
wget -nc https://phar.phpunit.de/phploc.phar
wget -nc https://phar.phpunit.de/phpunit.phar
wget -nc https://github.com/Halleck45/PhpMetrics/raw/master/build/phpmetrics.phar
wget -nc http://phpdoc.org/phpDocumentor.phar
wget -nc http://static.pdepend.org/php/latest/pdepend.phar
wget -nc https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
wget -nc http://static.phpmd.org/php/latest/phpmd.phar
wget -nc https://phar.phpunit.de/phpcpd.phar

# Executing unit tests
php $ROOT_PATH/phpunit.phar --configuration $ROOT_PATH/$TEST_PATH/PHPUnit/phpunit_default.xml --coverage-text --coverage-clover $ROOT_PATH/$BUILD_PATH/logs/clover.xml > $ROOT_PATH/$BUILD_PATH/logs/phpunit.log

# Stats & metrics
php $ROOT_PATH/phploc.phar $ROOT_PATH/phpOMS/ > $ROOT_PATH/$BUILD_PATH/stats/phpOMS.log
php $ROOT_PATH/phploc.phar $ROOT_PATH/Modules/ > $ROOT_PATH/$BUILD_PATH/stats/ModulesStats.log

php $ROOT_PATH/phpmetrics.phar --report-html=$ROOT_PATH/$BUILD_PATH/stats/ReportFramework.html $ROOT_PATH/phpOMS/ >> $ROOT_PATH/$BUILD_PATH/logs/build.log
php $ROOT_PATH/phpmetrics.phar --report-html=$ROOT_PATH/$BUILD_PATH/stats/ReportModules.html $ROOT_PATH/Modules/ >> $ROOT_PATH/$BUILD_PATH/logs/build.log

php $ROOT_PATH/pdepend.phar --summary-xml=$ROOT_PATH/$BUILD_PATH/stats/phpOMSSummary.xml --jdepend-chart=$ROOT_PATH/$BUILD_PATH/stats/phpOMSDepend.svg --overview-pyramid=$ROOT_PATH/$BUILD_PATH/stats/phpOMSPryramid.svg $ROOT_PATH/phpOMS
php $ROOT_PATH/pdepend.phar --summary-xml=$ROOT_PATH/$BUILD_PATH/stats/modulesSummary.xml --jdepend-chart=$ROOT_PATH/$BUILD_PATH/stats/modulesDepend.svg --overview-pyramid=$ROOT_PATH/$BUILD_PATH/stats/modulesPyramid.svg $ROOT_PATH/Modules

# Documentation
php $ROOT_PATH/phpDocumentor.phar -d $ROOT_PATH --ignore "*/phpOMS/Localization/*" -t $ROOT_PATH/$BUILD_PATH/docs

# Local inspection
php phpcs.phar --report-file=$ROOT_PATH/$BUILD_PATH/logs/phpcsFramework.log --ignore=$ROOT_PATH/phpOMS/Localization --standard=$ROOT_PATH/$BUILD_PATH/phpcs.xml $ROOT_PATH/phpOMS
php phpcs.phar --report-file=$ROOT_PATH/$BUILD_PATH/logs/phpcsModules.log --standard=$ROOT_PATH/$BUILD_PATH/phpcs.xml $ROOT_PATH/Modules
#php phpmd.phar $ROOT_PATH/phpOMS xml $ROOT_PATH/$BUILD_PATH/phpmd.xml --reportfile $ROOT_PATH/$BUILD_PATH/logs/phpmdFramework.log -- bzip missing
#php phpmd.phar $ROOT_PATH/Modules xml $ROOT_PATH/$BUILD_PATH/phpmd.xml --reportfile $ROOT_PATH/$BUILD_PATH/logs/phpmdModules.log -- bzip missing
php phpcpd.phar $ROOT_PATH/phpOMS --exclude Localization --no-interaction > $ROOT_PATH/$BUILD_PATH/logs/phpcpdFramework.log
php phpcpd.phar $ROOT_PATH/Modules --no-interaction > $ROOT_PATH/$BUILD_PATH/logs/phpcpdModules.log

# Linting
find $ROOT_PATH/phpOMS -name "*.php" | xargs -L1 php -l > $ROOT_PATH/$BUILD_PATH/logs/temp.log
sed '/^No syntax.*/ d' < $ROOT_PATH/$BUILD_PATH/temp.log > $ROOT_PATH/$BUILD_PATH/logs/phpLintFramework.log
find $ROOT_PATH/Modules -name "*.php" | xargs -L1 php -l > $ROOT_PATH/$BUILD_PATH/logs/temp.log
sed '/^No syntax.*/ d' < $ROOT_PATH/$BUILD_PATH/temp.log > $ROOT_PATH/$BUILD_PATH/logs/phpLintModules.log
rm $ROOT_PATH/$BUILD_PATH/logs/temp.log

# External inspection and build
curl -H "Content-Type: application/json" -X POST -d '{"branch":"$GIT_BRANCH","access_token":"$SCRUTINIZER_TOKEN"}' https://scrutinizer-ci.com/api/repositories/g/spl1nes/oms/inspections?access_token=$SCRUTINIZER_TOKEN
#curl --get --data api_token=$CODECLIMATE_TOKEN https://codeclimate.com/api/repos/oms/branches/$GIT_BRANCH/refresh -- Coming in the future... right now not available for free
#curl -s -X POST  -H "Content-Type: application/json" -H "Accept: application/json"  -H "Travis-API-Version: 3"  -H "Authorization: token $TRAVIS_TOKEN"  -d '{"request": {"branch":"$GIT_BRANCH"}}' https://api.travis-ci.org/repo/spl1nes%2FOrange-Management/requests

# Mail
#echo "New build of branch $GIT_BRANCH from $GITHUB_URL created." | mail -s "New build" $MAIL_ADDR

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
    echo "\nInsepcting $i:\n" >> $ROOT_PATH/$BUILD_PATH/logs/htmlinspection.log
    grep -rln "$i" --include \*.tpl.php $ROOT_PATH/phpOMS >> $ROOT_PATH/$BUILD_PATH/logs/htmlinspection.log
    grep -rln "$i" --include \*.tpl.php $ROOT_PATH/Modules >> $ROOT_PATH/$BUILD_PATH/logs/htmlinspection.log
done

# Find empty attributes
grep -rln "=\"\"" --include \*.tpl.php $ROOT_PATH > $ROOT_PATH/$BUILD_PATH/logs/unusedattributes.log
