<?php

$postBody = $_POST['payload'] ?? '';
$payload  = json_decode($postBody, true);

if (isset($payload['repository'], $payload['repository']['name']) && $payload['repository']['name'] === 'Orange-Management') {
    shell_exec('./buildProject.sh > /dev/null 2>/dev/null &');

    echo 'Installing';
} else {
    echo 'Invalid payload';
}
