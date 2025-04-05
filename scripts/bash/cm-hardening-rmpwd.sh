#!/bin/bash
## =================================================================================================
## Description : Removes the password from root user
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-hardening-rmpwd.sh
##
## Requirements:
##      - bash
##
## Notes:
##      - 
## =================================================================================================
set -euo pipefail

sudo passwd -d root
