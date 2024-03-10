#!/bin/bash
# zsh default shell
chsh -s $(which zsh)

# set default display settings
xrandr --output DP-0 --mode 1920x1080 --rate 239.76 --primary --output HDMI-0 --mode 1920x1080 --rate 60 --same-as DP-0

# Script to create or append content to getty@tty1.service override.conf

# Define the path to the override.conf file
override_file="/etc/systemd/system/getty@tty1.service.d/override.conf"

# Get the current username
current_user=$(whoami)

service_content="[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin $current_user %I \$TERM
Type=idle"

# Check if override.conf already exists
if [ -e "$override_file" ]; then
    # If it exists, append the content
    echo "$service_content" | sudo tee -a "$override_file"
else
    # If it doesn't exist, create the file with the content
    echo "$service_content" | sudo tee "$override_file"
fi

# Edit the service using SYSTEMD_EDITOR
sudo SYSTEMD_EDITOR=vim systemctl edit getty@tty1.service

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

