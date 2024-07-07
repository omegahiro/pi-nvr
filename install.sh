#!/bin/bash

# Get the current user
CURRENT_USER=$(whoami)

# Get the current directory
NVR_DIR=$(pwd)

# Add execute permission to scripts
chmod +x scripts/*.sh

# Install dependencies
sudo apt-get update
sudo apt-get install -y ffmpeg

# Web Service
sudo cp templates/nvrweb.service.template /etc/systemd/system/nvrweb.service
sudo sed -i "s|__NVR_DIR__|$NVR_DIR|g" /etc/systemd/system/nvrweb.service
sudo systemctl enable nvrweb.service
sudo systemctl start nvrweb.service
echo "nvrweb.service has been installed and started (1/4)"

# Record Service
sudo cp templates/nvrrecord.service.template /etc/systemd/system/nvrrecord.service
sudo sed -i "s|__NVR_DIR__|$NVR_DIR|g" /etc/systemd/system/nvrrecord.service
sudo sed -i "s|__CURRENT_USER__|$CURRENT_USER|g" /etc/systemd/system/nvrrecord.service
sudo systemctl enable nvrrecord.service
sudo systemctl start nvrrecord.service
echo "nvrrecord.service has been installed and started (2/4)"

# Clean Service
sudo cp templates/nvrclean.service.template /etc/systemd/system/nvrclean.service
sudo sed -i "s|__NVR_DIR__|$NVR_DIR|g" /etc/systemd/system/nvrclean.service
sudo sed -i "s|__CURRENT_USER__|$CURRENT_USER|g" /etc/systemd/system/nvrclean.service
sudo systemctl enable nvrclean.service
echo "nvrclean.service has been installed and enabled (3/4)"

# Clean Timer
sudo cp templates/nvrclean.timer.template /etc/systemd/system/nvrclean.timer
sudo systemctl enable nvrclean.timer
sudo systemctl start nvrclean.timer
echo "nvrclean.timer has been installed and started (4/4)"

echo "Waiting for the services to start..."
sleep 10

# Check the services are running
services=(
    "nvrrecord.service"
    "nvrclean.timer"
    "nvrweb.service"
)

for service in "${services[@]}"
do
    if [ "$(systemctl is-active $service)" = "active" ]; then
        echo "$service is running."
    else
        echo "$service is not running."
        echo "Please check the logs by running 'journalctl -u $service'"
        exit 1
    fi
done

# Finish
echo "NVR Installation Finished."
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "Please access to http://$IP_ADDRESS to show the recorded videos."
