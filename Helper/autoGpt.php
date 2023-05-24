<?php

use Build\Helper\GptHelper;

include __DIR__ . '/../../phpOMS/Autoloader.php';

// fix docblocks
$globs = [
    __DIR__ . '/../../phpOMS/**/*.php',
    __DIR__ . '/../../Modules/*/Models/*.php',
    __DIR__ . '/../../Modules/*/Controller/*.php',
];

$behaviour = <<<BEHAVIOUR
Create missing php docblocks with a similar format for member variables:
/**
* Default delivery address.
*
* @var Address|null
* @since 1.0.0
*/
and for functions:
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
Only output the php code, nothing else. Also don't add or change any new php code except the docblocks.
BEHAVIOUR;

$fileReader = function ($in, $filename)
{
    $lines        = '';
    $scopeStart   = false;
    $scopeCounter = 0;

    $isFirstLine = true;

    while (($line = \fgets($in)) !== false && (\trim($line) !== '' || $scopeCounter > 0)) {
        $isFirstLine = false;

        if (\stripos($line, ' function ') !== false) {
            $scopeStart = true;
        }

        if ($scopeStart) {
            $scopeCounter += \substr_count($line, '{');
            $scopeCounter -= \substr_count($line, '}');

            if ($scopeCounter === 0) {
                $scopeStart = false;
            }
        }

        $lines .= $line;
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

// implement test
$globs = [
    __DIR__ . '/../../phpOMS/**.php',
    __DIR__ . '/../../Modules/*/Models/*.php',
];

$behaviour = <<<BEHAVIOUR
Implement a php unit test for the given function.
BEHAVIOUR;

$fileReader = function ($in, $filename)
{
    $lines        = '';
    $scopeStart   = false;
    $scopeCounter = 0;

    $isFirstLine = true;

    while (($line = \fgets($in)) !== false && ($line !== '' || $scopeCounter > 0)) {
        $isFirstLine = false;

        if (\stripos($line, 'public function ') !== false || \stripos($line, 'public static function ') !== false) {
            // Check if a test exists for this function
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
                    $scopeStart = false;
                }
            }

            $scopeStart = true;
        }

        // Not in a function / not relevant
        if (!$scopeStart) {
            continue;
        }

        if ($scopeStart) {
            $scopeCounter += \substr_count($line, '{');
            $scopeCounter -= \substr_count($line, '}');

            if ($scopeCounter === 0) {
                $scopeStart = false;
            }
        }

        $lines .= $line;
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

        $response = GptHelper::handleFile($file, 'php://memory', $behaviour, $fileReader);
        echo $response , \PHP_EOL , \PHP_EOL;
    }
}

// complete and improve test
$globs = [
    __DIR__ . '/../../phpOMS/**.php',
    __DIR__ . '/../../Modules/*/Models/*.php',
];

$behaviour = <<<BEHAVIOUR
Improve the given php unit test for the given function.
BEHAVIOUR;

$fileReader = function ($in, $filename)
{
    $lines        = '';
    $scopeStart   = false;
    $scopeCounter = 0;

    $isFirstLine = true;

    while (($line = \fgets($in)) !== false && ($line !== '' || $scopeCounter > 0)) {
        $isFirstLine = false;

        if (\stripos($line, 'public function ') !== false || \stripos($line, 'public static function ') !== false) {
            // Check if a test exists for this function
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
                    $scopeStart = false;
                }

                $scopeStart = true;
            } else {
                $scopeStart = false;
            }
        }

        // Not in a function / not relevant
        if (!$scopeStart) {
            continue;
        }

        if ($scopeStart) {
            $scopeCounter += \substr_count($line, '{');
            $scopeCounter -= \substr_count($line, '}');

            if ($scopeCounter === 0) {
                $scopeStart = false;
            }
        }

        $lines .= $line;
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

        $response = GptHelper::handleFile($file, 'php://memory', $behaviour, $fileReader);
        echo $response , \PHP_EOL , \PHP_EOL;
    }
}