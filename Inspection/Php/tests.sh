#!/bin/bash

. ../../config.sh

php ${TOOLS_PATH}/phpunit.phar --configuration ${TEST_PATH}/PHPUnit/phpunit_default.xml > ${INSPECTION_PATH}/logs/phpunit.log
#phpdbg -qrr phpunit.phar --configuration Tests/PHPUnit/phpunit_default.xml
#php Documentor/src/index.php -s C:\Users\coyle\Desktop\Orange-Management\phpOMS -d C:\Users\coyle\Desktop\outtest -c C:\Users\coyle\Desktop\Orange-Management\Build\log\coverage.xml -u C:\Users\coyle\Desktop\Orange-Management\Build\log\test.xml -g C:\Users\coyle\Desktop\Orange-Management\Developer-Guide
#phpdbg -qrr phpunit.phar Tests/PHPUnit/Framework/Math/Matrix/MatrixTest.php --bootstrap Tests/PHPUnit/Bootstrap.php