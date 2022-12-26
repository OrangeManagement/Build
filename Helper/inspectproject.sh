#!/bin/bash

SCRIPT=$(readlink -f "$0")
BPATH=$(dirname "$SCRIPT")

# php/js strict checks
printf "\nStrict checks\n\n"
grep -r -L "declare(strict_types=1);" --include=*.php --exclude-dir={*vendor*,*Files*,*privateSetup*,*demoSetup*} --exclude={*.tpl.php,*Hooks.php,*Routes.php,*SearchCommands.php} ${BPATH}/../../phpOMS ${BPATH}/../../Web ${BPATH}/../../Modules ${BPATH}/../../Model

# js uses on actions
printf "\nJs Action checks\n\n"
grep -rlni "onafterprint=\|onbeforeprint=\|onbeforeunload=\|onerror=\|onhaschange=\|onload=\|onmessage=\|onoffline=\|ononline=\|onpagehide=\|onpageshow=\|onpopstate=\|onredo=\|onresize=\|onstorage=\|onund=o\|onunload=\|onblur=\|onchage=\|oncontextmenu=\|onfocus=\|onformchange=\|onforminput=\|oninput=\|oninvalid=\|onreset=\|onselect=\|onsubmit=\|onkeydown=\|onkeypress=\|onkeyup=\|onclick=\|ondblclic=k\|ondrag=\|ondragend=\|ondragenter=\|ondragleave=\|ondragover=\|ondragstart=\|ondrop=\|onmousedown=\|onmousemove=\|onmouseout=\|onmouseover=\|onmouseup=\|onmousewheel=\|onscroll=\|onabor=t\|oncanplay=\|oncanplaythrough=\|ondurationchange=\|onemptied=\|onended=\|onerror=\|onloadeddata=\|onloadedmetadata=\|onloadstart=\|onpause=\|onplay=\|onplaying=\|onprogress=\|onratechange=\|onreadystatechange=\|onseeked=\|onseeking=\|onstalled=\|onsuspend=\|ontimeupdate=\|onvolumechange=" --include=*.js ${BPATH}/../../jsOMS ${BPATH}/../../Model ${BPATH}/../../Modules ${BPATH}/../../Web

# php cs + phpstan + eslint
printf "\nPHPCS checks\n\n"
./vendor/bin/phpcs --severity=1 ./ --standard="Build/Config/phpcs.xml"

printf "\nPHPStan checks\n\n"
./vendor/bin/phpstan analyse --autoload-file=phpOMS/Autoloader.php -l 9 -c Build/Config/phpstan.neon ./

printf "\nESlint checks\n\n"
npx eslint jsOMS/ -c Build/Config/.eslintrc.json