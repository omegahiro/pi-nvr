#!/bin/bash

# Stop and disable services
sudo systemctl stop nvrweb.service
sudo systemctl stop nvrrecord.service
sudo systemctl stop nvrclean.timer
sudo systemctl stop nvrlive.service
sudo systemctl disable nvrweb.service
sudo systemctl disable nvrrecord.service
sudo systemctl disable nvrclean.timer
sudo systemctl disable nvrclean.service
sudo systemctl disable nvrlive.service

# Delete services
sudo rm /etc/systemd/system/nvrweb.service
sudo rm /etc/systemd/system/nvrrecord.service
sudo rm /etc/systemd/system/nvrclean.timer
sudo rm /etc/systemd/system/nvrclean.service
sudo rm /etc/systemd/system/nvrlive.service

# Finish
echo "NVR services have been stopped and removed."
echo "If you want to remove ffmpeg, run 'sudo apt-get remove ffmpeg'."
