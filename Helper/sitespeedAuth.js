module.exports = async function(context, commands)
{
    await commands.navigate('https://orange-management.app');

    await commands.addText.byId('admin', 'iName');
    await commands.addText.byId('orange', 'iPassword');

    await commands.click.byIdAndWait('iLoginButton');

    return commands.wait.byId('u-box', 3000);
};