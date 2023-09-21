<?php

declare(strict_types=1);

use Rector\CodeQuality\Rector\Class_\CompleteDynamicPropertiesRector;
use Rector\CodeQuality\Rector\Class_\InlineConstructorDefaultToPropertyRector;
use Rector\CodeQuality\Rector\ClassMethod\OptionalParametersAfterRequiredRector;
use Rector\CodeQuality\Rector\Empty_\SimplifyEmptyCheckOnEmptyArrayRector;
use Rector\CodeQuality\Rector\Foreach_\UnusedForeachValueToArrayKeysRector;
use Rector\CodeQuality\Rector\FuncCall\SimplifyRegexPatternRector;
use Rector\CodeQuality\Rector\Identical\FlipTypeControlToUseExclusiveTypeRector;
use Rector\Config\RectorConfig;
use Rector\EarlyReturn\Rector\If_\RemoveAlwaysElseRector;
use Rector\EarlyReturn\Rector\Return_\ReturnBinaryAndToEarlyReturnRector;
use Rector\Set\ValueObject\SetList;

return static function (RectorConfig $rectorConfig): void {
    if (\is_dir(__DIR__ . '/phpOMS')) {
        $rectorConfig->paths([
            __DIR__ . '/Model',
            __DIR__ . '/Modules',
            __DIR__ . '/phpOMS',
        ]);
    } else {
        $rectorConfig->paths([__DIR__]);
    }

    // register a single rule
    $rectorConfig->rule(InlineConstructorDefaultToPropertyRector::class);

    $rectorConfig->sets([
        SetList::CODE_QUALITY,
    ]);

    $rectorConfig->skip([
        SimplifyEmptyCheckOnEmptyArrayRector::class,
        FlipTypeControlToUseExclusiveTypeRector::class,
        UnusedForeachValueToArrayKeysRector::class,
        ReturnBinaryAndToEarlyReturnRector::class,
        SimplifyRegexPatternRector::class,
        RemoveAlwaysElseRector::class,
        OptionalParametersAfterRequiredRector::class,
        RemoveExtraParametersRector::class,
        CompleteDynamicPropertiesRector::class,
    ]);
};
