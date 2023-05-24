<?php

namespace Build\Helper;

use phpOMS\Message\Http\HttpRequest;
use phpOMS\Message\Http\Rest;
use phpOMS\Uri\HttpUri;

class GptHelper
{
    private const ENDPOINT   = 'https://api.openai.com/v1/chat/completions';
    private const APIKEY     = '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';
    private const MODEL      = 'gpt-3.5-turbo';
    private const TEMPERATUR = 0.9;
    private const MAX_TOKENS = 3096;
    private const MAX_STRLEN = 1500;

    private const LIMIT_REQUEST_PER_MINUTE = 3;
    private const LIMIT_TOKENS_PER_MINUTE  = 40000;

    private static $lastRun = 0;

    public static function defaultFileReader($in, $filename)
    {
        return \fgets($in);
    }

    public static function aiRequest(string $behavior, string $content) : string
    {
        if (\trim($content) === '') {
            return '';
        }

        $requestBody = [
            'model' => self::MODEL,
            'max_tokens' => self::MAX_TOKENS,
            'temperature' => self::TEMPERATUR,
            'messages' => [
                [
                    'role' => 'system',
                    'content' => $behavior,
                ],
                [
                    'role' => 'user',
                    'content' => $content,
                ]
            ]
        ];

        $request = new HttpRequest(new HttpUri(self::ENDPOINT));
        $request->header->set('Authorization', 'Bearer ' . self::APIKEY);
        $request->header->set('Content-Type', 'application/json');
        $request->setMethod('POST');
        $request->fromData($requestBody);

        $time = \time();
        if ($time - self::$lastRun < 61 / self::LIMIT_REQUEST_PER_MINUTE) {
            \sleep(61 / self::LIMIT_REQUEST_PER_MINUTE - ($time - self::$lastRun));
        }

        $response = Rest::request($request);
        self::$lastRun = \time();

        return $response->getBody();
    }

    public static function handleFile(string $inPath, string $outPath, string $behavior, \Closure $fileReader) : string
    {
        $response = '';

        $in    = \fopen($inPath, 'r');
        $out   = \fopen($outPath . ($inPath === $outPath ? '.out' : ''), 'w');
        $lines = '';

        while (($line = $fileReader($in, $inPath)) !== false) {
            if (\strlen($lines) > self::MAX_STRLEN) {
                $response = self::aiRequest($behavior, $lines);

                if ($response === '') {
                    continue;
                }

                $json = \json_decode($response, true);
                \fwrite($out, \str_replace("\n\n", "\n", $json[5][0]['message']['content']));

                $lines = '';
            }

            $lines .= $line . "\n";
        }

        if (\trim($lines) !== '') {
            $response = self::aiRequest($behavior, $lines);

            if ($response !== '') {
                $json = \json_decode($response, true);
                \fwrite($out, \str_replace("\n\n", "\n", $json[5][0]['message']['content']));
            }
        }

        \fwrite($out, "\n");

        \fclose($in);

        if ($outPath === 'php://memory') {
            \rewind($out);
            $response = \stream_get_contents($out);
            \fclose($out);
        }

        \fclose($out);

        return $response;
    }
}
