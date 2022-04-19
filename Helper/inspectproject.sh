#!/bin/bash

SCRIPT=$(readlink -f "$0")
BPATH=$(dirname "$SCRIPT")

# html checks
printf "\nHTML checks\n\n"
find ${BPATH}/../../Web ${BPATH}/../../Install ${BPATH}/../../Modules -name "*tpl.php" | xargs -0 grep -E '=\"[\#\$\%\^\&\*\(\)\\/\ ]*\"'
find ${BPATH}/../../Web ${BPATH}/../../Install ${BPATH}/../../Modules -name "*tpl.php" | xargs -0 grep -P '(\<img)((?!.*?alt=).)*(>)'
find ${BPATH}/../../Web ${BPATH}/../../Install ${BPATH}/../../Modules -name "*tpl.php" | xargs -0 grep -P '(<input)((?!.*?type=).)*(>)'
find ${BPATH}/../../Web ${BPATH}/../../Install ${BPATH}/../../Modules -name "*tpl.php" | xargs -0 grep -P '(<input|<select|<textarea)((?!.*?name=).)*(>)'
find ${BPATH}/../../Web ${BPATH}/../../Install ${BPATH}/../../Modules -name "*tpl.php" | xargs -0 grep -P '(style=)'
find ${BPATH}/../../Web ${BPATH}/../../Install ${BPATH}/../../Modules -name "*tpl.php" | xargs -0 grep -P '(value|title|alt|aria\-label)(=\")((?!\<\?).)*(>)'
find ${BPATH}/../../Web ${BPATH}/../../Install ${BPATH}/../../Modules -name "*tpl.php" | xargs -0 grep -P '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+)'

# php/js strict checks
printf "\nStrict checks\n\n"
grep -r -L "declare(strict_types=1);" --include=*.php --exclude={*.tpl.php,*Hooks.php,*Routes.php,*SearchCommands.php} ${BPATH}/../../phpOMS ${BPATH}/../../Web ${BPATH}/../../Modules ${BPATH}/../../Model

# php/js has logs
printf "\nLog checks\n\n"
find ${BPATH}/../../Web ${BPATH}/../../phpOMS ${BPATH}/../../Model ${BPATH}/../../Modules -name "*.js" | xargs -0 grep 'console.log('
find ${BPATH}/../../Web ${BPATH}/../../jsOMS ${BPATH}/../../Model ${BPATH}/../../Modules -name "*.php" | xargs -0 grep 'var_dump('

# js uses on actions
printf "\nJs Action checks\n\n"
grep -rlni "onafterprint=\|onbeforeprint=\|onbeforeunload=\|onerror=\|onhaschange=\|onload=\|onmessage=\|onoffline=\|ononline=\|onpagehide=\|onpageshow=\|onpopstate=\|onredo=\|onresize=\|onstorage=\|onund=o\|onunload=\|onblur=\|onchage=\|oncontextmenu=\|onfocus=\|onformchange=\|onforminput=\|oninput=\|oninvalid=\|onreset=\|onselect=\|onsubmit=\|onkeydown=\|onkeypress=\|onkeyup=\|onclick=\|ondblclic=k\|ondrag=\|ondragend=\|ondragenter=\|ondragleave=\|ondragover=\|ondragstart=\|ondrop=\|onmousedown=\|onmousemove=\|onmouseout=\|onmouseover=\|onmouseup=\|onmousewheel=\|onscroll=\|onabor=t\|oncanplay=\|oncanplaythrough=\|ondurationchange=\|onemptied=\|onended=\|onerror=\|onloadeddata=\|onloadedmetadata=\|onloadstart=\|onpause=\|onplay=\|onplaying=\|onprogress=\|onratechange=\|onreadystatechange=\|onseeked=\|onseeking=\|onstalled=\|onsuspend=\|ontimeupdate=\|onvolumechange=" --include=*.js ${BPATH}/../../jsOMS ${BPATH}/../../Model ${BPATH}/../../Modules ${BPATH}/../../Web

# white spaces at end of line
printf "\nWhitespace check\n\n"
find ${BPATH}/../../Web ${BPATH}/../../phpOMS ${BPATH}/../../jsOMS ${BPATH}/../../cOMS ${BPATH}/../../Model ${BPATH}/../../Build ${BPATH}/../../Modules \( -name "*.php" -o -name "*.js" -o -name "*.sh" -o -name "*.cpp" -o -name "*.h" -o -name "*.json" \) | xargs -0 grep -P ' $'

# php cs + phpstan + eslint
./vendor/bin/phpcs ./ --standard="Build/Config/phpcs.xml"
./vendor/bin/phpstan analyse --autoload-file=phpOMS/Autoloader.php -l 9 -c Build/Config/phpstan.neon ./
npx eslint jsOMS/ -c Build/Config/.eslintrc.json