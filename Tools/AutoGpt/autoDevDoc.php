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
You are a developer, create a developer documentation for the following code using markdown.
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

$output = __DIR__ . '/../../../doc.md';
$md = \fopen($output, 'w');

foreach ($globs as $glob) {
    $files = \glob($glob);

    foreach ($files as $file) {
        if (\stripos($file, 'Test.php')) {
            continue;
        }

        $response = GptHelper::handleFile($file, 'php://memory', $behaviour, $fileReader);

        if (\trim($response) !== '') {
            \fwrite($md, $file . ":\n");
            \fwrite($md, $response);
            \fwrite($md, "\n\n");
        }
    }
}

\fclose($md);