#!/bin/bash
## =================================================================================================
## Description : Quick apt update && upgrade
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-update.sh
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
