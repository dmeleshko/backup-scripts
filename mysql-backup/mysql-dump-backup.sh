#!/bin/bash

# Name: mysql-dump-backup.sh
# Description: Backup mysql databases using mysqldump
# Author: Dmitriy Meleshko <dmitriy.meleshko@gmail.com>
# Version: 0.1
# Url: https://github.com/dmeleshko/backup-scripts
# Latest version: 


# Configuration
DATABASES="mysql test"
BACKUP_DIR="/mnt/backups/mysql"

TODAY_BACKUP=$BACKUP_DIR/$(date +%F --date="today")

SAVE_DAYS=10

function do_backup {
    if [ -d "$TODAY_BACKUP" ]
    then
        # Today backup is already exist
        exit 1
    fi
    # do backup all bases one by one
    for db in $DATABASES
    do
        mysqldump $db | gzip --fast > $TODAY_BACKUP/$db.sql.gz
    done
}

function do_clean {
    find $BACKUP_DIR/ -maxdepth 1 -type d -mtime +$SAVE_DAYS -exec rm -rf '{}' \;
}

do_backup
do_clean

# vim: set tabstop=4 expandtab:

