<?php
/**
 * Karaka
 *
 * PHP Version 8.1
 *
 * Inspect .lang.php files and check them for errors/optimization
 *
 * @package   Modules\HumanResourceManagement
 * @copyright Dennis Eichhorn
 * @license   OMS License 2.0
 * @version   1.0.0
 * @link      https://jingga.app
 */
declare(strict_types=1);

function printUsage() : void
{
    echo 'Usage: -d <DESTINATION_PATH> -m <PATH>' . "\n\n";
    echo "\t" . '-d Destination/output directory.' . "\n";
    echo "\t" . '-m Module directory.' . "\n";
}

$destination = ($key = \array_search('-d', $argv)) === false || $key === \count($argv) - 1 ? null : \trim($argv[$key + 1], '" ');
$modulePath  = ($key = \array_search('-m', $argv)) === false || $key === \count($argv) - 1 ? null : \trim($argv[$key + 1], '" ');

if (!isset($destination) || !isset($modulePath)) {
    \printUsage();

    return;
}

$sources = new \RecursiveIteratorIterator(new \RecursiveDirectoryIterator($modulePath));
$tpls    = [];
$langs   = [];

foreach ($sources as $source) {
    if ($source->isFile()
        && (($temp = \strlen($source->getPathname()) - \strlen('tpl.php')) >= 0 && \strpos($source->getPathname(), 'tpl.php', $temp) !== false)
    ) {
        $tpls[] = $source->getPathname();
    } elseif ($source->isFile()
        && (($temp = \strlen($source->getPathname()) - \strlen('lang.php')) >= 0 && \strpos($source->getPathname(), 'lang.php', $temp) !== false)
        && \strlen(\explode('.', \basename($source->getPathname()))[0]) === 2
    ) {
        $langFileContent                                            = include $source->getPathname();
        $langs[\explode('.', \basename($source->getPathname()))[0]] = \end($langFileContent);
    }
}

// Compare language files
$length         = 0;
$unequalLength  = false;
$unusedLanguage = [];

foreach($langs as $lang => $data) {
    if ($length === 0) {
        $length         = \count($data);
        $unusedLanguage = \array_keys($data);
    }

    if ($length !== \count($data)) {
        $unequalLength = true;
    }

    foreach ($tpls as $tpl) {
        $fileContent = \file_get_contents($tpl);

        foreach ($data as $key => $word) {
            if (\stripos($fileContent, '$this->getHtml(\'' . $key . '\')') !== false
                && ($key = \array_search($key, $unusedLanguage)) !== false
            ) {
                unset($unusedLanguage[$key]);
            }
        }
    }
}

echo 'Language files have different length: ' . ($unequalLength ? 'yes' : 'no') . "\n";
echo 'Unused language components: ' . "\n";
\var_dump($unusedLanguage);
