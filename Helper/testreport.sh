#!/bin/bash

mkdir -p Build/test

php phpcs.phar ./ --standard="Build/Config/phpcs.xml"
./vendor/bin/phpstan analyse --autoload-file=phpOMS/Autoloader.php -l 8 -c Build/Config/phpstan.neon ./

php phpcs.phar ./ --standard="Build/Config/phpcs.xml" -s --report-junit=Build/test/junit_phpcs.xml
./vendor/bin/phpstan analyse --autoload-file=phpOMS/Autoloader.php -l 8 -c Build/Config/phpstan.neon --error-format=prettyJson ./ > Build/test/phpstan.json

# Remove empty lines and lines with warnings which corrupt the json format
sed -i '/^$/d' Build/test/phpstan.json
sed -i '/^Warning: /d' Build/test/phpstan.json

php ../TestReportGenerator/src/index.php -b /home/spl1nes/Orange-Management -l /home/spl1nes/Orange-Management/Build/Config/reportLang.php -c /home/spl1nes/Orange-Management/tests/coverage.xml -s /home/spl1nes/Orange-Management/Build/test/junit_phpcs.xml -a /home/spl1nes/Orange-Management/Build/test/phpstan.json -u /home/spl1nes/Orange-Management/Build/test/junit_php.xml -d /home/spl1nes/Orange-Management/Build/test/ReportExternal --version 1.0.0