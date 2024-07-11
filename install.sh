#!/bin/bash

# Get the current user
CURRENT_USER=$(whoami)

# Get the current directory
NVR_DIR=$(pwd)

# Add execute permission to scripts
chmod +x scripts/*.sh

# Install dependencies
sudo apt update
sudo apt install -y ffmpeg

# Web Service
sudo cp services/nvrweb.service.template /etc/systemd/system/nvrweb.service
sudo sed -i "s|__NVR_DIR__|$NVR_DIR|g" /etc/systemd/system/nvrweb.service
sudo sed -i "s|__CURRENT_USER__|$CURRENT_USER|g" /etc/systemd/system/nvrweb.service
sudo systemctl enable nvrweb.service
sudo systemctl start nvrweb.service
echo "nvrweb.service has been installed and started (1/5)"

# Record Service
sudo cp services/nvrrecord.service.template /etc/systemd/system/nvrrecord.service
sudo sed -i "s|__NVR_DIR__|$NVR_DIR|g" /etc/systemd/system/nvrrecord.service
sudo sed -i "s|__CURRENT_USER__|$CURRENT_USER|g" /etc/systemd/system/nvrrecord.service
sudo systemctl enable nvrrecord.service
sudo systemctl start nvrrecord.service
echo "nvrrecord.service has been installed and started (2/5)"

# Clean Service
sudo cp services/nvrclean.service.template /etc/systemd/system/nvrclean.service
sudo sed -i "s|__NVR_DIR__|$NVR_DIR|g" /etc/systemd/system/nvrclean.service
sudo sed -i "s|__CURRENT_USER__|$CURRENT_USER|g" /etc/systemd/system/nvrclean.service
sudo systemctl enable nvrclean.service
echo "nvrclean.service has been installed and enabled (3/5)"

# Clean Timer
sudo cp services/nvrclean.timer.template /etc/systemd/system/nvrclean.timer
sudo systemctl enable nvrclean.timer
sudo systemctl start nvrclean.timer
echo "nvrclean.timer has been installed and started (4/5)"

# Live Service
sudo cp services/nvrlive.service.template /etc/systemd/system/nvrlive.service
sudo sed -i "s|__NVR_DIR__|$NVR_DIR|g" /etc/systemd/system/nvrlive.service
sudo sed -i "s|__CURRENT_USER__|$CURRENT_USER|g" /etc/systemd/system/nvrlive.service
sudo systemctl enable nvrlive.service
sudo systemctl start nvrlive.service
echo "nvrlive.service has been installed and started (5/5)"

echo "Waiting for the services to start..."
sleep 15

# Check the services are running
services=(
    "nvrrecord.service"
    "nvrclean.timer"
    "nvrweb.service"
    "nvrlive.service"
)

for service in "${services[@]}"; do
    if [ "$(systemctl is-active $service)" = "active" ]; then
        echo "$service is running."
    else
        echo -e "\e[31m$service is not running.\e[0m"
        echo -e "\e[31mPlease check the logs by running 'journalctl -u $service -n 10'.\e[0m"
        echo -e "\e[31mYou may need to change the service.conf to your environment.\e[0m"
        echo -e "\e[31mThen, run uninstall.sh and try install.sh again.\e[0m"
        exit 1
    fi
done

# Finish
echo "NVR Installation Finished Successfully!"
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "Please access to http://$IP_ADDRESS:8000/ to show the recorded videos."
