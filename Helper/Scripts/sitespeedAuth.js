// sitespeed.io /var/www/html/Karaka/Build/Helper/Scripts/sitespeedDemoUrls.txt -n 1 -b chrome --preScript /var/www/html/Karaka/Build/Helper/Scripts/sitespeedAuth.js --outputFolder /var/www/html/sitespeed
module.exports = async function(context, commands)
{
    await commands.navigate('http://192.168.178.38/en/backend');

    // await commands.addText.byId('admin', 'iName');
    // await commands.addText.byId('orange', 'iPassword');

    await commands.click.byIdAndWait('iLoginButton');

    return commands.wait.byId('u-box', 1000);
};
