#!/bin/bash

# Paths
BASE_PATH="/var/www/html"
ROOT_PATH="/var/www/html/Karaka"
BUILD_PATH="/var/www/html/Build"

TOOLS_PATH="/var/www/html/Tools"
RELEASE_PATH="/var/www/html/Release"

# Web
WEB_URL="http://jingga.app"
MAIL_ADDR=""

# Authentications
DB_USER="root"
DB_PASSWORD="root"

# Git variables
GITHUB_URL[0]="https://github.com/Karaka-Management/Karaka.git"

GIT_BRANCH="develop"

DATE=$(date +%Y-%m-%d)
VERSION_HASH=${DATE}
