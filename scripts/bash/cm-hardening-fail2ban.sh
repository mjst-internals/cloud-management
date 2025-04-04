#!/bin/bash
## =================================================================================================
## Description : Hardening: installs fail2ban
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-hardening-fail2ban.sh
##
## Parameters:
##      --xxxx                  optional
##
## Requirements:
##      - bash
##      - fail2ban
##
## Notes:
##      - 
## =================================================================================================
set -euo pipefail

# install
sudo apt update && sudo apt install -y fail2ban
# enable & start
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
