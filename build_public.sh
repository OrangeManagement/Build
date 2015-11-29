#!/bin/bash

# Include private
. var.sh

# Removing unnecessary attribute quotes (only for end user release not for dev release)
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(name=")([a-zA-Z0-9\-\_]*)(")/name=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(for=")([a-zA-Z0-9\-\_]*)(")/for=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(id=")([a-zA-Z0-9\-\_]*)(")/id=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(class=")([a-zA-Z0-9\-\_]*)(")/class=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(min=")([a-zA-Z0-9\-\_]*)(")/min=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(min=")([a-zA-Z0-9\-\_]*)(")/min=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(max=")([a-zA-Z0-9\-\_]*)(")/max=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(type=")([a-zA-Z0-9\-\_]*)(")/type=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(role=")([a-zA-Z0-9\-\_]*)(")/role=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(method=")(.*)(")/method=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(action=")(.*)(")/action=\2/g'
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/(href=")(.*)(")/href=\2/g'

# Removing unnecessary whitespace
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e 's/  */ /g'

# Removing unnecessary newline
find $ROOT_PATH -name "*tpl.php" | xargs -L1 sed -i -e ':a;N;$!ba;s/\n/ /g'

# Removing comments
find $ROOT_PATH -name "*tpl.php" | sed -e :a -re 's/<!--.*?-->//g;/<!--/N;//ba'

# Creating release path
rm -r -f $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
mkdir -p $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
mkdir -p $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH/jsOMS
mkdir -p $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH/jsOMS/Utils

# Copying built files
cp -R $ROOT_PATH/Admin/ $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
cp -R $ROOT_PATH/External/ $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
cp -R $ROOT_PATH/phpOMS/ $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
cp -R $ROOT_PATH/Modules/ $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
cp -R $ROOT_PATH/Model/ $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
cp -R $ROOT_PATH/cssOMS/ $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
cp -R $ROOT_PATH/Web/ $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
cp -R $ROOT_PATH/Socket/ $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
cp -R $ROOT_PATH/Console/ $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH
cp $ROOT_PATH/jsOMS/oms.min.js $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH/jsOMS
cp $ROOT_PATH/jsOMS/Utils/oLib.min.js $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH/jsOMS/Utils

# Removing dev files
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "*.scss" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "*.psd" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "*.yml" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "*.gitignore" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "*.jscsrc" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "*.php_cs" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "*.sh" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "composer.json" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "GruntFile.js" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "koala-config.json" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "package.json" -type f -delete
find $ROOT_PATH/$RELEASE_PATH/Public/$VERSION_HASH -name "private.php" -type f -delete
