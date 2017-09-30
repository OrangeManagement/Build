<?php

function endsWith($haystack, $needle)
{
    return $needle === '' || (($temp = strlen($haystack) - strlen($needle)) >= 0 && strpos($haystack, $needle, $temp) !== false);
}

function listFolderFiles($dir, $extension)
{
    $files = [];
    $ffs   = scandir($dir);
    foreach ($ffs as $ff) {
        if ($ff !== '.' && $ff !== '..') {
            if (is_dir($dir . '/' . $ff)) {
                $files = array_merge($files, listFolderFiles($dir . '/' . $ff, $extension));
            } else {
                if (endsWith($ff, $extension)) {
                    $files[] = $dir . '/' . $ff;
                }
            }
        }
    }

    return $files;
}

// PHP tests
$base     = __DIR__ . '/../../phpOMS';
$testBase = __DIR__ . '/../../Tests/PHPUnit/Framework';
$files    = listFolderFiles($testBase, 'Test.php');

foreach ($files as $file) {
    $baseFile     = str_replace($testBase, $base, $file);
    $baseFile     = str_replace('Test.php', '.php', $baseFile);

    if (!file_exists($baseFile)) {
        unlink($file);
    }
}

// JS tests
$base     = __DIR__ . '/../../jsOMS';
$testBase = __DIR__ . '/../../Tests/JS/Framework';
$files    = listFolderFiles($testBase, 'Test.js');

foreach ($files as $file) {
    $baseFile     = str_replace($testBase, $base, $file);
    $baseFile     = str_replace('Test.js', '.js', $baseFile);

    if (!file_exists($baseFile)) {
        unlink($file);
    }
}

