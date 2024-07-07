#!/bin/bash

# Load settings
source service.conf

# Get the list of files in the directory sorted by modification time
files=($(ls -t data/*.mp4))

# Check if the number of files exceeds the maximum
if [ ${#files[@]} -gt $MAX_FILES ]; then
  # Calculate how many files need to be deleted
  files_to_delete=$((${#files[@]} - $MAX_FILES))

  # Loop through and delete the oldest files
  for ((i=${#files[@]}-1; i>=${#files[@]}-files_to_delete; i--)); do
    rm "${files[i]}"
    echo "Removed: ${files[i]}"
  done
fi
