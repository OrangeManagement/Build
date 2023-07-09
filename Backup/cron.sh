#!/bin/bash

MAIL_PASSWORD=""
MAIN_PATH="/var/www/html/Karaka/"

# 0 4 * * * /var/www/html/Karaka/Build/Backup/cron.sh

# Create backup
${MAIN_PATH}Build/Backup/backup.sh > /tmp/backup.log

# Mail log files
${MAIN_PATH}Build/Backup/mail.sh ${MAIL_PASSWORD} /tmp/backup.log
${MAIN_PATH}Build/Backup/mail.sh ${MAIL_PASSWORD} ${MAIN_PATH}Logs/$(date '+%Y-%m-%d').log