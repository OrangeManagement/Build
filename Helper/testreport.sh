#!/bin/bash

mkdir -p Build/test

# php cs + phpstan + eslint file generation
./vendor/bin/phpcs --severity=1 ./ --standard="Build/Config/phpcs.xml" -s --report-junit=Build/test/junit_phpcs.xml
./vendor/bin/phpstan analyse -l 9 -c Build/Config/phpstan.neon --error-format=prettyJson ./ > Build/test/phpstan.json
npx eslint jsOMS/ -c Build/Config/.eslintrc.json -o Build/test/junit_eslint.xml -f junit

# Remove empty lines and lines with warnings which corrupt the json format
sed -i '/^$/d' Build/test/phpstan.json
sed -i '/^Warning: /d' Build/test/phpstan.json

# Create report
php ./Tools/TestReportGenerator/src/index.php \
-b /var/www/html/Karaka \
-l /var/www/html/Karaka/Build/Config/reportLang.php \
-c /var/www/html/Karaka/tests/coverage.xml \
-s /var/www/html/Karaka/Build/test/junit_phpcs.xml \
-sj /var/www/html/Karaka/Build/test/junit_eslint.xml \
-a /var/www/html/Karaka/Build/test/phpstan.json \
-u /var/www/html/Karaka/Build/test/junit_php.xml \
-d /var/www/html/Karaka/Build/test/ReportExternal \
--version 1.0.0
