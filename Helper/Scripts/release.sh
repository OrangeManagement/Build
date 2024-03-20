#!/bin/bash

echo "#################################################"
echo "# Build develop"
echo "#################################################"

git submodule foreach "git checkout develop || true"
git submodule foreach git pull

git checkout develop
git pull

npm run scss
npm run release

echo "#################################################"
echo "# Update develop submodules"
echo "#################################################"

git submodule foreach git add .
git submodule foreach "git commit -m 'Preparing for master update' || true"
git submodule foreach git push

echo "#################################################"
echo "# Update develop main repo"
echo "#################################################"

git add .
git commit -m "Preparing for master update"
git push

echo "#################################################"
echo "# Switch to master"
echo "#################################################"

git submodule foreach git checkout master
git submodule foreach git pull

git checkout master
git pull

echo "#################################################"
echo "# Merge develop"
echo "#################################################"

git submodule foreach git merge develop
git merge develop

git submodule foreach git add .
git submodule foreach "git commit -m 'Update master' || true"
git submodule foreach git push

git add .
git commit -m "Update master"
git push

echo "#################################################"
echo "# Switch to develop"
echo "#################################################"

git submodule foreach "git checkout develop || true"
git checkout develop