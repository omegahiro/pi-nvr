#!/bin/bash

# サービスを停止して無効化
sudo systemctl stop nvrweb.service
sudo systemctl stop nvrrecord.service
sudo systemctl stop nvrclean.timer

sudo systemctl disable httpserver.service
sudo systemctl disable nvrrecord.service
sudo systemctl disable nvrclean.timer
sudo systemctl disable nvrclean.service

# サービスファイルを削除
sudo rm /etc/systemd/system/nvrweb.service
sudo rm /etc/systemd/system/nvrrecord.service
sudo rm /etc/systemd/system/nvrclean.service
sudo rm /etc/systemd/system/nvrclean.timer

echo "NVR services have been stopped and removed."
