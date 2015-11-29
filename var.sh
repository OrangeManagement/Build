#!/bin/bash

# Defining paths & basics
ROOT_PATH="/var/www/html"
BUILD_PATH="Build"
RELEASE_PATH="Release"
TEST_PATH="Tests"
DB_PASSWORD="123456"
WEB_URL="http://orange-management.de"
MAIL_ADDR=""

# Git variables
GITHUB_URL="https://github.com/spl1nes/Orange-Management.git"
GIT_BRANCH="develop"

VERSION_HASH=$(git rev-parse HEAD)
DATE=$(date +%Y-%m-%d)
