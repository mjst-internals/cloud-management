#!/bin/bash
## =================================================================================================
## Description : Creates a new user and moves the initial key files from root
## Author      : Michael J. Stallinger
## Version     : 0.0.1
## License     : MIT
## =================================================================================================
## Usage:
##      ./init_create_user.sh --user <user_name>
##
## Parameters:
##      --user <user_name>      user to be created
##
## Requirements:
##      - Bash
##
## Notes:
##      - Make sure you have appropriate rights to execute the script!
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


# create user and immediately expire password to force a change on login
useradd --create-home --shell "/bin/bash" --groups sudo "${user_name}"
passwd --delete "${user_name}"
chage --lastday 0 "${user_name}"

# create SSH directory for sudo user and move keys over
home_directory="$(eval echo ~${user_name})"
mkdir --parents "${home_directory}/.ssh"
cp /root/.ssh/authorized_keys "${home_directory}/.ssh"
chmod 0700 "${home_directory}/.ssh"
chmod 0600 "${home_directory}/.ssh/authorized_keys"
chown --recursive "${user_name}":"${user_name}" "${home_directory}/.ssh"
