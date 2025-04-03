#!/bin/bash
## =================================================================================================
## Description : Quick apt update && upgrade
## Author      : Michael J. Stallinger
## Version     : 0.0.1
## License     : MIT
## =================================================================================================
## Usage:
##      ./update.sh
##
## Requirements:
##      - Bash
##      - apt
##
## Notes:
##      - Uses sudo to execute apt.
## =================================================================================================
set -euo pipefail

sudo apt update && sudo apt upgrade -y
