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
        \$request  = new HttpRequest(new HttpUri(''));

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

        $tests1 = \scandir(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller');
        $tests2 = \scandir(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/Api');

        $testFilesContent = [];

        foreach ($tests1 as $file) {
            if ($file === '..' || $file === '.') {
                continue;
            }

            $testFilesContent[__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/' . $file] = \file_get_contents(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/' . $file);
        }

        foreach ($tests2 as $file) {
            if ($file === '..' || $file === '.') {
                continue;
            }

            $testFilesContent[__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/Api/' . $file] = \file_get_contents(__DIR__ . '/../../../Modules/' . $module . '/tests/Controller/' . $file);
        }

        foreach ($testFilesContent as $path => $testFile) {
            foreach ($relevantFunction as $function) {
                $offset = 0;
                $found  = false;

                while (($invalidPos = \stripos('->' . $function . '(', $testFile, $offset)) !== false) {
                    $offset = $invalidPos + 1;
                    $found  = true;

                    $statusPos = \stripos($testFile, 'self::assertEquals(RequestStatusCode::');
                    if ($statusPos !== false && $statusPos - $invalidPos < 250) {
                        $found = false;

                        break;
                    }
                }

                if ($found) {
                    $newContent = \createFunction($function);
                    $newContent = \rtrim($testFile, " }\n") . "\n    }\n" . $newContent . "}\n";
                    \file_put_contents($path, $newContent);
                }
            }
        }
    }
}
