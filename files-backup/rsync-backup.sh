#!/bin/bash

# Name: diff_backup.sh
# Description: Differential backup script using rsync and hard links
# Author: Dmitriy Meleshko <dmitriy.meleshko@gmail.com>
# Version: 0.2
# Url: https://github.com/dmeleshko/diff_backup
# Direct link: https://raw.githubusercontent.com/dmeleshko/diff_backup/master/diff_backup.sh


# Configuration
SOURCE_DIR="/var/www"
BACKUP_DIR="/mnt/backups"

TODAY_BACKUP=$BACKUP_DIR/$(date +%F --date="today")
YESTERDAY_BACKUP=$BACKUP_DIR/$(date +%F --date="yesterday")

SAVE_DAYS=10

function do_backup {
    if [ -d "$TODAY_BACKUP" ]
    then
        exit 1
    fi
    if [ -d "$YESTERDAY_BACKUP" ]
    then
        # make hardlink copy of yesterday backup
        cp -al $YESTERDAY_BACKUP $TODAY_BACKUP
    fi
    # do backup of SOURCE_DIR
    rsync -a --delete $SOURCE_DIR/ $TODAY_BACKUP/
}

function do_clean {
    find $BACKUP_DIR/ -maxdepth 1 -type d -mtime +$SAVE_DAYS -exec rm -rf '{}' \;
}

do_backup
do_clean

# vim: set tabstop=4 expandtab:
