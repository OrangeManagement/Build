<?php

declare(strict_types=1);

require_once __DIR__ . '/../../../phpOMS/Autoloader.php';

$module = 'Billing';
if ($module === '..' || $module === '.'
    || !\is_dir(__DIR__ . '/../../../Modules/' . $module)
    || !\is_dir(__DIR__ . '/../../../Modules/' . $module . '/Models')
    || !\is_file(__DIR__ . '/../../../Modules/' . $module . '/info.json'))
{
    return;
}

$mappers = \scandir(__DIR__ . '/../../../Modules/' . $module . '/Models');

echo "erDiagram\n";

$indent = 4;

foreach ($mappers as $mapper) {
    if (!\str_ends_with($mapper, 'Mapper.php')) {
        continue;
    }

    $class = '\\Modules\\' . $module . '\\Models\\' . \substr($mapper, 0, -4);

    if (!empty($class::MODEL)
        && \is_file(__DIR__ . '/../../../Modules/' . $module . '/Models/' . \substr($class::MODEL, \strrpos($class::MODEL, '\\') + 1) . 'Mapper.php')
        && \substr($class::MODEL, \strrpos($class::MODEL, '\\') + 1) !== \substr($mapper, 0, -10)
    ) {
        continue;
    }

    echo \str_repeat(' ', $indent), \substr($mapper, 0, -10), " {\n";

    foreach ($class::COLUMNS as $column => $data) {
        echo \str_repeat(' ', $indent + 4), $data['type'], ' ', $data['internal'] . "\n";
    }

    foreach ($class::HAS_MANY as $name => $data) {
        echo \str_repeat(' ', $indent + 4), 'array ', $name . "\n";
    }

    echo \str_repeat(' ', $indent), "}\n";

    foreach ($class::BELONGS_TO as $name => $data) {
        $childMapper = \substr($data['mapper'], \strrpos($data['mapper'], '\\') + 1, -6);

        echo \str_repeat(' ', $indent), \substr($mapper, 0, -10), ' }|--o| ', $childMapper, " : contains\n";
    }

    foreach ($class::OWNS_ONE as $name => $data) {
        $childMapper = \substr($data['mapper'], \strrpos($data['mapper'], '\\') + 1, -6);

        echo \str_repeat(' ', $indent), \substr($mapper, 0, -10), ' }|--o| ', $childMapper, " : contains\n";
    }

    foreach ($class::HAS_MANY as $name => $data) {
        $childMapper = \substr($data['mapper'], \strrpos($data['mapper'], '\\') + 1, -6);

        echo \str_repeat(' ', $indent), \substr($mapper, 0, -10), ' }|--|{ ', $childMapper, " : contains\n";
    }
}
