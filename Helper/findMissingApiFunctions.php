<?php
/**
 * Jingga
 *
 * PHP Version 8.1
 *
 * @package   Helper
 * @copyright Dennis Eichhorn
 * @license   OMS License 2.0
 * @version   1.0.0
 * @link      https://jingga.app
 */
declare(strict_types=1);

// Find modules where the Module/tests/Admin/AdminTest.php is missing

$modules = \scandir(__DIR__ . '/../../Modules');

foreach ($modules as $module) {
	if ($module === '..' || $module === '.'
		|| !\is_dir(__DIR__ . '/../../Modules/' . $module)
		|| !\is_dir(__DIR__ . '/../../Modules/' . $module . '/Controller')
		|| !\is_file(__DIR__ . '/../../Modules/' . $module . '/info.json'))
	{
		continue;
	}

    $controllers = \scandir(__DIR__ . '/../../Modules/' . $module . '/Controller');

	foreach ($controllers as $controller) {
        if (\stripos($controller, 'Api') === false) {
            continue;
        }

        $content = \file_get_contents(__DIR__ . '/../../Modules/' . $module . '/Controller/' . $controller);

        $matches = [];
        \preg_match_all('/(public function )(.*?)(\()/', $content, $matches);

        $create = [];
        $update = [];
        $delete = [];

        foreach ($matches[2] as $match) {
            if (\strpos($match, 'event') !== false || \strpos($match, 'api') !== 0) {
                continue;
            }

            if (\strpos($match, 'Create') !== false || \strpos($match, 'Add') !== false) {
                $create[] = $match;
            } elseif (\strpos($match, 'Update') !== false || \strpos($match, 'Change') !== false) {
                $update[] = $match;
            } elseif (\strpos($match, 'Delete') !== false || \strpos($match, 'Remove') !== false) {
                $delete[] = $match;
            }
        }

        $missing = [];
        foreach ($create as $c) {
            $nUpdate1 = \str_replace(['Create', 'Add'], 'Update', $c);
            $nUpdate2 = \str_replace(['Create', 'Add'], 'Change', $c);
            if (!\in_array($nUpdate1, $update) && !\in_array($nUpdate2, $update)) {
                $missing[] = $nUpdate1;
            }

            $nDelete1 = \str_replace(['Create', 'Add'], 'Delete', $c);
            $nDelete2 = \str_replace(['Create', 'Add'], 'Remove', $c);
            if (!\in_array($nDelete1, $delete) && !\in_array($nDelete2, $delete)) {
                $missing[] = $nDelete1;
            }
        }

        foreach ($update as $u) {
            $nCreate1 = \str_replace(['Create', 'Add'], 'Update', $u);
            $nCreate2 = \str_replace(['Create', 'Add'], 'Change', $u);
            if (!\in_array($nCreate1, $create) && !\in_array($nCreate2, $create)) {
                $missing[] = $nCreate1;
            }

            $nDelete1 = \str_replace(['Update', 'Change'], 'Delete', $u);
            $nDelete2 = \str_replace(['Update', 'Change'], 'Remove', $u);
            if (!\in_array($nDelete1, $delete) && !\in_array($nDelete2, $delete)) {
                $missing[] = $nDelete1;
            }
        }

        foreach ($delete as $d) {
            $nCreate1 = \str_replace(['Create', 'Add'], 'Update', $d);
            $nCreate2 = \str_replace(['Create', 'Add'], 'Change', $d);
            if (!\in_array($nCreate1, $create) && !\in_array($nCreate2, $create)) {
                $missing[] = $nCreate1;
            }

            $nUpdate1 = \str_replace(['Create', 'Add'], 'Update', $d);
            $nUpdate2 = \str_replace(['Create', 'Add'], 'Change', $d);
            if (!\in_array($nUpdate1, $update) && !\in_array($nUpdate2, $update)) {
                $missing[] = $nUpdate1;
            }
        }

        if (!empty($missing)) {
            echo "\nMissing functions \"" . $module . "\": \n";
        }

        foreach ($missing as $m) {
            echo $m . "\n";
        }
    }
}
