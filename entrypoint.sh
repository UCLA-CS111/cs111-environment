#!/usr/bin/env bash

set -e

USER_NAME=cs111-student

SRC=/$USER_NAME

if [ -f "/home/$USER_NAME/.version" ]; then
    # File exists
    if cmp -s "/home/$USER_NAME/.version" "/$USER_NAME/.version"; then
        # Files are identical, do nothing
        echo "Found existing environment; versions match."
    else
        echo "WARNING: Found existing environment, but versions do NOT match."
    fi
else
    # File does not exist
    echo "It looks like this is the first time you're using the CS 111 environment. Preparing home directory..."
    sudo rsync -rahWt --remove-source-files --exclude '.version' --info=progress2 --info=name0 /$USER_NAME/ /home/$USER_NAME
    sudo cp /$USER_NAME/.version /home/$USER_NAME
fi

sudo service ssh start

echo "CS 111 Docker environment is ready!"

cd /home/$USER_NAME

/bin/bash
