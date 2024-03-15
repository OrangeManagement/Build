<?php

$jsonStr = '';
$name = 'ItemPackaging';
$namespace = 'Modules\IteManagement\Models';
$output = __DIR__ . '/../../../' . \str_replace('\\', '/', $namespace) . '/';

//////////// Create Mapper
$mapper = <<< MAPPER
<?php
/**
 * Jingga
 *
 * PHP Version 8.1
 *
 * @package   {$namespace}
 * @copyright Dennis Eichhorn
 * @license   OMS License 2.0
 * @version   1.0.0
 * @link      https://jingga.app
 */
declare(strict_types=1);

namespace {$namespace};

use phpOMS\DataStorage\Database\Mapper\DataMapperFactory;

/**
 * {$name} mapper class.
 *
 * @package {$namespace}
 * @license OMS License 2.0
 * @link    https://jingga.app
 * @since   1.0.0
 *
 * @template T of {$name}
 * @extends DataMapperFactory<T>
 */
final class ItemMapper extends DataMapperFactory
{
    /**
     * Columns.
     *
     * @var array<string, array{name:string, type:string, internal:string, autocomplete?:bool, readonly?:bool, writeonly?:bool, annotations?:array}>
     * @since 1.0.0
     */
    public const COLUMNS = [
        {$columns}
    ];

    /**
     * Primary table.
     *
     * @var string
     * @since 1.0.0
     */
    public const TABLE = '{$table}';

    /**
     * Primary field name.
     *
     * @var string
     * @since 1.0.0
     */
    public const PRIMARYFIELD = '{$primaryfield}';

    /**
     * Has many relation.
     *
     * @var array<string, array{mapper:class-string, table:string, self?:?string, external?:?string, column?:string}>
     * @since 1.0.0
     */
    public const HAS_MANY = [
    ];
}

MAPPER;

\file_put_contents($output . $name . 'Mapper.php', $mapper);

//////////// Create model
$model = <<< MODEL
<?php
/**
 * Jingga
 *
 * PHP Version 8.1
 *
 * @package   {$namespace}
 * @copyright Dennis Eichhorn
 * @license   OMS License 2.0
 * @version   1.0.0
 * @link      https://jingga.app
 */
declare(strict_types=1);

namespace {$namespace};

/**
 * {$name} class.
 *
 * @package {$namespace}
 * @license OMS License 2.0
 * @link    https://jingga.app
 * @since   1.0.0
 */
class {$name} implements \JsonSerializable
{
    {$members}
    /**
     * {@inheritdoc}
     */
    public function toArray() : array
    {
        return [
            'id' => $this->id,
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function jsonSerialize() : mixed
    {
        return $this->toArray();
    }
}

MODEL;

\file_put_contents($output . $name . '.php', $model);

//////////// Create null model
$nullmodel = <<< NULLMODEL
<?php
/**
 * Jingga
 *
 * PHP Version 8.1
 *
 * @package   {$namespace}
 * @copyright Dennis Eichhorn
 * @license   OMS License 2.0
 * @version   1.0.0
 * @link      https://jingga.app
 */
declare(strict_types=1);

namespace {$namespace};

/**
 * Null model
 *
 * @package {$namespace}
 * @license OMS License 2.0
 * @link    https://jingga.app
 * @since   1.0.0
 */
final class Null{$name} extends {$name}
{
    /**
     * Constructor
     *
     * @param int $id Model id
     *
     * @since 1.0.0
     */
    public function __construct(int $id = 0)
    {
        $this->id = $id;
    }

    /**
     * {@inheritdoc}
     */
    public function jsonSerialize() : mixed
    {
        return ['id' => $this->id];
    }
}

NULLMODEL;

\file_put_contents($output . 'Null' . $name . '.php', $nullmodel);