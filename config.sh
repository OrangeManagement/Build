#!/bin/bash

# Paths
BASE_PATH="${BUILD_PATH}/.."
ROOT_PATH="${BUILD_PATH}/.."

TOOLS_PATH="${BUILD_PATH}/.."
RELEASE_PATH="/var/www/html/Release"

# Web
WEB_URL="http://jingga.app"
MAIL_ADDR=""

# Authentications
DB_USER="test"
DB_PASSWORD="orange"

# Git variables
GITHUB_URL[0]="https://github.com/Karaka-Management/Karaka.git"

GIT_BRANCH="develop"

DATE=$(date +%Y-%m-%d)
VERSION_HASH=${DATE}
