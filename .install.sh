#!/usr/bin/env bash

# Make the script executable
chmod +x "$0"

# Prompt for password
read -s -p "Enter your password: " password
echo

# Install necessary packages
sudo -S pacman -Syu --noconfirm git curl

# Download bootstrap script
curl -s https://raw.githubusercontent.com/chrishandharmabandu/dotfiles/master/.config/scripts/bootstrap.sh > bootstrap.sh

# Run bootstrap script
sudo -S bash bootstrap.sh <<< "$password"

# Clean up
rm bootstrap.sh
