#!/bin/bash

info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

# Create log directories
BASH_BACKUP_PATH="/var/www/html/backup/bash"
mkdir -p ${BASH_BACKUP_PATH}

# Create database backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DB_USER="jingga"
DB_PASSWORD="password"
DB_BACKUP_PATH="/var/www/html/backup/sql"

info "Starting mysql backup"

mkdir -p ${DB_BACKUP_PATH}
mysqldump -u ${DB_USER} -p${DB_PASSWORD} oms > oms_${TIMESTAMP}.sql

sql_exit=$?

# Create file backup

BACKUP_PATH="/mnt/d/backup/backup.borg"
TO_BACKUP="/var/www/html"
#REMOTE_USER="user"
#REMOTE_SERVER="192.168.178.38"
#REMOTE_PORT="2022"

# Setting this, so the repo does not need to be given on the commandline:
#export BORG_REPO=ssh://${REMOTE_USER}@${REMOTE_SERVER}:${REMOTE_PORT}${BACKUP_PATH}

# See the section "Passphrase notes" for more infos.
export BORG_PASSPHRASE='password'

# Global settings
export BORG_RELOCATED_REPO_ACCESS_IS_OK=no
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=no

## Create repository
# borg init -v --encryption=repokey ${BACKUP_PATH}
# borg key export ${BACKUP_PATH} repokey

## Start backup
info "Starting file backup"

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --one-file-system               \
    --compression lz4               \
    --checkpoint-interval 86400     \
    --exclude-caches                \
    --exclude 'home/*/.cache/*'     \
    --exclude 'var/tmp/*'           \
                                    \
    ${BACKUP_PATH}::${TIMESTAMP}-$$-www  \
    ${TO_BACKUP}

backup_exit=$?

## Only keep 7 daily, 4 weekly and 6 monthly backups
info "Pruning repository"

borg prune                          \
    --list                          \
    --glob-archives '{hostname}-*'  \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \
    --keep-yearly   10

prune_exit=$?

## Reduce disk space by compacting
info "Compacting repository"

borg compact ${BACKUP_PATH}

compact_exit=$?

## Check integrity
info "Checking repository"

borg check --verify-data ${BACKUP_PATH}

check_exit=$?

# Handle global exit code
global_exit=$(( sql_exit > backup_exit ? sql_exit : backup_exit ))
global_exit=$(( prune_exit > global_exit ? prune_exit : global_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))
global_exit=$(( check_exit > global_exit ? check_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup, Prune, Compact and/or Check finished with warnings"
else
    info "Backup, Prune, Compact and/or Check finished with errors"
fi

exit ${global_exit}
