#!/bin/bash
## =================================================================================================
## Description : Collection of all hardening scripts
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-hardening.sh [--user <user_name>]
##
## Parameters:
##      --user <user_name>      optional, make sure to pass an existing user
##
## Requirements:
##      - bash
##      - requirements of subsequently called scripts
##
## Notes:
##      - Runs the scripts with default params (except for the allowed user)
## =================================================================================================
set -euo pipefail

# arguments
user_name="";
while [[ $# -gt 0 ]]
do
    case "$1" in
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

bash "$script_dir"/cm-hardening-ssh.sh --user "${user_name}"
bash "$script_dir"/cm-hardening-firewall.sh
bash "$script_dir"/cm-hardening-fail2ban.sh
