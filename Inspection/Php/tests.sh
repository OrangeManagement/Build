#!/bin/bash

. config.sh

php ${TOOLS_PATH}/phpunit.phar --configuration ${TEST_PATH}/PHPUnit/phpunit_default.xml --log-junit ${INSPECTION_PATH}/Test/Php/junit_php.xml --testdox-html ${INSPECTION_PATH}/Test/Php/index.html --coverage-html ${INSPECTION_PATH}/Test/Php/coverage --coverage-clover ${INSPECTION_PATH}/Test/Php/coverage.xml > ${INSPECTION_PATH}/logs/phpunit.log
#phpdbg -qrr phpunit.phar --configuration Tests/PHPUnit/phpunit_default.xml
#php Documentor/src/index.php -s C:\Users\coyle\Desktop\Orange-Management\phpOMS -d C:\Users\coyle\Desktop\outtest -c C:\Users\coyle\Desktop\Orange-Management\Build\log\coverage.xml -u C:\Users\coyle\Desktop\Orange-Management\Build\log\test.xml -g C:\Users\coyle\Desktop\Orange-Management\Developer-Guide
#phpdbg -qrr phpunit.phar Tests/PHPUnit/Framework/Math/Matrix/MatrixTest.php --bootstrap Tests/PHPUnit/Bootstrap.php