#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/../config.sh"

MYSQL_PASSWORD=$(get_var config_mysql_password)

mysqldump -u root --password=$MYSQL_PASSWORD --add-drop-database --flush-privileges --all-databases > /home/vagrant/data/db_backup.sql

if [ -f /home/vagrant/data/db_backup.sql.gz ]; then
    rm -f /home/vagrant/data/db_backup.sql.gz
fi

gzip /home/vagrant/data/db_backup.sql
