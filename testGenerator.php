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
$base     = __DIR__ . '/../phpOMS';
$files    = listFolderFiles($base, '.php');
$testBase = __DIR__ . '/../Tests/PHPUnit/Framework';

foreach ($files as $file) {
    $file     = str_replace($base, '', $file);
    $subdir   = trim($file, '/');
    $split    = explode('.', $file);
    $testPath = $testBase . '/' . $split[0] . 'Test.' . $split[1];

    if (stripos($subdir, 'Status.php') === false
        && stripos($subdir, 'Type.php') === false
        && stripos($subdir, 'Layout.php') === false
        && stripos($subdir, 'Level.php') === false
        && stripos($subdir, 'Status') === false
        && stripos($subdir, 'Enum') === false
        && stripos($subdir, 'Null') === false
        && stripos($subdir, 'Interface') === false
        && stripos($subdir, 'Trait') === false
        && stripos($subdir, 'Abstract') === false
    ) {
        if (!file_exists($testPath)) {
            $namespace    = str_replace('/', '\\', $split[0]);
            $namespace    = explode('\\', $namespace);
            $classnameSrc = $namespace[count($namespace) - 1];
            $classname    = $classnameSrc . 'Test';
            unset($namespace[count($namespace) - 1]);
            $use        = trim('phpOMS\\' . trim(implode('\\', $namespace), '\\') . '\\' . $classnameSrc, '\\');
            $namespace  = trim('Tests\PHPUnit\Framework\\' . trim(implode('\\', $namespace), '\\'), '\\');
            $autoloader = str_repeat('/..', count(explode('\\', $namespace)));

            if(!file_exists(dirname($testPAth))) {
                mkdir(dirname($testPath), 0777, true);
            }

            file_put_contents($testPath,
                '<?php' . PHP_EOL
                . '/**' . PHP_EOL
                . ' * Orange Management' . PHP_EOL
                . ' *' . PHP_EOL
                . ' * PHP Version 7.0' . PHP_EOL
                . ' *' . PHP_EOL
                . ' * @category   TBD' . PHP_EOL
                . ' * @package    TBD' . PHP_EOL
                . ' * @author     OMS Development Team <dev@oms.com>' . PHP_EOL
                . ' * @author     Dennis Eichhorn <d.eichhorn@oms.com>' . PHP_EOL
                . ' * @copyright  Dennis Eichhorn' . PHP_EOL
                . ' * @license    OMS License 1.0' . PHP_EOL
                . ' * @version    1.0.0' . PHP_EOL
                . ' * @link       http://orange-management.com' . PHP_EOL
                . ' */' . PHP_EOL
                . '' . PHP_EOL
                . 'namespace ' . $namespace . ';' . PHP_EOL
                . '' . PHP_EOL
                . 'require_once __DIR__ . \'' . $autoloader . '/phpOMS/Autoloader.php\';' . PHP_EOL
                . '' . PHP_EOL
                . 'use ' . $use . ';' . PHP_EOL
                . '' . PHP_EOL
                . 'class ' . $classname . ' extends \PHPUnit_Framework_TestCase' . PHP_EOL
                . '{' . PHP_EOL
                . '    public function testPlaceholder()' . PHP_EOL
	            . '    {' . PHP_EOL
		        . '        self::markTestIncomplete();' . PHP_EOL
	            . '    }' . PHP_EOL
                . '}' . PHP_EOL
            );
        }
    }
}

// JS tests
$base     = __DIR__ . '/../jsOMS';
$files    = listFolderFiles($base, '.js');
$testBase = __DIR__ . '/../Tests/JS/Framework';

foreach ($files as $file) {
    $file     = str_replace($base, '', $file);
    $subdir   = trim($file, '/');
    $split    = explode('.', $file);
    $testPath = $testBase . '/' . $split[0] . 'Test.' . $split[1];

    if (stripos($subdir, 'Status.php') === false
        && stripos($subdir, 'Type.php') === false
        && stripos($subdir, 'Layout.php') === false
        && stripos($subdir, 'Level.php') === false
        && stripos($subdir, 'Status') === false
        && stripos($subdir, 'Enum') === false
        && stripos($subdir, 'Null') === false
        && stripos($subdir, 'Interface') === false
        && stripos($subdir, 'Trait') === false
        && stripos($subdir, 'Abstract') === false
    ) {
        if (!file_exists($testPath)) {
            $name = explode('/', $split[0]);

            if(!file_exists(dirname($testPath))) {
                mkdir(dirname($testPath), 0777, true);
            }

            file_put_contents($testPath,
                'describe(\'' . $name[count($name) - 1] . 'Test\', function ()' . PHP_EOL
                . '{' . PHP_EOL
                . '    "use strict";' . PHP_EOL
                . '' . PHP_EOL
                . '    beforeEach(function ()' . PHP_EOL
                . '    {' . PHP_EOL
                . '    });' . PHP_EOL
                . '' . PHP_EOL
                . '    afterEach(function ()' . PHP_EOL
                . '    {' . PHP_EOL
                . '    });' . PHP_EOL
                . '}' . PHP_EOL
            );
        }
    }
}