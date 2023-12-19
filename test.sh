#!/bin/bash

# Define the list of possible options
DISTROS=("SUSE" "FEDORA")

# Check if the script is provided with an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 [DISTRO]"
    echo "Options:"
    for distro in "${DISTROS[@]}"; do
        echo "  - $distro"
    done
    exit 1
fi

# Get the user argument
USER_ARGUMENT="$1"

# Check if the argument is in the list of DISTROS
if [[ " ${DISTROS[@]} " =~ " ${USER_ARGUMENT} " ]]; then
    echo "You chose $USER_ARGUMENT."
else
    echo "Invalid option."
    echo "Usage: $0 [DISTRO]"
    echo "Options:"
    for distro in "${DISTROS[@]}"; do
        echo "  - $distro"
    done
    exit 1
fi
