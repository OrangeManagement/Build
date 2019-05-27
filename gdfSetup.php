<?php
/**
 * Remove old install and setup database.
 *
 * This script is usefull when you want to manually install the app without resetting an old database/app or new empty database.
 */
ini_set('memory_limit', '2048M');
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once __DIR__ . '/../phpOMS/Autoloader.php';

use Install\WebApplication;
use Model\CoreSettings;
use phpOMS\ApplicationAbstract;
use phpOMS\Dispatcher\Dispatcher;
use phpOMS\Account\Account;
use phpOMS\Account\AccountManager;
use phpOMS\Account\PermissionType;
use phpOMS\DataStorage\Database\DatabasePool;
use phpOMS\DataStorage\Session\HttpSession;
use Modules\Admin\Models\AccountPermission;
use phpOMS\Message\Http\Request;
use phpOMS\Event\EventManager;
use phpOMS\Message\Http\RequestMethod;
use phpOMS\Message\Http\Response;
use phpOMS\Module\ModuleManager;
use phpOMS\Router\Router;
use phpOMS\Uri\Http;
use phpOMS\Utils\TestUtils;

$config   = [
    'db'       => [
        'core' => [
            'masters' => [
                'admin'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => '', /* db login password */
                    'database' => 'oms', /* db name */
                    'prefix'   => 'oms_', /* db table prefix */
                    'weight'   => 1000, /* db table prefix */
                ],
                'insert'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => '', /* db login password */
                    'database' => 'oms', /* db name */
                    'prefix'   => 'oms_', /* db table prefix */
                    'weight'   => 1000, /* db table prefix */
                ],
                'select'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => '', /* db login password */
                    'database' => 'oms', /* db name */
                    'prefix'   => 'oms_', /* db table prefix */
                    'weight'   => 1000, /* db table prefix */
                ],
                'update'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => '', /* db login password */
                    'database' => 'oms', /* db name */
                    'prefix'   => 'oms_', /* db table prefix */
                    'weight'   => 1000, /* db table prefix */
                ],
                'delete'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => '', /* db login password */
                    'database' => 'oms', /* db name */
                    'prefix'   => 'oms_', /* db table prefix */
                    'weight'   => 1000, /* db table prefix */
                ],
                'schema'  => [
                    'db'       => 'mysql', /* db type */
                    'host'     => '127.0.0.1', /* db host address */
                    'port'     => '3306', /* db host port */
                    'login'    => 'root', /* db login name */
                    'password' => '', /* db login password */
                    'database' => 'oms', /* db name */
                    'prefix'   => 'oms_', /* db table prefix */
                    'weight'   => 1000, /* db table prefix */
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
    ]
];

// Reset database
$db = new \PDO($config['db']['core']['masters']['admin']['db'] . ':host=' .
    $config['db']['core']['masters']['admin']['host'],
    $config['db']['core']['masters']['admin']['login'],
    $config['db']['core']['masters']['admin']['password']
);
$db->exec('DROP DATABASE IF EXISTS ' . $config['db']['core']['masters']['admin']['database']);
$db->exec('CREATE DATABASE IF NOT EXISTS ' . $config['db']['core']['masters']['admin']['database']);

$response = new Response();
$request  = new Request(new Http(''));
$request->setMethod(RequestMethod::POST);

$request->setData('dbhost', $config['db']['core']['masters']['admin']['host']);
$request->setData('dbtype', $config['db']['core']['masters']['admin']['db']);
$request->setData('dbport', $config['db']['core']['masters']['admin']['port']);
$request->setData('dbprefix', $config['db']['core']['masters']['admin']['prefix']);
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

$request->setData('orgname', 'GDF GmbH');
$request->setData('adminname', 'admin');
$request->setData('adminpassword', 'orange');
$request->setData('adminemail', 'admin@oms.com');
$request->setData('domain', '127.0.0.1');
$request->setData('websubdir',  $config['page']['root']);
$request->setData('defaultlang', 'en');

WebApplication::installRequest($request, $response);

// Setup for api calls
$app = new class() extends ApplicationAbstract
{
    protected $appName = 'Api';
};

$app->dbPool = new DatabasePool();
$app->dbPool->create('admin', $config['db']['core']['masters']['admin']);
$app->dbPool->create('select', $config['db']['core']['masters']['select']);
$app->dbPool->create('update', $config['db']['core']['masters']['update']);
$app->dbPool->create('insert', $config['db']['core']['masters']['insert']);
$app->dbPool->create('schema', $config['db']['core']['masters']['schema']);

$app->orgId          = 1;
$app->appName        = 'Backend';
$app->accountManager = new AccountManager(new HttpSession());
$app->appSettings    = new CoreSettings($app->dbPool->get());
$app->moduleManager  = new ModuleManager($app, __DIR__ . '/../Modules');
$app->dispatcher     = new Dispatcher($app);
$app->eventManager   = new EventManager($app->dispatcher);
$app->eventManager->importFromFile(__DIR__ . '/../Web/Api/Hooks.php');

$account = new Account();
TestUtils::setMember($account, 'id', 1);

$permission = new AccountPermission();
$permission->setUnit(1);
$permission->setApp('backend');
$permission->setPermission(
    PermissionType::READ
    | PermissionType::CREATE
    | PermissionType::MODIFY
    | PermissionType::DELETE
    | PermissionType::PERMISSION
);

$account->addPermission($permission);

$app->accountManager->add($account);
$app->router = new Router();

/**
 * Install modules
 */
$module = $app->moduleManager->get('Admin');
TestUtils::setMember($module, 'app', $app);

$response = new Response();
$request  = new Request(new Http(''));

$request->getHeader()->setAccount(1);
$request->setData('status', 3);

$request->setData('module', 'Helper');
$module->apiModuleStatusUpdate($request, $response);

/**
 * Setup groups
 */
$module = $app->moduleManager->get('Admin');
TestUtils::setMember($module, 'app', $app);

use Modules\Admin\Models\GroupMapper;
use phpOMS\Account\GroupStatus;

$groups = [
    ['name' => 'Management', 'permissions' => []],
    ['name' => 'Executive', 'permissions' => []],
    ['name' => 'R&D', 'permissions' => []],
    ['name' => 'Sales', 'permissions' => []],
    ['name' => 'Production', 'permissions' => []],
    ['name' => 'Secretariat', 'permissions' => []],
    ['name' => 'HR', 'permissions' => []],
    ['name' => 'Purchasing', 'permissions' => []],
    ['name' => 'QA', 'permissions' => []],
    ['name' => 'QM', 'permissions' => []],
    ['name' => 'Finance', 'permissions' => []],
    ['name' => 'Employee', 'permissions' => [
        'Help' => ['permissionowner' => 1, 'permissionunit' => 1, 'permissionapp' => 'backend', 'permissiontype' => null, 'permissionelement' => null, 'permissioncomponent' => null, 'permissioncreate' => 0, 'permissionread' => 2, 'permissionupdate' => 0, 'permissiondelete' => 0, 'permissionpermission' => 0],
        'Profile' => ['permissionowner' => 1, 'permissionunit' => 1, 'permissionapp' => 'backend', 'permissiontype' => null, 'permissionelement' => null, 'permissioncomponent' => null, 'permissioncreate' => 0, 'permissionread' => 2, 'permissionupdate' => 0, 'permissiondelete' => 0, 'permissionpermission' => 0],
        'Helper' => ['permissionowner' => 1, 'permissionunit' => 1, 'permissionapp' => 'backend', 'permissiontype' => null, 'permissionelement' => null, 'permissioncomponent' => null, 'permissioncreate' => 0, 'permissionread' => 2, 'permissionupdate' => 0, 'permissiondelete' => 0, 'permissionpermission' => 0],
    ]],
    ['name' => 'Controlling', 'permissions' => [
        'Helper' => ['permissionowner' => 1, 'permissionunit' => 1, 'permissionapp' => 'backend', 'permissiontype' => null, 'permissionelement' => null, 'permissioncomponent' => null, 'permissioncreate' => 4, 'permissionread' => 2, 'permissionupdate' => 8, 'permissiondelete' => 16, 'permissionpermission' => 32],
    ]],
];

foreach ($groups as $group) {
    $response = new Response();
    $request  = new Request(new Http(''));

    $request->getHeader()->setAccount(1);
    $request->setData('name', $group['name']);
    $request->setData('status', GroupStatus::ACTIVE);

    $module->apiGroupCreate($request, $response);

    if (!empty($group['permissions'])) {
        $g = $response->get('')['response'];
        foreach ($group['permissions'] as $key => $p) {
            $response = new Response();
            $request  = new Request(new Http(''));

            $request->getHeader()->setAccount(1);
            $request->setData('permissionowner', $p['permissionowner']);
            $request->setData('permissionref', $g->getId());
            $request->setData('permissionunit', $p['permissionunit']);
            $request->setData('permissionapp', $p['permissionapp']);
            $request->setData('permissionmodule', $key);
            $request->setData('permissiontype', $p['permissiontype']);
            $request->setData('permissionelement', $p['permissionelement']);
            $request->setData('permissioncomponent', $p['permissioncomponent']);
            $request->setData('permissioncreate', $p['permissioncreate']);
            $request->setData('permissionread', $p['permissionread']);
            $request->setData('permissionupdate', $p['permissionupdate']);
            $request->setData('permissiondelete', $p['permissiondelete']);
            $request->setData('permissionpermission', $p['permissionpermission']);

            $module->apiAddGroupPermission($request, $response);
        }
    }
}

/**
 * Setup departments
 */
$module = $app->moduleManager->get('Organization');
TestUtils::setMember($module, 'app', $app);

use Modules\Organization\Models\Status;

$departments = [
    ['name' => 'Management', 'parent' => null],
    ['name' => 'R&D', 'parent' => 'Management'],
    ['name' => 'Sales', 'parent' => 'Management'],
    ['name' => 'Production', 'parent' => 'Management'],
    ['name' => 'Warehouse', 'parent' => 'Production'],
    ['name' => 'Secretariat', 'parent' => 'Management'],
    ['name' => 'Registration', 'parent' => 'Management'],
    ['name' => 'HR', 'parent' => 'Management'],
    ['name' => 'Purchasing', 'parent' => 'Management'],
    ['name' => 'QA', 'parent' => 'Management'],
    ['name' => 'QM', 'parent' => 'Management'],
    ['name' => 'Finance', 'parent' => 'Management'],
    ['name' => 'IT', 'parent' => 'Management'],
];
$departmentIds = [];

foreach ($departments as $department) {
    $response = new Response();
    $request  = new Request(new Http(''));

    $request->getHeader()->setAccount(1);
    $request->setData('name', $department['name']);
    $request->setData('status', Status::ACTIVE);
    $request->setData('unit', 1);
    $request->setData('parent', $departmentIds[$department['parent']] ?? null);

    $module->apiDepartmentCreate($request, $response);
    $departmentIds[$department['name']] = $response->get('')['response']->getId();
}

/**
 * Setup positions
 */
$module = $app->moduleManager->get('Organization');
TestUtils::setMember($module, 'app', $app);

use Modules\Organization\Models\DepartmentMapper;

$positions = [
    ['name' => 'Chairman', 'department' => 'Management', 'parent' => null],
    ['name' => 'CEO', 'department' => 'Management', 'parent' => 'Chairman'],
    ['name' => 'Executive Member', 'department' => null, 'parent' => 'Chairman'],
    ['name' => 'COO', 'department' => 'Management', 'parent' => 'CEO'],
    ['name' => 'CTO', 'department' => 'R&D', 'parent' => 'CEO'],
    ['name' => 'R&D Employee', 'department' => 'R&D', 'parent' => 'CTO'],
    ['name' => 'CFO', 'department' => 'Finance', 'parent' => 'CEO'],
    ['name' => 'Accountant', 'department' => 'Finance', 'parent' => 'CFO'],
    ['name' => 'CSO', 'department' => 'Sales', 'parent' => 'CEO'],
    ['name' => 'Export Controle Officer', 'department' => 'Sales', 'parent' => 'CEO'],
    ['name' => 'Back Office Sales', 'department' => 'Sales', 'parent' => 'CSO'],
    ['name' => 'Head of Secretariat', 'department' => 'Secretariat', 'parent' => 'CEO'],
    ['name' => 'Secretary', 'department' => 'Secretariat', 'parent' => 'Head of Secretariat'],
    ['name' => 'Head of Production', 'department' => 'Production', 'parent' => 'CEO'],
    ['name' => 'Production Leader', 'department' => 'Production', 'parent' => 'Head of Production'],
    ['name' => 'Production Section Leader', 'department' => 'Production', 'parent' => 'Head of Production'],
    ['name' => 'Warehouse Section Leader', 'department' => 'Warehouse', 'parent' => 'Head of Production'],
    ['name' => 'Production Employee', 'department' => 'Production', 'parent' => 'Production Section Leader'],
    ['name' => 'Warehouse Employee', 'department' => 'Warehouse', 'parent' => 'Warehouse Section Leader'],
    ['name' => 'Head of Purchasing', 'department' => 'Purchasing', 'parent' => 'CEO'],
    ['name' => 'Back Office Purchasing', 'department' => 'Purchasing', 'parent' => 'Head of Purchasing'],
    ['name' => 'Head of QM', 'department' => 'QM', 'parent' => 'CEO'],
    ['name' => 'QM Employee', 'department' => 'QM', 'parent' => 'Head of QM'],
    ['name' => 'Head of QA', 'department' => 'QA', 'parent' => 'CEO'],
    ['name' => 'QA Employee', 'department' => 'QA', 'parent' => 'Head of QA'],
    ['name' => 'Head of HR', 'department' => 'HR', 'parent' => 'CEO'],
    ['name' => 'HR Employee', 'department' => 'HR', 'parent' => 'Head of HR'],
    ['name' => 'Head of IT', 'department' => 'IT', 'parent' => 'CEO'],
];

$departments = DepartmentMapper::getAll();
$postionIds  = [];
foreach ($positions as $position) {
    $response = new Response();
    $request  = new Request(new Http(''));

    $request->getHeader()->setAccount(1);
    $request->setData('name', $position['name']);
    $request->setData('status', Status::ACTIVE);
    $request->setData('parent', $positionIds[$position['parent']] ?? null);

    foreach ($departments as $d) {
        if (!isset($position['department']) || $d->getName() === $position['department']) {
            $request->setData('department', $d->getId());
            $module->apiPositionCreate($request, $response);

            $positionIds[$position['name']] = $response->get('')['response']->getId();
        }
    }
}

/**
 * Setup accounts
 */
$module = $app->moduleManager->get('Admin');
TestUtils::setMember($module, 'app', $app);

use Modules\Admin\Models\AccountMapper;
use phpOMS\Account\AccountStatus;
use phpOMS\Account\AccountType;

$accounts = [
    [
        'login'  => 'deichhorn',
        'pass'   => 'deichhorn',
        'name1'  => 'Dennis',
        'name2'  => 'Eichhorn',
        'email'  => 'dennis.eichhorn@gdfmbh.com',
        'groups' =>  ['Executive', 'Finance', 'Controlling', 'Employee']
    ]
];

$groups = GroupMapper::getAll();
foreach ($accounts as $account) {
    $response = new Response();
    $request  = new Request(new Http(''));

    $request->getHeader()->setAccount(1);
    $request->setData('login', $account['login']);
    $request->setData('password', $account['pass']);
    $request->setData('name1', $account['name1']);
    $request->setData('name2', $account['name2']);
    $request->setData('email', $account['email']);
    $request->setData('type', AccountType::USER);
    $request->setData('status', AccountStatus::INACTIVE);

    $module->apiAccountCreate($request, $response);

    $a = $response->get('')['response'];
    foreach ($groups as $g) {
        if (\in_array($g->getName(), $account['groups'])) {
            $response = new Response();
            $request  = new Request(new Http(''));

            $request->getHeader()->setAccount($a->getId());
            $request->setData('account', $a->getId());
            $request->setData('igroup-idlist', (string) $g->getId());

            $module->apiAddGroupToAccount($request, $response);
        }
    }
}

/**
 * Setup helper module
 */
