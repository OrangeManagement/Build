<?php
/**
 * Orange Management
 *
 * PHP Version 8.0
 *
 * @package   Helper
 * @copyright Dennis Eichhorn
 * @license   OMS License 1.0
 * @version   1.0.0
 * @link      https://orange-management.org
 */
declare(strict_types=1);

// Find modules where the Module/tests/Admin/AdminTest.php is missing

$modules = \scandir(__DIR__ . '/../../Modules');

foreach ($modules as $module) {
	if ($module === '..' || $module === '.'
		|| !\is_dir(__DIR__ . '/../../Modules/' . $module)
		|| !\is_file(__DIR__ . '/../../Modules/' . $module . '/info.json'))
	{
		continue;
	}

	if (!\is_file(__DIR__ . '/../../Modules/' . $module . '/tests/Admin/AdminTest.php')) {
		echo $module . "\n";
	}
}
