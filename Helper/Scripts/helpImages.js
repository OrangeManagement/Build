const {By,Key,Builder} = require("selenium-webdriver");
const chrome = require('selenium-webdriver/chrome');

const { promises: fs} = require('fs');
const fsync = require('fs');
const path = require('path');

async function Screenshot(driver, url, xpath, output) {
    const dir = path.dirname(output);
    if (!fsync.existsSync(dir)) {
        fsync.mkdirSync(dir, { recursive: true });
    }

    await driver.get(url).then(function () {
        if (url.includes('#')) {
            driver.findElement(By.css('label[for=' + url.substring(url.indexOf('#') + 1) + ']')).click();
        }

        return driver.findElement(By.xpath(xpath));
    }).then(function (ele) {
        ele.click();
        driver.actions().scroll(0, 0, 0, 0, ele).perform();

        return ele;
    }).then(function (ele) {
        return ele.takeScreenshot(true);
    }).then(function (encodedString) {
        return fsync.writeFileSync(output, encodedString, 'base64');
    });
}

const base = 'http://192.168.178.38/en';

(async function createImages() {
    const driver = await new Builder().forBrowser("chrome").build();
    await driver.get(base);
    await driver.manage().setTimeouts({ implicit: 3000 });
    await driver.manage().window().setRect({ width: 1920, height: 1080 });
    await driver.findElement(By.id('iLoginButton')).click();
    await driver.sleep(1000);

    const files = await fs.readdir(__dirname + '/../../../Modules');
    const length = files.length;

    for (let i = 0; i < length; ++i) {
        try {
            const src = JSON.parse(fsync.readFileSync(__dirname + '/../../../Modules/' + files[i] +'/Docs/img.json', 'utf8'));
            await loop (driver, src)
        } catch (e) {
            //console.log(e.message);
        }
    }

    await driver.quit();
})();

async function loop(driver, src) {
    const length = src.length;
    for (let i = 0; i < length; ++i) {
        try {
            await Screenshot(driver,
                base + src[i][0],
                src[i][1],
                __dirname + '/../../../Modules' + src[i][2]
            );
        } catch(error) {
            console.error(error);
        }
    }
};

// "C:\Program Files\nodejs\node.exe" Build/Js/createImages.js