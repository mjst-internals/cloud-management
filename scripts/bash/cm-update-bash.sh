#!/bin/bash
## =================================================================================================
## Description : Updates cloud-management for Linux from GitHub releases
## Author      : Michael J. Stallinger
## =================================================================================================
## Usage:
##      ./cm-update-bash.sh [--path-only]
##
## Parameters:
##      --path-only     optional, only updates the path variable
##
## Requirements:
##      - Bash
##      - curl
##      - jq
##
## Notes:
##      - Some commands require sudo
## =================================================================================================
set -euo pipefail

# arguments
do_install=true;
while [[ $# -gt 0 ]]
do
    case "$1" in
        --path-only)
            do_install=false;
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

readonly REPO="mjst-internals/cloud-management";
readonly TAR_FILE="cloud-management.tar.gz";
readonly DESTINATION="/opt/cloud-management";
readonly SCRIPTS_SUBDIR="/scripts/bash";
readonly SCRIPTS_DIR="${DESTINATION}${SCRIPTS_SUBDIR}";

if [ "${do_install}" = "true" ]
then
    sudo apt update
    sudo apt install -y curl jq

    latest=$(curl -s "https://api.github.com/repos/${REPO}/tags" | jq -r '.[0].name');
    echo "Downloading latest release (${latest}) into '${TAR_FILE}'...";
    curl -L "https://github.com/${REPO}/archive/refs/tags/${latest}.tar.gz" -o "${TAR_FILE}";

    echo "Extracting scripts to '${DESTINATION}'...";
    sudo mkdir -p "${DESTINATION}";
    sudo tar -xzf "${TAR_FILE}" -C "${DESTINATION}" --strip-components=1 --wildcards "cloud-management-*${SCRIPTS_SUBDIR}/";

    echo "Setting permissions...";
    sudo chmod +x ${SCRIPTS_DIR}/*;
fi

echo "Checking path environment...";
readonly EXPORT_LINE="export PATH=\"${SCRIPTS_DIR}:\$PATH\"";
readonly BASHRC_FILE="$HOME/.bashrc";
readonly DATE_STRING=$(date +"[%F %T]");
readonly INFO_STRING="# added ${DATE_STRING} by $0";
# add path if not already set
if ! grep -Fxq "$EXPORT_LINE" "$BASHRC_FILE"
then
    echo -e "\n${INFO_STRING}" >> "$BASHRC_FILE";
    echo "$EXPORT_LINE" >> "$BASHRC_FILE";
    source "$BASHRC_FILE";
fi
