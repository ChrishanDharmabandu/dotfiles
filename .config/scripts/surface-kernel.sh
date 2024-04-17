#!/bin/bash

# Download the GPG key and add it to apt trusted keys
wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc | sudo gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg

# Add repository to apt sources
echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main" | sudo tee /etc/apt/sources.list.d/linux-surface.list

# Update apt cache
sudo apt update

# Install necessary packages
sudo apt install linux-image-surface linux-headers-surface libwacom-surface iptsd

