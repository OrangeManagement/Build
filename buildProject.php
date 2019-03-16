<?php

$postBody = $_POST['payload'] ?? '';
$payload  = \json_decode($postBody, true);

if (isset($payload['organization'], $payload['organization']['login']) && $payload['organization']['login'] === 'Orange-Management') {
    shell_exec('./buildProject.sh > /dev/null 2>/dev/null &');

    echo 'Installing';
} else {
    echo 'Invalid payload';
}
