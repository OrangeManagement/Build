const {By,Key,Builder} = require("selenium-webdriver");
const chrome = require('selenium-webdriver/chrome');

let fs = require('fs');
let path = require('path');

const delay = ms => new Promise(resolve => setTimeout(resolve, ms));

async function Screenshot(url, xpath, output) {
    let driver = await new Builder().forBrowser("chrome").build();

    let dir = path.dirname(output);
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
    }

    await driver.get(url).then(function () {
        return driver.manage().setTimeouts({implicit: 3000});
    }).then(function () {
        return driver.manage().window().setRect({width: 1024, height: 800});
    }).then(function () {
        return driver.findElement(By.id("iLoginButton")).click();
    }).then(function () {
        return driver.sleep(2000);
    }).then(function () {
        return driver.findElement(By.xpath(xpath));
    }).then(function (ele) {
        return ele.takeScreenshot(true);
    }).then(function (encodedString) {
        return fs.writeFileSync(output, encodedString, 'base64');
    });

    return driver.quit();
}

const src = [
    // Help
    [
        'http://192.168.178.38/en/help/general',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Help/Docs/Help/img/help-general-readme.png'
    ],

    [
        'http://192.168.178.38/en/help/module/list',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Help/Docs/Help/img/help-general-module-list.png'
    ],
    [
        'http://192.168.178.38/en/backend/help/module/view?id=Admin',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Help/Docs/Help/img/help-general-module-readme.png'
    ],
    [
        'http://192.168.178.38/en/backend/help/module/view?id=Admin&page=Dev%2Fstructure',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Help/Docs/Help/img/help-general-module-structure.png'
    ],

    [
        'http://192.168.178.38/en/help/developer?id=Admin&page=Dev%2Fstructure',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Help/Docs/Help/img/help-developer-readme.png'
    ],

    // Groups
    [
        'http://192.168.178.38/en/admin/group/settings?id=3#c-tab-3',
        '//*[@id="permissionForm"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-group-settings-permission-form.png'
    ],
    [
        'http://192.168.178.38/en/admin/group/settings?id=3#c-tab-3',
        '//*[@id="igroup-tabs"]/div[2]/div[3]/div/div[2]/div',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-group-settings-permission-list.png'
    ],

    // Accounts
    [
        'http://192.168.178.38/en/admin/account/settings?id=1#c-tab-3',
        '//*[@id="permissionForm"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-account-settings-permission-form.png'
    ],
    [
        'http://192.168.178.38/en/admin/account/settings?id=1#c-tab-3',
        '//*[@id="iaccount-tabs"]/div[2]/div[3]/div/div[2]/div',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-account-settings-permission-list.png'
    ],

    // Modules
    [
        'http://192.168.178.38/en/admin/module/info?id=Admin',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-info.png'
    ],
    [
        'http://192.168.178.38/en/admin/module/settings?id=Admin#c-tab-1',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-settings-general.png'
    ],
    [
        'http://192.168.178.38/en/admin/module/navigation/list?id=Admin',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-settings-navigation.png'
    ],
    [
        'http://192.168.178.38/en/admin/module/route/list?id=Admin',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-settings-routes.png'
    ],
    [
        'http://192.168.178.38/en/admin/module/hook/list?id=Admin',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-settings-hooks.png'
    ],
    [
        'http://192.168.178.38/en/admin/module/log?id=Admin',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-settings-logs.png'
    ],

    // Admin-settings
    [
        'http://192.168.178.38/en/admin/module/settings?id=Admin#c-tab-1',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-admin-settings-general.png'
    ],
    [
        'http://192.168.178.38/en/admin/module/settings?id=Admin#c-tab-2',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-admin-settings-localization.png'
    ],
    [
        'http://192.168.178.38/en/admin/module/settings?id=Admin#c-tab-3',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-admin-settings-design.png'
    ],
    [
        'http://192.168.178.38/en/admin/module/settings?id=Admin#c-tab-5',
        '//*[@id="content"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/admin-module-admin-settings-list.png'
    ],
];
const length = src.length;

(async function loop() {
    for (let i = 0; i < length; ++i) {
        try {
            Screenshot(
                src[i][0],
                src[i][1],
                src[i][2]
            );

            await delay(1000);
        } catch(error) {
            console.error(error);
        }
    }
})();

// "C:\Program Files\nodejs\node.exe" Build/Js/createImages.js