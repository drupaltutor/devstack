# BitWisdom PHP Development Environment 

## Installing
1. [Install VirtualBox](https://www.virtualbox.org/). 
2. [Install Vagrant](https://www.vagrantup.com/).
3. Install the [vagrant-triggers extension](https://github.com/emyl/vagrant-triggers).
4. [Download this repository](https://github.com/bitwisdom/phpdev/archive/master.zip), 
and unpack it on your computer.
5. From the command line, change directory to the folder you unpacked the files into, 
into the ```vm``` subdirectory. For example: ```cd ~/Desktop/phpdev/vm```
6. Run ```vagrant up``` to import and start the virtual machine.

## Using the Development Environment
Once you start the virtual machine, you can access your development server at:
[http://localhost:8888/](http://localhost:8888/). This will display the server
dashboard, with links to your sites and tools.

You should put your development sites and applications in the ```sites``` folder.
You will then be able to find them listed under **Your Sites** on the server dashboard.

You can log into the virtual machine by SSH by running ```vagrant ssh```. This virtual 
machine has composer, Drush, and Drupal Console pre-installed.

## Automated Backups
This environment has been designed to automatically backup the MySQL database on every
```vagrant halt``` and ```vagrant destroy``` command. It will re-import the database 
from the backup every time you run ```vagrant up```. The database backup file is stored
in the ```data``` directory.

## Overriding the Configuration
The default configuration can be found in ```config/config.default.yml```. 
You can override any parameters in the default configuration by creating
a file ```config/config.yml```. The format should be the same as ```config.default.yml```.
