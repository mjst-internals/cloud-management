#!/bin/bash
## =================================================================================================
## Description : Script for the cloud console. Downloads cloud-management and starts init.sh;
## Author      : Michael J. Stallinger
## Version     : 0.0.1
## License     : MIT
## =================================================================================================
## Usage:
##      Copy into cloud console!
##
## Requirements:
##      - Bash
##
## Notes:
##      - Make sure you have appropriate rights to execute the script.
## =================================================================================================
set -euo pipefail

readonly USER_NAME="mjs"; # pick a username you won’t hate tomorrow ;)
readonly REPO="mjst-internals/cloud-management";
readonly DESTINATION="cloud-management.tar.gz";
# download & unzip latest cloud-management release
latest=$(curl -s "https://api.github.com/repos/$REPO/tags" | jq -r '.[0].name');
curl -L "https://github.com/$REPO/archive/refs/tags/${latest}.tar.gz" -o "${DESTINATION}";
tar -xzf "${DESTINATION}" --strip-components=1 --wildcards "cloud-management-*/scripts/bash/";
# make scripts executable
chmod +x scripts/bash/*;
# execute init
bash ./scripts/bash/init.sh --user "${USER_NAME}";
# cleanup the zip-file
rm "${DESTINATION}";
