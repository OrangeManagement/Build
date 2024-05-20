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

/*
1. find Api functions that have  a validation function ($val = $)
2. find Test script where this one is getting called
3. Check if invalid check exists
4. If not, add at bottom of file
*/

$modules = \scandir(__DIR__ . '/../../../Modules');

function createFunction($name)
{
    $invalid = <<<HEREDOC

        public function testInvalid{$name}() : void
        {
            \$response = new HttpResponse();
            \$request  = new HttpRequest();

            \$request->header->account = 1;
            \$this->module->{$name}(\$request, \$response);
            self::assertEquals(RequestStatusCode::R_400, \$response->header->status);
        }

    HEREDOC;

    return $invalid;
}

foreach ($modules as $module) {
	if ($module === '..' || $module === '.'
		|| !\is_dir(__DIR__ . '/../../../Modules/' . $module)
		|| !\is_dir(__DIR__ . '/../../../Modules/' . $module . '/Controller')
		|| !\is_file(__DIR__ . '/../../../Modules/' . $module . '/info.json')
        || (!empty($allowed) && !\in_array($module, $allowed))
    ) {
		continue;
	}

    $controllers = \scandir(__DIR__ . '/../../../Modules/' . $module . '/Controller');

	foreach ($controllers as $controller) {
        if (\stripos($controller, 'Api') === false) {
            continue;
        }

        $content = \file_get_contents(__DIR__ . '/../../../Modules/' . $module . '/Controller/' . $controller);

        $matches = [];
        \preg_match_all('/(public function )(.*?)(\()/', $content, $matches);

        $relevantFunction = [];

        foreach ($matches[2] as $match) {
            $stripos  = \stripos($content, 'public function ' . $match);
            $stripos2 = \stripos($content, 'if (!empty($val = ', $stripos);

            if ($stripos2 === false) {
                continue;
            }

            if ($stripos2 - $stripos > 500) {
                continue;
            }

            $relevantFunction[] = $match;
        }

        $tests1 = \is_dir(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller') ? \scandir(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller') : [];
        if ($tests1 === false) {
            $tests1 = [];
        }

        $tests2 = \is_dir(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/Api') ? \scandir(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/Api') : [];
        if ($tests2 === false) {
            $tests2 = [];
        }

        $testFilesContent = [];

        foreach ($tests1 as $file) {
            if ($file === '..' || $file === '.' || !\is_file(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/' . $file)) {
                continue;
            }

            $testFilesContent[__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/' . $file] = \file_get_contents(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/' . $file);
        }

        foreach ($tests2 as $file) {
            if ($file === '..' || $file === '.' || !\is_file(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/Api/' . $file)) {
                continue;
            }

            $testFilesContent[__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/Api/' . $file] = \file_get_contents(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/Api/' . $file);
        }

        $open = [];

        foreach ($testFilesContent as $path => $testFile) {
            foreach ($relevantFunction as $function) {
                $offset = 0;
                $found  = -1;

                if (!isset($open[$function])) {
                    $open[$function] = -1;
                }

                while (($invalidPos = \stripos($testFile, '->' . $function . '(', $offset)) !== false) {
                    $offset = $invalidPos + 1;
                    $found  = 0;

                    $statusPos = \stripos($testFile, 'self::assertEquals(RequestStatusCode::');
                    if ($statusPos !== false && $statusPos - $invalidPos < 250) {
                        $found = 1;

                        $open[$function] = 1;

                        break;
                    }
                }

                if ($found === 0) {
                    echo $function . "\n";
                    $newContent = \createFunction($function);
                    $newContent = \rtrim($testFile, " }\n") . "\n    }\n" . $newContent . "}\n";
                    \file_put_contents($path, $newContent);
                    $open[$function] = 1;
                }
            }
        }

        if (\is_file(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/ApiControllerTest.php')) {
            $testFile = \file_get_contents(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/ApiControllerTest.php');
            foreach ($open as $function => $value) {
                if ($value === 1) {
                    continue;
                }

                echo $function . "\n";
                $newContent = \createFunction($function);
                $newContent = \rtrim($testFile, " }\n") . "\n    }\n" . $newContent . "}\n";
                \file_put_contents($path, $newContent);
                $open[$function] = 1;
            }
        }
    }
}
