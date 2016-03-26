#!/bin/bash

# Defining paths & basics
BASE_PATH="/var/www/html"
ROOT_PATH="${BASE_PATH}/Orange-Management"
BUILD_PATH="Build"
RELEASE_PATH="Release"
TEST_PATH="Tests"
WEB_URL="http://orange-management.de/Orange-Management"
MAIL_ADDR=""
DB_USER="root"
DB_PASSWORD="123456"

# Git variables
GITHUB_URL[0]="https://github.com/Orange-Management/Orange-Management.git"
GITHUB_URL[1]="https://github.com/Orange-Management/Build.git"
GITHUB_URL[2]="https://github.com/Orange-Management/Console.git"
GITHUB_URL[3]="https://github.com/Orange-Management/cssOMS.git"
GITHUB_URL[4]="https://github.com/Orange-Management/Demo.git"
GITHUB_URL[5]="https://github.com/Orange-Management/Docs.git"
GITHUB_URL[6]="https://github.com/Orange-Management/Documentation.git"
GITHUB_URL[7]="https://github.com/Orange-Management/Install.git"
GITHUB_URL[8]="https://github.com/Orange-Management/jsOMS.git"
GITHUB_URL[9]="https://github.com/Orange-Management/Model.git"
GITHUB_URL[10]="https://github.com/Orange-Management/Modules.git"
GITHUB_URL[11]="https://github.com/Orange-Management/phpOMS.git"
GITHUB_URL[12]="https://github.com/Orange-Management/Release.git"
GITHUB_URL[13]="https://github.com/Orange-Management/Resources.git"
GITHUB_URL[14]="https://github.com/Orange-Management/Socket.git"
GITHUB_URL[15]="https://github.com/Orange-Management/Tests.git"
GITHUB_URL[16]="https://github.com/Orange-Management/Web.git"
GITHUB_URL[17]="https://github.com/Orange-Management/Website.git"

GIT_BRANCH="develop"

DATE=$(date +%Y-%m-%d)
VERSION_HASH=DATE
