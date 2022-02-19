<?php declare(strict_types=1);
/**
 * Remove old install and setup database.
 *
 * This script is usefull when you want to manually install the app without resetting an old database/app or new empty database.
 */
\ini_set('memory_limit', '2048M');
\ini_set('display_errors', 1);
\ini_set('display_startup_errors', 1);
\error_reporting(\E_ALL);

require_once __DIR__ . '/../phpOMS/Autoloader.php';

use Install\WebApplication;
use phpOMS\Message\Http\HttpRequest;
use phpOMS\Message\Http\HttpResponse;
use phpOMS\Message\Http\RequestMethod;
use phpOMS\Uri\HttpUri;

$config   = [
    'db'       => [
        'core' => [
            'masters' => [
                'admin'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => 'root', /* db login password */
                    'database' => 'oms', /* db name */
                    'weight'   => 1000, /* db table weight */
                ],
                'insert'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => 'root', /* db login password */
                    'database' => 'oms', /* db name */
                    'weight'   => 1000, /* db table weight */
                ],
                'select'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => 'root', /* db login password */
                    'database' => 'oms', /* db name */
                    'weight'   => 1000, /* db table weight */
                ],
                'update'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => 'root', /* db login password */
                    'database' => 'oms', /* db name */
                    'weight'   => 1000, /* db table weight */
                ],
                'delete'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => 'root', /* db login password */
                    'database' => 'oms', /* db name */
                    'weight'   => 1000, /* db table weight */
                ],
                'schema'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => 'root', /* db login password */
                    'database' => 'oms', /* db name */
                    'weight'   => 1000, /* db table weight */
                ],
            ],
        ],
    ],
    'cache' => [
        'redis' => [
            'db'   => 1,
            'host' => '127.0.0.1',
            'port' => 6379,
        ],
        'memcached' => [
            'host' => '127.0.0.1',
            'port' => 11211,
        ],
    ],
    'log'      => [
        'file' => [
            'path' => __DIR__ . '/Logs',
        ],
    ],
    'page'     => [
        'root'  => '/',
        'https' => false,
    ],
    'app'      => [
        'path' => __DIR__,
    ],
    'socket'   => [
        'master' => [
            'host'  => '127.0.0.1',
            'limit' => 300,
            'port'  => 4310,
        ],
    ],
    'language' => [
        'en',
    ],
    'apis'     => [
    ],
];

// Reset database
$db = new \PDO($config['db']['core']['masters']['admin']['db'] . ':host=' .
    $config['db']['core']['masters']['admin']['host'],
    $config['db']['core']['masters']['admin']['login'],
    $config['db']['core']['masters']['admin']['password']
);
$db->exec('DROP DATABASE IF EXISTS ' . $config['db']['core']['masters']['admin']['database']);
$db->exec('CREATE DATABASE IF NOT EXISTS ' . $config['db']['core']['masters']['admin']['database']);
$db = null;

$response = new HttpResponse();
$request  = new HttpRequest(new HttpUri(''));
$request->setMethod(RequestMethod::POST);

$request->setData('dbhost', $config['db']['core']['masters']['admin']['host']);
$request->setData('dbtype', $config['db']['core']['masters']['admin']['db']);
$request->setData('dbport', $config['db']['core']['masters']['admin']['port']);
$request->setData('dbname', $config['db']['core']['masters']['admin']['database']);
$request->setData('schemauser', $config['db']['core']['masters']['admin']['login']);
$request->setData('schemapassword', $config['db']['core']['masters']['admin']['password']);
$request->setData('createuser', $config['db']['core']['masters']['admin']['login']);
$request->setData('createpassword', $config['db']['core']['masters']['admin']['password']);
$request->setData('selectuser', $config['db']['core']['masters']['admin']['login']);
$request->setData('selectpassword', $config['db']['core']['masters']['admin']['password']);
$request->setData('updateuser', $config['db']['core']['masters']['admin']['login']);
$request->setData('updatepassword', $config['db']['core']['masters']['admin']['password']);
$request->setData('deleteuser', $config['db']['core']['masters']['admin']['login']);
$request->setData('deletepassword', $config['db']['core']['masters']['admin']['password']);

$request->setData('orgname', 'Karaka');
$request->setData('adminname', 'admin');
$request->setData('adminpassword', 'orange');
$request->setData('adminemail', 'admin@oms.com');
$request->setData('domain', '127.0.0.1');
$request->setData('websubdir', '/');
$request->setData('defaultlang', 'en');

$request->setData('apps', 'Api');
$request->setData('apps', 'Backend');

WebApplication::installRequest($request, $response);
