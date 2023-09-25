<?php

declare(strict_types=1);

use Rector\CodeQuality\Rector\Array_\CallableThisArrayToAnonymousFunctionRector;
use Rector\CodeQuality\Rector\Class_\CompleteDynamicPropertiesRector;
use Rector\CodeQuality\Rector\Class_\InlineConstructorDefaultToPropertyRector;
use Rector\CodeQuality\Rector\ClassMethod\LocallyCalledStaticMethodToNonStaticRector;
use Rector\CodeQuality\Rector\ClassMethod\OptionalParametersAfterRequiredRector;
use Rector\CodeQuality\Rector\Concat\JoinStringConcatRector;
use Rector\CodeQuality\Rector\Empty_\SimplifyEmptyCheckOnEmptyArrayRector;
use Rector\CodeQuality\Rector\Foreach_\UnusedForeachValueToArrayKeysRector;
use Rector\CodeQuality\Rector\FuncCall\SimplifyRegexPatternRector;
use Rector\CodeQuality\Rector\FunctionLike\SimplifyUselessVariableRector;
use Rector\CodeQuality\Rector\Identical\FlipTypeControlToUseExclusiveTypeRector;
use Rector\CodeQuality\Rector\If_\SimplifyIfNotNullReturnRector;
use Rector\CodeQuality\Rector\Isset_\IssetOnPropertyObjectToPropertyExistsRector;
use Rector\CodeQuality\Rector\Switch_\SingularSwitchToIfRector;
use Rector\Config\RectorConfig;
use Rector\EarlyReturn\Rector\If_\RemoveAlwaysElseRector;
// use Rector\EarlyReturn\Rector\Return_\ReturnBinaryAndToEarlyReturnRector;
use Rector\Php71\Rector\FuncCall\RemoveExtraParametersRector;
use Rector\Set\ValueObject\SetList;
use Rector\Strict\Rector\Empty_\DisallowedEmptyRuleFixerRector;

return static function (RectorConfig $rectorConfig) : void {
    $base = '';

    if (\is_dir(__DIR__ . '/phpOMS')) {
        $rectorConfig->paths([
            __DIR__ . '/Model',
            __DIR__ . '/Modules',
            __DIR__ . '/phpOMS',
        ]);

        $base = __DIR__;
    } elseif (\is_dir(__DIR__ . '/../../phpOMS')) {
        $rectorConfig->paths([
            __DIR__ . '/../../Model',
            __DIR__ . '/../../Modules',
            __DIR__ . '/../../phpOMS',
        ]);

        $base = __DIR__ . '/../..';
    } elseif (\is_dir(__DIR__ . '/../../tests')) {
        $rectorConfig->paths([__DIR__ . '/../..']);

        $base = __DIR__ . '/../..';
    } else {
        $rectorConfig->paths([__DIR__]);

        $base = __DIR__;
    }

    // register a single rule
    $rectorConfig->rule(InlineConstructorDefaultToPropertyRector::class);

    $rectorConfig->sets([
        SetList::CODE_QUALITY,
    ]);

    $rectorConfig->skip([
        $base . '/vendor',
        $base . '/Build',
        $base . '/Resources',
        SimplifyEmptyCheckOnEmptyArrayRector::class,
        FlipTypeControlToUseExclusiveTypeRector::class,
        UnusedForeachValueToArrayKeysRector::class,
        // ReturnBinaryAndToEarlyReturnRector::class,
        JoinStringConcatRector::class,
        LocallyCalledStaticMethodToNonStaticRector::class,
        SimplifyRegexPatternRector::class,
        IssetOnPropertyObjectToPropertyExistsRector::class,
        DisallowedEmptyRuleFixerRector::class,
        RemoveAlwaysElseRector::class,
        CallableThisArrayToAnonymousFunctionRector::class,
        OptionalParametersAfterRequiredRector::class,
        RemoveExtraParametersRector::class,
        CompleteDynamicPropertiesRector::class,
        SingularSwitchToIfRector::class,
        SimplifyIfNotNullReturnRector::class,
        SimplifyUselessVariableRector::class => [
            $base . '/phpOMS/Utils/ColorUtils.php',
            $base . '/Utils/ColorUtils.php',
        ],
    ]);
};
