#!/bin/bash
## =================================================================================================
## Description : Hardening settings: ufw firewall
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-hardening-firewall.sh [--add-https] [--skip-enable]
##
## Parameters:
##      --add-https     optional, opens ports 80 & 443 (80 required for LetsEncrypt)
##      --skip-enable   optional, does not enable ufw immediately
##
## Requirements:
##      - Bash
##      - ufw
##
## Notes:
##      - Double check port settings!
## =================================================================================================
set -euo pipefail

# arguments
add_https=false;
skip_enable=false;
while [[ $# -gt 0 ]]
do
    case "$1" in
        --add-https)
            add_https=true;
            shift;
            ;;
        --skip-enable)
            skip_enable=true;
            shift;
            ;;
        -h|--help)
            grep '^##' "$0" | sed 's/^## \{0,1\}//';
            exit 0;
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;            
    esac
done

sudo apt update && sudo apt install -y ufw
# defaults
sudo ufw default deny incoming
sudo ufw default allow outgoing
# always set SSH 22
sudo ufw allow 22/tcp
# set HTTP/HTTPS port allowance
if [ "${add_https}" = "true" ]
then
    sudo ufw allow 80,443/tcp
fi
# enable ufw
if [ "${skip_enable}" = "false" ]
then
    yes | sudo ufw enable
fi
