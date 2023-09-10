#!/bin/bash

SCRIPT=$(readlink -f "$0")
BPATH=$(dirname "$SCRIPT")

echo "#################################################"
echo "# PHP strict"
echo "#################################################"

grep -r -L "declare(strict_types=1);" --include=*.php --exclude-dir={*vendor*,*Files*,*privateSetup*,*demoSetup*,*LanguageDetection*,*Resources*,*node_modules*,*privateSetup*,*Build*} --exclude={*.tpl.php,*Hooks.php,*Routes.php,*SearchCommands.php} ${BPATH}/../../phpOMS ${BPATH}/../../Web ${BPATH}/../../Modules ${BPATH}/../../Model

echo "#################################################"
echo "# JS security inspection"
echo "#################################################"

grep -rlni "onafterprint=\|onbeforeprint=\|onbeforeunload=\|onerror=\|onhaschange=\|onload=\|onmessage=\|onoffline=\|ononline=\|onpagehide=\|onpageshow=\|onpopstate=\|onredo=\|onresize=\|onstorage=\|onund=o\|onunload=\|onblur=\|onchage=\|oncontextmenu=\|onfocus=\|onformchange=\|onforminput=\|oninput=\|oninvalid=\|onreset=\|onselect=\|onsubmit=\|onkeydown=\|onkeypress=\|onkeyup=\|onclick=\|ondblclic=k\|ondrag=\|ondragend=\|ondragenter=\|ondragleave=\|ondragover=\|ondragstart=\|ondrop=\|onmousedown=\|onmousemove=\|onmouseout=\|onmouseover=\|onmouseup=\|onmousewheel=\|onscroll=\|onabor=t\|oncanplay=\|oncanplaythrough=\|ondurationchange=\|onemptied=\|onended=\|onerror=\|onloadeddata=\|onloadedmetadata=\|onloadstart=\|onpause=\|onplay=\|onplaying=\|onprogress=\|onratechange=\|onreadystatechange=\|onseeked=\|onseeking=\|onstalled=\|onsuspend=\|ontimeupdate=\|onvolumechange=" --include=*.js ${BPATH}/../../jsOMS ${BPATH}/../../Model ${BPATH}/../../Modules ${BPATH}/../../Web

echo "#################################################"
echo "# PHPCS"
echo "#################################################"

./vendor/bin/phpcs --severity=1 ./ --standard="Build/Config/phpcs.xml"

echo "#################################################"
echo "# PHP static inspection"
echo "#################################################"

./vendor/bin/phpstan analyse -l 9 -c Build/Config/phpstan.neon ./

echo "#################################################"
echo "# Rector inspection"
echo "#################################################"

# vendor/bin/rector process --config Build/Config/rector.php --dry-run ./

echo "#################################################"
echo "# ESlint"
echo "#################################################"

npx eslint jsOMS/ -c Build/Config/.eslintrc.json

echo "#################################################"
echo "# MYSQL queries"
echo "#################################################"

mysqldumpslow -t 10 /var/log/mysql/mysql-slow.log
mysqldumpslow -t 10 -s l /var/log/mysql/mysql-slow.log
pt-query-digest /var/log/mysql/mysql-slow.log

echo "#################################################"
echo "# PHP stats inspection"
echo "#################################################"

./vendor/bin/phploc --exclude vendor --exclude node_modules --exclude Resources --exclude Build --exclude .git --exclude privateSetup --exclude demoSetup ./
