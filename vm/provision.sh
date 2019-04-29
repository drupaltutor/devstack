#!/usr/bin/env bash

. "/vagrant/config.sh"

# Apache Sites
if [ -d /vagrant-config/apache2/sites-enabled ]; then
  rm -rf /etc/apache2/sites-enabled
  ln -sv /vagrant-config/apache2/sites-enabled /etc/apache2/sites-enabled
  /usr/sbin/apache2ctl restart
fi

# MySQL Custom
if [ -f /vagrant-config/mysql/custom.cnf ]; then
  ln -sv /vagrant-config/mysql/custom.cnf /etc/mysql/conf.d/user.cnf
  /usr/sbin/service mysql restart
fi

# PHP Custom
if [ -f /vagrant-config/php/apache2/custom.ini ]; then
  ln -sv /vagrant-config/php/apache2/custom.ini /etc/php/7.2/apache2/conf.d/99-user.ini
  /usr/sbin/apache2ctl restart
fi
if [ -f /vagrant-config/php/cli/custom.ini ]; then
  ln -sv /vagrant-config/php/cli/custom.ini /etc/php/7.2/cli/conf.d/99-user.ini
fi

# Add SSH Keys for Use with Git
mkdir -p /home/vagrant/.ssh
mkdir -p /home/vagrant/data/ssh
/bin/cat /dev/zero | /usr/bin/ssh-keygen -b 2048 -t rsa -f /home/vagrant/data/ssh/id_rsa -q -N "" >> /dev/null
if [ -f /vagrant-config/ssh/config ]; then
  cp /vagrant-config/ssh/config /home/vagrant/.ssh/config
fi
chown -R vagrant.vagrant /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/config /vagrant-config/ssh/config

# Git Configuration
GIT_EMAIL=$1
GIT_NAME=$2
su - vagrant -c "git config --global user.email '$GIT_EMAIL'"
su - vagrant -c "git config --global user.name '$GIT_NAME'"
