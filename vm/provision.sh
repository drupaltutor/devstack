#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"

# Apache Sites
if [ -d /vagrant-config/apache2/sites-enabled ]; then
  rm -rf /etc/apache2/sites-enabled
  ln -sv /vagrant-config/apache2/sites-enabled /etc/apache2/sites-enabled
fi

# MySQL Custom
if [ -f /vagrant-config/mysql/custom.cnf ]; then
  ln -sv /vagrant-config/mysql/custom.cnf /etc/mysql/conf.d/user.cnf
fi

# PHP Custom
if [ -f /vagrant-config/php/apache2/custom.ini ]; then
  ln -sv /vagrant-config/php/apache2/custom.ini /etc/php/7.0/apache2/conf.d/99-user.ini
fi
if [ -f /vagrant-config/php/cli/custom.ini ]; then
  ln -sv /vagrant-config/php/cli/custom.ini /etc/php/7.0/cli/conf.d/99-user.ini
fi
