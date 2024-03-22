#!/bin/bash

MAIL_PASSWORD=""
MAIN_PATH="/var/www/html/jingga/"

# 0 4 * * * /var/www/html/jingga/Build/Backup/cron.sh

# Create backup
${MAIN_PATH}Build/Backup/local.sh > /tmp/backup.log

# Mail log files
${MAIN_PATH}Build/Backup/mail.sh ${MAIL_PASSWORD} /tmp/backup.log
${MAIN_PATH}Build/Backup/mail.sh ${MAIL_PASSWORD} ${MAIN_PATH}Logs/$(date '+%Y-%m-%d').log