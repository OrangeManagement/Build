#!/bin/bash

mkdir -p Build/test

# php cs + phpstan + eslint file generation
./vendor/bin/phpcs --severity=1 ./ --standard="Build/Config/phpcs.xml" -s --report-junit=Build/test/junit_phpcs.xml
./vendor/bin/phpstan analyse --autoload-file=phpOMS/Autoloader.php -l 9 -c Build/Config/phpstan.neon --error-format=prettyJson ./ > Build/test/phpstan.json
npx eslint jsOMS/ -c Build/Config/.eslintrc.json -o Build/test/junit_eslint.xml -f junit

# Remove empty lines and lines with warnings which corrupt the json format
sed -i '/^$/d' Build/test/phpstan.json
sed -i '/^Warning: /d' Build/test/phpstan.json

# Create report
php ../TestReportGenerator/src/index.php \
-b /home/spl1nes/Orange-Management \
-l /home/spl1nes/Orange-Management/Build/Config/reportLang.php \
-c /home/spl1nes/Orange-Management/tests/coverage.xml \
-s /home/spl1nes/Orange-Management/Build/test/junit_phpcs.xml \
-sj /home/spl1nes/Orange-Management/Build/test/junit_eslint.xml \
-a /home/spl1nes/Orange-Management/Build/test/phpstan.json \
-u /home/spl1nes/Orange-Management/Build/test/junit_php.xml \
-d /home/spl1nes/Orange-Management/Build/test/ReportExternal \
--version 1.0.0
