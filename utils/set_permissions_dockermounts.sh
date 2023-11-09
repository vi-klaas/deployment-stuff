#!/bin/bash

# Get the directory name from command line arguments
directory=$1

# Check if a directory name was provided
if [ -z "$directory" ]; then
    echo "Please provide a directory name."
    exit 1
fi

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Directory $directory does not exist."
    exit 1
fi

# Update permissions and ownership recursively in the directory
sudo chown -R apprunner:apprunner "$directory"
sudo chmod -R 740 "$directory"
sudo chgrp -R docker "$directory"

echo "Directory $directory permissions and ownership have been updated."
