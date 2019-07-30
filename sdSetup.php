<?php declare(strict_types=1);
/**
 * Remove old install and setup database.
 *
 * This script is usefull when you want to manually install the app without resetting an old database/app or new empty database.
 */
\ini_set('memory_limit', '2048M');
\ini_set('display_errors', '1');
\ini_set('display_startup_errors', '1');
\error_reporting(\E_ALL);

require_once __DIR__ . '/../phpOMS/Autoloader.php';

use Install\WebApplication;
use Model\CoreSettings;
use Model\Settings;
use Modules\Admin\Models\AccountPermission;
use Modules\Admin\Models\GroupMapper;
use Modules\Organization\Models\DepartmentMapper;
use Modules\Organization\Models\Status;
use Modules\News\Models\NewsType;
use Modules\News\Models\NewsStatus;
use phpOMS\Account\Account;
use phpOMS\Account\AccountManager;
use phpOMS\Account\AccountStatus;
use phpOMS\Account\AccountType;
use phpOMS\Account\GroupStatus;
use phpOMS\Account\PermissionOwner;
use phpOMS\Account\PermissionType;
use phpOMS\ApplicationAbstract;
use phpOMS\DataStorage\Database\DatabasePool;
use phpOMS\DataStorage\Session\HttpSession;
use phpOMS\Dispatcher\Dispatcher;
use phpOMS\Event\EventManager;
use phpOMS\Localization\ISO639x1Enum;
use phpOMS\Message\Http\Request;
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

$request->setData('orgname', 'Micerium');
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
$permission->setUnit(2);
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
 * Setup additional units
 */
$module = $app->moduleManager->get('Organization');
TestUtils::setMember($module, 'app', $app);

$response = new Response();
$request  = new Request(new Http(''));

$request->getHeader()->setAccount(1);
$request->setData('name', 'Schütz Dental GmbH');
$request->setData('parent', 1);
$request->setData('status', 1);

$module->apiUnitCreate($request, $response);

/**
 * Change app settings
 */
$module = $app->moduleManager->get('Admin');
TestUtils::setMember($module, 'app', $app);

$response = new Response();
$request  = new Request(new Http(''));

$request->getHeader()->setAccount(1);
$request->setData('settings', \json_encode([Settings::DEFAULT_ORGANIZATION => '2']));

$module->apiSettingsSet($request, $response);

/**
 * Install modules
 */
$module = $app->moduleManager->get('Admin');
TestUtils::setMember($module, 'app', $app);

$response = new Response();
$request  = new Request(new Http(''));
$request->getHeader()->setAccount(1);
$request->setData('status', 3);

// Helper
$request->setData('module', 'Helper');
$module->apiModuleStatusUpdate($request, $response);

// Search
$request->setData('module', 'Search');
$module->apiModuleStatusUpdate($request, $response);

// Dashboard
$request->setData('module', 'Dashboard');
$module->apiModuleStatusUpdate($request, $response);

// Tasks
$request->setData('module', 'Tasks');
$module->apiModuleStatusUpdate($request, $response);

// Message
$request->setData('module', 'Message');
$module->apiModuleStatusUpdate($request, $response);

// Calendar
$request->setData('module', 'Calendar');
$module->apiModuleStatusUpdate($request, $response);

// Editor
$request->setData('module', 'Editor');
$module->apiModuleStatusUpdate($request, $response);

// Checklist
$request->setData('module', 'Checklist');
$module->apiModuleStatusUpdate($request, $response);

// News
$request->setData('module', 'News');
$module->apiModuleStatusUpdate($request, $response);

// Profile
$request->setData('module', 'Profile');
$module->apiModuleStatusUpdate($request, $response);

// Kanban
$request->setData('module', 'Kanban');
$module->apiModuleStatusUpdate($request, $response);

// Workflow
$request->setData('module', 'Workflow');
$module->apiModuleStatusUpdate($request, $response);

// HumanResourceManagement
$request->setData('module', 'HumanResourceManagement');
$module->apiModuleStatusUpdate($request, $response);

// HumanResourceManagement
$request->setData('module', 'HumanResourceTimeRecording');
$module->apiModuleStatusUpdate($request, $response);

// Support
$request->setData('module', 'Support');
$module->apiModuleStatusUpdate($request, $response);

// ClientManagement
$request->setData('module', 'ClientManagement');
$module->apiModuleStatusUpdate($request, $response);

// SupplierManagement
$request->setData('module', 'SupplierManagement');
$module->apiModuleStatusUpdate($request, $response);

// ItemManagement
$request->setData('module', 'ItemManagement');
$module->apiModuleStatusUpdate($request, $response);

// Billling
$request->setData('module', 'Billling');
$module->apiModuleStatusUpdate($request, $response);

// InvoiceManagement
$request->setData('module', 'InvoiceManagement');
$module->apiModuleStatusUpdate($request, $response);

// WarehouseManagement
$request->setData('module', 'WarehouseManagement');
$module->apiModuleStatusUpdate($request, $response);

// StockTaking
$request->setData('module', 'StockTaking');
$module->apiModuleStatusUpdate($request, $response);

// QualityManagement
$request->setData('module', 'QualityManagement');
$module->apiModuleStatusUpdate($request, $response);

// AssetManagement
$request->setData('module', 'AssetManagement');
$module->apiModuleStatusUpdate($request, $response);

// Marketing
$request->setData('module', 'Marketing');
$module->apiModuleStatusUpdate($request, $response);

/**
 * Setup groups
 */
$module = $app->moduleManager->get('Admin');
TestUtils::setMember($module, 'app', $app);

$groups = [
    ['name' => 'beta_tester', 'permissions' => [
        [
            'module' => 'News',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'backend',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 8,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
        [
            'module' => 'News',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'api',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 8,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
    ]],
    ['name' => 'Management', 'permissions' => []],
    ['name' => 'Executive', 'permissions' => []],
    ['name' => 'R&D', 'permissions' => []],
    ['name' => 'Sales', 'permissions' => []],
    ['name' => 'Service', 'permissions' => []],
    ['name' => 'Support', 'permissions' => []],
    ['name' => 'Secretariat', 'permissions' => [
        [
            'module' => 'News',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'backend',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 8,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
        [
            'module' => 'News',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'api',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 8,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
    ]],
    ['name' => 'HR', 'permissions' => []],
    ['name' => 'Purchasing', 'permissions' => []],
    ['name' => 'QA', 'permissions' => []],
    ['name' => 'QM', 'permissions' => []],
    ['name' => 'IT', 'permissions' => []],
    ['name' => 'Marketing', 'permissions' => []],
    ['name' => 'Warehouse', 'permissions' => []],
    ['name' => 'Registration', 'permissions' => []],
    ['name' => 'Finance', 'permissions' => []],
    ['name' => 'Employee', 'permissions' => [
        [
            'module' => 'Help',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'backend',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 0,
            'permissionread' => 2,
            'permissionupdate' => 0,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
        [
            'module' => 'Dashboard',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'backend',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 0,
            'permissionread' => 2,
            'permissionupdate' => 0,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
        [
            'module' => 'Profile',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'backend',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 0,
            'permissionread' => 2,
            'permissionupdate' => 0,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
        [
            'module' => 'Media',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'backend',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 0,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
        [
            'module' => 'Media',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'api',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 8,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
        [
            'module' => 'Tasks',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'backend',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 0,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
        [
            'module' => 'Tasks',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'api',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 0,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
        [
            'module' => 'Helper',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'backend',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 0,
            'permissionread' => 2,
            'permissionupdate' => 0,
            'permissiondelete' => 0,
            'permissionpermission' => 0,
        ],
    ]],
    ['name' => 'Controlling', 'permissions' => [
        [
            'module' => 'Helper',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'backend',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 8,
            'permissiondelete' => 16,
            'permissionpermission' => 32,
        ],
        [
            'module' => 'Helper',
            'permissionowner' => PermissionOwner::GROUP,
            'permissionunit' => 2,
            'permissionapp' => 'api',
            'permissiontype' => null,
            'permissionelement' => null,
            'permissioncomponent' => null,
            'permissioncreate' => 4,
            'permissionread' => 2,
            'permissionupdate' => 8,
            'permissiondelete' => 16,
            'permissionpermission' => 32,
        ],
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
            $request->setData('permissionmodule', $p['module']);
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

$departments = [
    ['name' => 'Management', 'parent' => null],
    ['name' => 'R&D', 'parent' => 'Management'],
    ['name' => 'Sales', 'parent' => 'Management'],
    ['name' => 'Service', 'parent' => 'Management'],
    ['name' => 'Support', 'parent' => 'Management'],
    ['name' => 'Purchase', 'parent' => 'Management'],
    ['name' => 'Warehouse', 'parent' => 'Purchase'],
    ['name' => 'Secretariat', 'parent' => 'Management'],
    ['name' => 'Registration', 'parent' => 'Management'],
    ['name' => 'HR', 'parent' => 'Management'],
    ['name' => 'Purchasing', 'parent' => 'Management'],
    ['name' => 'QA', 'parent' => 'Management'],
    ['name' => 'QM', 'parent' => 'Management'],
    ['name' => 'Finance', 'parent' => 'Management'],
    ['name' => 'Marketing', 'parent' => 'Management'],
    ['name' => 'IT', 'parent' => 'Management'],
];
$departmentIds = [];

foreach ($departments as $department) {
    $response = new Response();
    $request  = new Request(new Http(''));

    $request->getHeader()->setAccount(1);
    $request->setData('name', $department['name']);
    $request->setData('status', Status::ACTIVE);
    $request->setData('unit', 2);
    $request->setData('parent', $departmentIds[$department['parent']] ?? null);

    $module->apiDepartmentCreate($request, $response);
    $departmentIds[$department['name']] = $response->get('')['response']->getId();
}

/**
 * Setup positions
 */
$module = $app->moduleManager->get('Organization');
TestUtils::setMember($module, 'app', $app);

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
    ['name' => 'Head of Service', 'department' => 'Service', 'parent' => 'CEO'],
    ['name' => 'Service Employee', 'department' => 'Service', 'parent' => 'Head of Service'],
    ['name' => 'Head of Support', 'department' => 'Support', 'parent' => 'CEO'],
    ['name' => 'Support Employee', 'department' => 'Support', 'parent' => 'Head of Support'],
    ['name' => 'Head of Warehouse', 'department' => 'Warehouse', 'parent' => 'Head of Production'],
    ['name' => 'Warehouse Employee', 'department' => 'Warehouse', 'parent' => 'Head of Warehouse'],
    ['name' => 'Head of Purchasing', 'department' => 'Purchasing', 'parent' => 'CEO'],
    ['name' => 'Back Office Purchasing', 'department' => 'Purchasing', 'parent' => 'Head of Purchasing'],
    ['name' => 'Head of QM', 'department' => 'QM', 'parent' => 'CEO'],
    ['name' => 'QM Employee', 'department' => 'QM', 'parent' => 'Head of QM'],
    ['name' => 'Head of QA', 'department' => 'QA', 'parent' => 'CEO'],
    ['name' => 'QA Employee', 'department' => 'QA', 'parent' => 'Head of QA'],
    ['name' => 'Head of HR', 'department' => 'HR', 'parent' => 'CEO'],
    ['name' => 'HR Employee', 'department' => 'HR', 'parent' => 'Head of HR'],
    ['name' => 'Head of IT', 'department' => 'IT', 'parent' => 'CEO'],
    ['name' => 'IT Employee', 'department' => 'IT', 'parent' => 'Head of IT'],
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
            break;
        }
    }
}

/**
 * Setup accounts
 */
$module = $app->moduleManager->get('Admin');
TestUtils::setMember($module, 'app', $app);

$accounts = [
    [
        'login'  => 'deichhorn',
        'pass'   => 'deichhorn',
        'name1'  => 'Dennis',
        'name2'  => 'Eichhorn',
        'email'  => 'dennis.eichhorn@gdfmbh.com',
        'groups' =>  ['Executive', 'Finance', 'Controlling', 'Employee', 'beta_tester'],
    ],
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
 * Setup dashboard module
 */
$module = $app->moduleManager->get('Dashboard');
TestUtils::setMember($module, 'app', $app);

$response = new Response();
$request  = new Request(new Http(''));

$request->getHeader()->setAccount(1);
$request->setData('title', 'TestBoard');
$module->apiBoardCreate($request, $response);

$request->setData('board', 1);
$request->setData('order', 1);
$request->setData('module', 'News');
$module->apiComponentCreate($request, $response);

$request->setData('order', 2);
$request->setData('module', 'Tasks');
$module->apiComponentCreate($request, $response);

$request->setData('order', 3);
$request->setData('module', 'Message');
$module->apiComponentCreate($request, $response);

$request->setData('order', 4);
$request->setData('module', 'Calendar');
$module->apiComponentCreate($request, $response);

/**
 * Setup helper module
 */

 /**
 * Setup news module
 */
$module = $app->moduleManager->get('News');
TestUtils::setMember($module, 'app', $app);

$response = new Response();
$request  = new Request(new Http(''));

$request->getHeader()->setAccount(2);
$request->setData('publish', 'now');
$request->setData('title', 'Welcome beta testers!');
$request->setData('plain',
    "I'm proud to announce that the very first version of the new intranet of Micerium/Schütz is now in private beta."
    . "\n\nFor the private beta only a couple of people have access to it and can use/test it. For those of you who are in this private beta test phase your frustration will be worth it on our ride to improve the system over time. Your feedback is well appreciated and will be implemented whenever possible. Please note that especially in the beginning a lot of things remain to be implemented and fixed and therefore it may take some time to serve all of your feedback justice."
    . "\n\nThe goal of this new intranet is to unify all the different IT systems the company currently uses into one. As a result we hope to reduce the workload of all employees and frustration of dealing with multiple software solutions. Of course this new intranet will not be able to solve all problems in the very beginning but over time we hope to modernize and simplify our workflows."
    . "\n\nAll the data which is created during the private beta phase will remain even once we go into public beta. Please note that every beta user is part of the **beta_tester** group. Some things will only be made visiable and created for the **beta_tester** group. This means once we go into public beta and into the release later on these things will only remain visible to beta testers. Examples are news articles like this one, some tasks/todos and more which will be specifically targeted to beta testers. Of course some of the data created during the beta test phase will be also visible to all other employees in the public beta or after the release."
    . "\n\nIf you find bugs or feature requests please do so in the [support/ticket](support/list) module. All issues created during the beta test should be created with the **private_beta** tag and for the **beta_tester** group. These issues will then be visible to all beta testers and allows all beta testers to see the progress which is made and also avoids duplicated bug reports or feature requests. Additionally all beta testers will be able to comment on bugs and feature requests."
    . "\n\nI'm looking forward to your help and support."
    . "\n\n## Information"
    . "\n\nBelow please find a summary of important information which may be helpful for you:"
    . "\n\n* Messages and calendar events in this intranet and your outlook are synchronized once a day at midnight. Of course messages and calendar events created in the intranet are shown immediately in the intranet (but only after midnight in outlook)"
    . "\n* Invoices from the ERP system are imported once a day at midnight but invoices created in this intranet cannot be exported to the ERP!"
    . "\n* Documents, customer reports and phone notes of customers are imported from the CRM once a day at midnight but cannot be exported to the CRM!"
);
$request->setData('type', NewsType::ARTICLE);
$request->setData('status', NewsStatus::VISIBLE);
$request->setData('featured', true);
$request->setData('lang', ISO639x1Enum::_EN);
$module->apiNewsCreate($request, $response);