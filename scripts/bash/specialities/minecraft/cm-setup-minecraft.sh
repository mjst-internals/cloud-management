#!/bin/bash
## =================================================================================================
## Description : Installs a Bedrock Minecraft server.
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-setup-minecraft.sh
##
## Parameters:
##      --xxx       optional
##
## Requirements:
##      - Bash
##      - unzip
##
## Notes:
##      - 
## =================================================================================================
set -euo pipefail

# not to execute for now!
EXIT 1

# arguments
skip_restart=false;
user_name="";
while [[ $# -gt 0 ]]
do
    case "$1" in
        --skip-restart)
            skip_restart=true;
            shift;
            ;;
        --user)
            user_name="$(echo "$2" | xargs)"; # trim user_name
            shift 2;
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

# requirements
sudo apt update && sudo apt install -y unzip

# enable firewall port (todo: more ports, if more instances)
sudo ufw allow 19132/udp
sudo ufw allow proto udp from ::/0 to any port 19133

# minecraft user (if not already exists)
sudo adduser --disabled-password --gecos "" minecraft
sudo chown -R minecraft:minecraft /home/minecraft
# change to minecraft user
sudo su - minecraft
mkdir -p ~/download
mkdir -p ~/bedrock-server

## TODO: Variablen-Ersetzung!

# download latest version of minecraft-bedrock-server
check_url="https://minecraft.net/en-us/download/server/bedrock/";
download_url=$(curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -s -L -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" ${check_url} |  grep -o 'https.*/bin-linux/.*.zip')
echo "Downloading from: ${download_url}"
sudo wget -U "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" "${download_url}" -O ~/download/bedrock-server.zip

unzip -o ~/download/bedrock-server.zip -d ~/bedrock-server
chmod +x ~/bedrock-server/bedrock_server

# todo: inhalt von bedrock.service in datei einfügen = aber als SUDO wieder!
# todo: 
sudo systemctl daemon-reexec
sudo systemctl enable bedrock-hotel
sudo systemctl start bedrock-hotel

# OPTIONAL
sudo apt remove --purge screen

# TODO: Server.properties, allowlist.json, permissions.json

# TODO: frostbite
