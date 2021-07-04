const {By,Key,Builder} = require("selenium-webdriver");
require("chromedriver");

let fs = require('fs');

async function Screenshot(url, xpath, output) {
       let driver = await new Builder().forBrowser("chrome").build();

        await driver.get(url).then(function () {
            return driver.manage().setTimeouts({implicit: 3000});
        }).then(function () {
            return driver.manage().window().setRect({width: 1440, height: 1024});
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

Screenshot(
    'http://127.0.0.1/admin/settings/general#c-tab-2',
    '//form[@id="fLocalization"]',
    __dirname + '/../../Modules/Admin/Docs/Help/img/general/settings-localization.png'
).then(function () {
    Screenshot(
        'http://127.0.0.1/admin/settings/general#c-tab-2',
        '//div[@id="settings-localization-time"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/general/settings-localization-time.png'
    );
}).then(function () {
    Screenshot(
        'http://127.0.0.1/admin/settings/general#c-tab-2',
        '//div[@id="settings-localization-numeric"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/general/settings-localization-numeric.png'
    );
}).then(function () {
    Screenshot(
        'http://127.0.0.1/admin/settings/general#c-tab-2',
        '//div[@id="settings-localization-precision"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/general/settings-localization-precision.png'
    );
}).then(function () {
    Screenshot(
        'http://127.0.0.1/admin/settings/general#c-tab-2',
        '//div[@id="settings-localization-weight"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/general/settings-localization-weight.png'
    );
}).then(function () {
    Screenshot(
        'http://127.0.0.1/admin/settings/general#c-tab-2',
        '//div[@id="settings-localization-speed"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/general/settings-localization-speed.png'
    );
}).then(function () {
    Screenshot(
        'http://127.0.0.1/admin/settings/general#c-tab-2',
        '//div[@id="settings-localization-length"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/general/settings-localization-length.png'
    );
}).then(function () {
    Screenshot(
        'http://127.0.0.1/admin/settings/general#c-tab-2',
        '//div[@id="settings-localization-area"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/general/settings-localization-area.png'
    );
}).then(function () {
    Screenshot(
        'http://127.0.0.1/admin/settings/general#c-tab-2',
        '//div[@id="settings-localization-volume"]',
        __dirname + '/../../Modules/Admin/Docs/Help/img/general/settings-localization-volume.png'
    );
});
