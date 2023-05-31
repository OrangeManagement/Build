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
        if (\stripos($line, ' public function ') !== false
            || \stripos($line, ' public static function ') !== false
        ) {
            $testFile = \str_replace('.php', 'Test.php', $filename);
            $testFile = \str_replace('/phpOMS/', '/phpOMS/tests/', $filename);

            if (\stripos($testFile, '../Modules/') !== false) {
                $subdirectory = "tests/";

                $position = strrpos($testFile, "/../");

                if ($position !== false) {
                    $position = \stripos($testFile, '/', $position + 4) + 1;
                    $position = \stripos($testFile, '/', $position) + 1;
                    $testFile = \substr_replace($testFile, $subdirectory, $position, 0);
                }
            }

            if (\file_exists($testFile)) {
                $scopeStart = true;

                $testContent = \file_get_contents($testFile);

                // Parse functio name
                $pattern = '/\bfunction\b\s+(\w+)\s*\(/';
                \preg_match($pattern, $line, $matches);

                if (\stripos($testContent, $matches[1] ?? '~~~') !== false) {
                    // Test already exists
                    continue;
                }
            }

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

    return "Implement a PHPUnit test function for the following function:\n" . $lines;
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
