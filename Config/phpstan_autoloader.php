<?php

declare(strict_types=1);

function module_autoloader($class) : void {
    $paths = [
        __DIR__ . '/../../',
        __DIR__ . '/../../Resources/',
        __DIR__ . '/../../Resources/tcpdf/',
        __DIR__ . '/../../Resources/Stripe/',
        __DIR__ . '/../../MainRepository/',
        __DIR__ . '/../../MainRepository/Resources/',
        __DIR__ . '/../../MainRepository/Resources/tcpdf/',
        __DIR__ . '/../../MainRepository/Resources/Stripe/',
        __DIR__ . '/../../src/',
        __DIR__ . '/../../../',
    ];

    $class = \ltrim($class, '\\');
    $class = \strtr($class, '_\\', '//');

    if (\stripos($class, 'Web/Backend') !== false || \stripos($class, 'Web/Api') !== false) {
        $class = \str_replace('Web/', 'Install/Application/', $class);
    }

    $class2 = $class;
    $class3 = $class;

    $pos = \stripos($class, '/');
    if ($pos !== false) {
        $class2 = \substr($class, $pos + 1);
    }

    if ($pos !== false) {
        $pos = \stripos($class, '/', $pos + 1);

        if ($pos !== false) {
            $class3 = \substr($class, $pos + 1);
        }
    }

    // github and normal
    foreach ($paths as $path) {
        if (($file = \realpath($path . $class2 . '.php'))) {
            include_once $file;

            return;
        } elseif (($file = \realpath($file = $path . $class3 . '.php')) && \stripos($file, $class2) !== false) {
            include_once $file;

            return;
        } elseif (\is_file($file = $path . $class . '.php')) {
            include_once $file;

            return;
        }
    }

    // own server
    foreach ($paths as $path) {
        if (($file = \realpath($path . 'oms-' . $class2 . '.php'))) {
            include_once $file;

            return;
        } elseif (($file = \realpath($file = $path . 'oms-' . $class3 . '.php')) && \stripos($file, $class2) !== false) {
            include_once $file;

            return;
        } elseif (\is_file($file = $path . 'oms-' . $class . '.php')) {
            include_once $file;

            return;
        }
    }

    $paths[] = __DIR__ . '/../../src/Karaka/';

    $class = \ltrim(\str_replace('Modules/', '/', $class), '/');
    foreach ($paths as $path) {
        if (\is_file($file = $path . $class . '.php')) {
            include_once $file;

            return;
        } elseif (\is_file($file = $path . 'oms-' . $class . '.php')) {
            include_once $file;

            return;
        }
    }
}

\spl_autoload_register('module_autoloader');
