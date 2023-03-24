<?php
/**
 * Karaka
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

// Find null models with no null model test and creates the tests

$modules = \scandir(__DIR__ . '/../../Modules');

foreach ($modules as $module) {
	if ($module === '..' || $module === '.'
		|| !\is_dir(__DIR__ . '/../../Modules/' . $module)
		|| !\is_dir(__DIR__ . '/../../Modules/' . $module . '/Models')
		|| !\is_file(__DIR__ . '/../../Modules/' . $module . '/info.json'))
	{
		continue;
	}

	$models = \scandir(__DIR__ . '/../../Modules/' . $module . '/Models');

	foreach ($models as $model) {
		if ($model === '..' || $model === '.'
			|| \stripos($model, 'Null') !== 0
		) {
			continue;
		}

		if (\stripos($model, '.php') === false) {
			throw \Exception('invalid substr');
		}

		$model = \substr($model, 4, -4); // remove Null and .php from string

		if (empty($model)) {
			throw \Exception('invalid substr');
		}

		if (!\is_file(__DIR__ . '/../../Modules/' . $module . '/tests/Models/Null' . $model . 'Test.php')) {
			echo $module . ': Null' . $model . "\n";

			if (!\is_dir(__DIR__ . '/../../Modules/' . $module . '/tests')) {
				\mkdir(__DIR__ . '/../../Modules/' . $module . '/tests');
			}

			if (!\is_dir(__DIR__ . '/../../Modules/' . $module . '/tests/Models')) {
				\mkdir(__DIR__ . '/../../Modules/' . $module . '/tests/Models');
			}

			$test = '<?php' . "\n"
				. '/**' . "\n"
				. ' * Karaka' . "\n"
				. ' *' . "\n"
				. ' * PHP Version 8.1' . "\n"
				. ' *' . "\n"
				. ' * @package   tests' . "\n"
				. ' * @copyright Dennis Eichhorn' . "\n"
				. ' * @license   OMS License 2.0' . "\n"
				. ' * @version   1.0.0' . "\n"
				. ' * @link      https://jingga.app' . "\n"
				. ' */' . "\n"
				. 'declare(strict_types=1);' . "\n"
				. "\n"
				. 'namespace Modules\\' . $module . '\\tests\Models;' . "\n"
				. "\n"
				. 'use Modules\\' . $module . '\Models\Null' . $model . ';' . "\n"
				. "\n"
				. '/**' . "\n"
				. ' * @internal' . "\n"
				. ' */' . "\n"
				. 'final class Null' . $model . 'Test extends \PHPUnit\Framework\TestCase' . "\n"
				. '{' . "\n"
				. '    /**' . "\n"
				. '     * @covers Modules\\' . $module . '\Models\Null' . $model . '' . "\n"
				. '     * @group framework' . "\n"
				. '     */' . "\n"
				. '    public function testNull() : void' . "\n"
				. '    {' . "\n"
				. '        self::assertInstanceOf(\'\Modules\\' . $module . '\Models\\' . $model . '\', new Null' . $model . '());' . "\n"
				. '    }' . "\n"
				. "\n"
				. '    /**' . "\n"
				. '     * @covers Modules\\' . $module . '\Models\Null' . $model . '' . "\n"
				. '     * @group framework' . "\n"
				. '     */' . "\n"
				. '    public function testId() : void' . "\n"
				. '    {' . "\n"
				. '        $null = new Null' . $model . '(2);' . "\n"
				. '        self::assertEquals(2, $null->getId());' . "\n"
				. '    }' . "\n"
				. '}' . "\n";

			\file_put_contents(__DIR__ . '/../../Modules/' . $module . '/tests/Models/Null' . $model . 'Test.php', $test);
		}
	}
}
