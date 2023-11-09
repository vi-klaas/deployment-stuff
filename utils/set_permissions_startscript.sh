#!/bin/bash

# Get the filename from command line arguments
filename=$1

# Check if a filename was provided
if [ -z "$filename" ]; then
    echo "Please provide a filename."
    exit 1
fi

# Full path to the file
filepath="/usr/local/bin/$filename"

# Check if the file exists
if [ ! -f "$filepath" ]; then
    echo "File $filepath does not exist."
    exit 1
fi

# Update permissions and ownership
sudo chown dockeruser:docker "$filepath"
sudo chmod 750 "$filepath"

echo "$filepath permissions and ownership have been updated: chmod 750."
