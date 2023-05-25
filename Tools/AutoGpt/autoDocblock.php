<?php

use Build\Tools\AutoGpt\GptHelper;

include __DIR__ . '/../../../phpOMS/Autoloader.php';

// fix docblocks
$globs = [
    __DIR__ . '/../../../phpOMS/**/*.php',
    __DIR__ . '/../../../Modules/*/Models/*.php',
    __DIR__ . '/../../../Modules/*/Controller/*.php',
];

$behaviour = <<<BEHAVIOUR
You are a developer and want to improve the docblocks of member variables and functions.
This is a docblock for class member variables:
/**
* Default delivery address.
*
* @var null|Address
* @since 1.0.0
*/
This is a docblock for functions:
/**
* Order contact elements
*
* @param ContactElement \$ele        Element
* @param bool           \$isRequired Is required
*
* @return int
*
* @since 1.0.0
*/
BEHAVIOUR;

$fileReader = function ($in, $filename)
{
    if (\filesize($filename) > 1300) {
        return false;
    }

    $lines       = '';
    $isFirstLine = true;

    while (($line = \fgets($in)) !== false) {
        $isFirstLine = false;
        $lines      .= $line;
    }

    if ($isFirstLine && empty($lines)) {
        return false;
    }

    return $lines;
};

foreach ($globs as $glob) {
    $files = \glob($glob);

    foreach ($files as $file) {
        if (\stripos($file, 'Test.php')) {
            continue;
        }

        GptHelper::handleFile($file, $file, $behaviour, $fileReader);
    }
}
