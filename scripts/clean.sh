#!/bin/bash

# Load settings
source service.conf

# Path to the data folder
data_folder="data/records"


# Function to check disk usage
check_disk_usage() {
  # Get disk usage percentage of the data folder
  usage=$(df -h "$data_folder" | awk 'NR==2 {print $5}' | sed 's/%//')
  echo "Disk usage: $usage%"
  
  # Check if the usage is greater than the threshold
  if [ "$usage" -gt "$MAX_DISK_USAGE" ]; then
    return 0
  else
    return 1
  fi
}

# Function to delete the oldest files
delete_oldest_files() {
  # Delete files while the disk usage is above the threshold
  while check_disk_usage; do
    # Get a list of files sorted by modification time
    files=($(ls -t "$data_folder"/*.mp4))

    # Delete the oldest file
    if [ ${#files[@]} -gt 0 ]; then
      echo "Deleting ${files[-1]}"
      rm "${files[-1]}"
    else
      echo "No more files to delete"
      break
    fi
  done
}

# Execute the script
delete_oldest_files
