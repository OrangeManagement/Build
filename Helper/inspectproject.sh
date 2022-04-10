#!/bin/bash

# html checks
find ./Web ./Install ./Modules -name "*tpl.php" | xargs grep -E '=\"[\#\$\%\^\&\*\(\)\\/\ ]*\"'
find ./Web ./Install ./Modules -name "*tpl.php" | xargs grep -P '(\<img)((?!.*?alt=).)*(>)'
find ./Web ./Install ./Modules -name "*tpl.php" | xargs grep -P '(<input)((?!.*?type=).)*(>)'
find ./Web ./Install ./Modules -name "*tpl.php" | xargs grep -P '(<input|<select|<textarea)((?!.*?name=).)*(>)'
find ./Web ./Install ./Modules -name "*tpl.php" | xargs grep -P '(style=)'
find ./Web ./Install ./Modules -name "*tpl.php" | xargs grep -P '(value|title|alt|aria\-label)(=\")((?!\<\?).)*(>)'
find ./Web ./Install ./Modules -name "*tpl.php" | xargs grep -P '(\<td\>|\<th\>|\<caption\>|\<label.*?(\"|l)\>)[0-9a-zA-Z\.\?]+)'

# php/js strict checks
grep -r -L "declare(strict_types=1);" --include=*.php --exclude={*.tpl.php,*Hooks.php,*Routes.php,*SearchCommands.php} ./phpOMS ./Web ./Modules ./Model
grep -r -L "\"use strict\";" --include=*.js ./jsOMS ./Modules ./Model

# php/js has logs
find ./Web ./phpOMS ./Model ./Modules -name "*.js" | xargs grep 'console.log('
find ./Web ./jsOMS ./Model ./Modules -name "*.php" | xargs grep 'var_dump('

# js uses on actions
grep -rlni "onafterprint=\|onbeforeprint=\|onbeforeunload=\|onerror=\|onhaschange=\|onload=\|onmessage=\|onoffline=\|ononline=\|onpagehide=\|onpageshow=\|onpopstate=\|onredo=\|onresize=\|onstorage=\|onund=o\|onunload=\|onblur=\|onchage=\|oncontextmenu=\|onfocus=\|onformchange=\|onforminput=\|oninput=\|oninvalid=\|onreset=\|onselect=\|onsubmit=\|onkeydown=\|onkeypress=\|onkeyup=\|onclick=\|ondblclic=k\|ondrag=\|ondragend=\|ondragenter=\|ondragleave=\|ondragover=\|ondragstart=\|ondrop=\|onmousedown=\|onmousemove=\|onmouseout=\|onmouseover=\|onmouseup=\|onmousewheel=\|onscroll=\|onabor=t\|oncanplay=\|oncanplaythrough=\|ondurationchange=\|onemptied=\|onended=\|onerror=\|onloadeddata=\|onloadedmetadata=\|onloadstart=\|onpause=\|onplay=\|onplaying=\|onprogress=\|onratechange=\|onreadystatechange=\|onseeked=\|onseeking=\|onstalled=\|onsuspend=\|ontimeupdate=\|onvolumechange=" --include=*.js ./jsOMS ./Model ./Modules ./Web

# white spaces at end of line
find ./Web ./phpOMS ./jsOMS ./cOMS ./Model ./Build ./Modules \( -name "*.php" -o -name "*.js" -o -name "*.sh" -o -name "*.cpp" -o -name "*.h" -o -name "*.json" \) | xargs grep -P ' $'

# php cs + phpstan + eslint
./vendor/bin/phpcs ./ --standard="Build/Config/phpcs.xml"
./vendor/bin/phpstan analyse --autoload-file=phpOMS/Autoloader.php -l 9 -c Build/Config/phpstan.neon ./
npx eslint jsOMS/ -c Build/Config/.eslintrc.json