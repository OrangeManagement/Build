<?php declare(strict_types=1);

if (\is_file(__DIR__ . '/../../phpOMS/Autoloader.php')) {
    require_once __DIR__ . '/../../phpOMS/Autoloader.php';
} else {
    require_once __DIR__ . '/../../Autoloader.php';
}

use phpOMS\Autoloader;

Autoloader::addPath(__DIR__ . '/../../Resources');
Autoloader::addPath(__DIR__ . '/../../Resources/tcpdf');
Autoloader::addPath(__DIR__ . '/../../Resources/Stripe');
