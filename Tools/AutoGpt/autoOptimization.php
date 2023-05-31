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
You are a developer.
BEHAVIOUR;

$fileReader = function ($in, $filename): bool|string
{
    $lines        = '';
    $scopeStart   = false;
    $scopeCounter = 0;

    $isFirstLine = true;

    while (($line = \fgets($in)) !== false && ($isFirstLine || $scopeStart)) {
        if (\stripos($line, ' function ') !== false) {
            $scopeStart = true;
        }

        // Not in a function / not relevant
        if (!$scopeStart) {
            continue;
        }

        $isFirstLine = false;
        $scopeChange = \substr_count($line, '{') - \substr_count($line, '}');

        if ($scopeCounter !== 0 && $scopeCounter + $scopeChange === 0) {
            $scopeStart = false;
        }

        $scopeCounter += $scopeChange;

        $lines .= $line;
    }

    // No content or too short
    if (($isFirstLine && empty(\trim($lines))) || \strlen($lines) < 550) {
        return false;
    }

    return "Improve the performance and security of the following function without chaning the behaviour. Don't give me any explanations:\n" . $lines;
};

$output = __DIR__ . '/../../../improvements.log';
$log = \fopen($output, 'w');

foreach ($globs as $glob) {
    $files = \glob($glob);
    foreach ($files as $file) {
        if (\stripos($file, 'Test.php')) {
            continue;
        }

        $response = GptHelper::handleFile($file, 'php://memory', $behaviour, $fileReader, false);

        if (\trim($response) !== '') {
            \fwrite($log, $file . ":\n");
            \fwrite($log, $response);
            \fwrite($log, "\n\n");
        }
    }
}

\fclose($log);
