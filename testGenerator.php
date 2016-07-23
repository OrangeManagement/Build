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
                $files += listFolderFiles($dir . '/' . $ff, $extension);
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
$base  = __DIR__ . '/../phpOMS';
$files = listFolderFiles($base, '.php');
$testBase = __DIR__ . '/../Tests/PHPUnit/Framework';

foreach ($files as $file) {
    $file   = str_replace($base, '', $file);
    $subdir = trim($file, '/');
    $split = explode('.', $file);
    $testPath = $testBase . '/'. $split[0] . 'Test.' . $split[1];

    if (strpos($subdir, 'Status.php') === false
        && strpos($subdir, 'Type.php') === false
        && strpos($subdir, 'Status') === false
        && strpos($subdir, 'Enum') === false
        && strpos($subdir, 'Null') === false
        && strpos($subdir, 'Interface') === false
        && strpos($subdir, 'Abstract') === false) {
        if(!file_exists($testPath)) {
            mkdir(dirname($testPath), 0777, true);
            file_put_contents($testPath, '<?php');
        }
    }
}

// PHP tests
$base  = __DIR__ . '/../jsOMS';
$files = listFolderFiles($base, '.php');
$testBase = __DIR__ . '/../Tests/JS/Framework';

foreach ($files as $file) {
    $file   = str_replace($base, '', $file);
    $subdir = trim($file, '/');
    $split = explode('.', $file);
    $testPath = $testBase . '/'. $split[0] . 'Test.' . $split[1];

    if (strpos($subdir, 'Status.php') === false
        && strpos($subdir, 'Type.php') === false
        && strpos($subdir, 'Status') === false
        && strpos($subdir, 'Enum') === false
        && strpos($subdir, 'Null') === false
        && strpos($subdir, 'Interface') === false
        && strpos($subdir, 'Abstract') === false) {
        if(!file_exists($testPath)) {
            mkdir(dirname($testPath), 0777, true);
            file_put_contents($testPath, '');
        }
    }
}