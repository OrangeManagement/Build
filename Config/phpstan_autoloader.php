<?php

declare(strict_types=1);

if (\is_file(__DIR__ . '/../../tests/Autoloader.php')) {
    require_once __DIR__ . '/../../tests/Autoloader.php';
} elseif (\is_file(__DIR__ . '/../../phpOMS/Autoloader.php')) {
    require_once __DIR__ . '/../../phpOMS/Autoloader.php';
} else {
    require_once __DIR__ . '/../../Autoloader.php';
}

use tests\Autoloader;

if (\is_dir(__DIR__ . '/../../MainRepository')) {
    Autoloader::addPath(__DIR__ . '/../../MainRepository/');
    Autoloader::addPath(__DIR__ . '/../../MainRepository/Resources/');
    Autoloader::addPath(__DIR__ . '/../../MainRepository/Resources/tcpdf/');
    Autoloader::addPath(__DIR__ . '/../../MainRepository/Resources/Stripe/');
} else {
    Autoloader::addPath(__DIR__ . '/../../Resources/');
    Autoloader::addPath(__DIR__ . '/../../Resources/tcpdf/');
    Autoloader::addPath(__DIR__ . '/../../Resources/Stripe/');
}