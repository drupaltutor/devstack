#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/../config.sh"

MYSQL_PASSWORD=$(get_var config_mysql_password)

if [ -f /home/vagrant/data/db_backup.sql.gz ]; then
    gunzip -k /home/vagrant/data/db_backup.sql
    mysql -u root --password=$MYSQL_PASSWORD < /home/vagrant/data/db_backup.sql
    rm -f /home/vagrant/data/db_backup.sql
fi
