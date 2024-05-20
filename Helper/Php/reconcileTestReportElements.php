<?php
/**
 * Jingga
 *
 * PHP Version 8.2
 *
 * @package   Helper
 * @copyright Dennis Eichhorn
 * @license   OMS License 2.2
 * @version   1.0.0
 * @link      https://jingga.app
 */
declare(strict_types=1);

// Find missing tests + test report bugs

$report = include __DIR__ . '/../../../Build/Config/reportLang.php';

$noTestFile     = [];
$noTestFunction = [];

$noReportFile     = [];
$noReportFunction = [];

$invalidDescription = [];

$lastFileName    = '';
$lastFileContent = '';

foreach ($report as $key => $line) {
	if (\stripos($key, '\tests\\') === false) {
		continue;
	}

	if (\stripos($key, ':') === false) {
		continue;
	} else {
		$parts = \explode(':', $key);

		$file     = \reset($parts);
		$function = \end($parts);

		$file = __DIR__ . '/../../../' . \strtr($file, '\\', '/') . '.php';

		if (!\is_file($file)) {
			$noTestFile[] = $key;

			continue;
		}

		if ($file !== $lastFileName) {
			$lastFileName    = $file;
			$lastFileContent = \file_get_contents($lastFileName);
		}

		if (\stripos($lastFileContent, $function) === false) {
			$noTestFunction[] = $key;
		} elseif (\stripos($lastFileContent, $line['description']) === false) {
			$invalidDescription[] = $key;
		}
	}
}

$noTestFile     = \array_unique($noTestFile);
$noTestFunction = \array_unique($noTestFunction);

echo "\nNo test file:\n";
foreach ($noTestFile as $file) {
	echo $file . "\n";
}

echo "\nNo test function:\n";
foreach ($noTestFunction as $function) {
	echo $function . "\n";
}

echo "\nInvalid test description:\n";
foreach ($invalidDescription as $function) {
	echo $function . "\n";
}

$directories = [
	__DIR__ . '/../../../phpOMS/tests/**/*Test.php',
	__DIR__ . '/../../../Modules/**/tests/**/*Test.php',
];

foreach ($directories as $directory) {
	$files = \glob($directory);
	foreach($files as $file) {
		$fp = \fopen($file, 'r');

		while (!\feof($fp)) {
			$line = \fgets($fp);

			if ($line === false) {
				continue;
			}

			if (\stripos($line, '    public function test') !== 0) {
				continue;
			}

			$end      = \strpos($line, '(');
			$function = \substr($line, 20, $end - 20);

			$name = \substr(\realpath($file), \strlen(\realpath(__DIR__ . '/../../../')) + 1, -4);
			$name = \strtr($name, '/', '\\');

			$reportKey = $name . ':' . $function;

			if (!isset($report[$reportKey])) {
				$noReportFunction[] = $reportKey;
			}
		}
	}
}

echo "\nNo report function:\n";
foreach ($noReportFunction as $function) {
	echo $function . "\n";
}
