#!/bin/bash
## =================================================================================================
## Description : First server start initialization script
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-cloud-init.sh [--user <user_name>]
##
## Parameters:
##      --user <user_name>      user to be created
##
## Requirements:
##      - Bash
##      - requirements of subsequently called scripts
##
## Notes:
##      - Make sure you have appropriate rights to execute the script.
## =================================================================================================
set -euo pipefail

# arguments
user_name="";
while [[ $# -gt 0 ]]
do
    case "$1" in
        --user)
            user_name="$(echo "$2" | xargs)"; # trim user_name
            # check for username
            if [ -z "${user_name}" ]
            then
                echo "Required argument: --user"
                exit 1    
            fi
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

script_dir="$(dirname "${BASH_SOURCE[0]}")";

# create new user and move keys over
bash "$script_dir"/cm-cloud-init-user-create.sh --user "${user_name}"

# finiah cm installation in user-context
sudo -u "${user_name}" bash -c "${script_dir}/cm-update-bash.sh --path-only"

# harden ssh configuration
#bash "$script_dir"/cm-hardening-ssh.sh --user "${user_name}"
# enable ufw
#bash "$script_dir"/cm-hardening-firewall.sh
