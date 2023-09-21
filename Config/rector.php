<?php

declare(strict_types=1);

use Rector\CodeQuality\Rector\Class_\CompleteDynamicPropertiesRector;
use Rector\CodeQuality\Rector\Class_\InlineConstructorDefaultToPropertyRector;
use Rector\CodeQuality\Rector\ClassMethod\OptionalParametersAfterRequiredRector;
use Rector\CodeQuality\Rector\Concat\JoinStringConcatRector;
use Rector\CodeQuality\Rector\Empty_\SimplifyEmptyCheckOnEmptyArrayRector;
use Rector\CodeQuality\Rector\Foreach_\UnusedForeachValueToArrayKeysRector;
use Rector\CodeQuality\Rector\FuncCall\SimplifyRegexPatternRector;
use Rector\CodeQuality\Rector\Identical\FlipTypeControlToUseExclusiveTypeRector;
use Rector\Config\RectorConfig;
use Rector\EarlyReturn\Rector\If_\RemoveAlwaysElseRector;
// use Rector\EarlyReturn\Rector\Return_\ReturnBinaryAndToEarlyReturnRector;
use Rector\Php71\Rector\FuncCall\RemoveExtraParametersRector;
use Rector\Set\ValueObject\SetList;
use Rector\Strict\Rector\Empty_\DisallowedEmptyRuleFixerRector;

return static function (RectorConfig $rectorConfig): void {
    if (\is_dir(__DIR__ . '/phpOMS')) {
        $rectorConfig->paths([
            __DIR__ . '/Model',
            __DIR__ . '/Modules',
            __DIR__ . '/phpOMS',
        ]);
    } elseif (\is_dir(__DIR__ . '/../../phpOMS')) {
        $rectorConfig->paths([
            __DIR__ . '/../../Model',
            __DIR__ . '/../../Modules',
            __DIR__ . '/../../phpOMS',
        ]);
    } elseif (\is_dir(__DIR__ . '/../../tests')) {
        $rectorConfig->paths([__DIR__ . '/../..']);
    } else {
        $rectorConfig->paths([__DIR__]);
    }

    // register a single rule
    $rectorConfig->rule(InlineConstructorDefaultToPropertyRector::class);

    $rectorConfig->sets([
        SetList::CODE_QUALITY,
    ]);

    $rectorConfig->skip([
        __DIR__ . '/vendor',
        __DIR__ . '/../../vendor',
        __DIR__ . '/Build',
        __DIR__ . '/../../Build',
        SimplifyEmptyCheckOnEmptyArrayRector::class,
        FlipTypeControlToUseExclusiveTypeRector::class,
        UnusedForeachValueToArrayKeysRector::class,
        // ReturnBinaryAndToEarlyReturnRector::class,
        JoinStringConcatRector::class,
        SimplifyRegexPatternRector::class,
        DisallowedEmptyRuleFixerRector::class,
        RemoveAlwaysElseRector::class,
        OptionalParametersAfterRequiredRector::class,
        RemoveExtraParametersRector::class,
        CompleteDynamicPropertiesRector::class,
    ]);
};
