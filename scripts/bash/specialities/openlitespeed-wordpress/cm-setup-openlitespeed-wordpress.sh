#!/bin/bash
## =================================================================================================
## Description : Setup for OpenLiteSpeed PHP server with MariaDB & Wordpress
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-setup-openlitespeed-wordpres.sh
##
## Requirements:
##      - Bash
##      - openlitespeed
##      - php
##
## Notes:
##      - Port 7080 can and should be closed later!
## =================================================================================================
set -euo pipefail

# install ols
wget -O - https://repo.litespeed.sh | sudo bash
sudo apt update
sudo apt install openlitespeed -y

# TEMPORARILY open 7080 & 8088 for the admin-GUI & php-Tests
sudo ufw allow 7080/tcp
sudo ufw allow 8088/tcp

echo "Opening ports 7080 and 8088 - attempt to close them as soon as possible!"

# set admin password
sudo /usr/local/lsws/admin/misc/admpass.sh

# install php 8.3
sudo apt install lsphp83 lsphp83-common lsphp83-mysql lsphp83-curl lsphp83-imagick -y

# install MariaDB
sudo apt install mariadb-server -y
sudo mysql_secure_installation

# create databases
