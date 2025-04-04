#!/bin/bash
## =================================================================================================
## Description : Updates cloud-management for Linux from GitHub releases
## Author      : Michael J. Stallinger
## Version     : 0.0.1
## License     : MIT
## =================================================================================================
## Usage:
##      ./update-bash.sh
##
## Requirements:
##      - Bash
##      - curl
##      - cp
##
## Notes:
##      - Make sure to start with sudo!
## =================================================================================================
set -euo pipefail

REPO="mjst-internals/cloud-management";
DESTINATION="cloud-management.tar.gz";

echo "Downloading latest release...";
latest=$(curl -s "https://api.github.com/repos/${REPO}/tags" | jq -r '.[0].name');
curl -L "https://github.com/${REPO}/archive/refs/tags/${latest}.tar.gz" -o "${DESTINATION}";

echo "Extracting scripts...";
mkdir -p /opt/cloud-management
tar -xzf "${DESTINATION}" -C /opt/cloud-management --strip-components=1 --wildcards "cloud-management-*/scripts/bash/";

echo "Setting permissions...";
chmod +x /opt/cloud-management/*
chmod +x /opt/cloud-management/scripts/bash/*
