#!/bin/bash

isPhanTestSuccessful() {
    php -d memory_limit=4G ${rootpath}/vendor/bin/phan -k ${rootpath}/Build/Config/phan.php -f "$1" >&2
    if [ $? -ne 0 ]; then
        return 0
    fi

    return 1
}

isPhpStanTestSuccessful() {
    php -d memory_limit=4G ${rootpath}/vendor/bin/phpstan analyse --autoload-file=${rootpath}/phpOMS/Autoloader.php -l 7 -c ${rootpath}/Build/Config/phpstan.neon "$1" >&2
    if [ $? -ne 0 ]; then
        return 0
    fi

    return 1
}