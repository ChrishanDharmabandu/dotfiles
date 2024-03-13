#!/bin/bash
# zsh default shell
chsh -s $(which zsh)

# set generic display settings
# Get connected displays
connected_displays=$(xrandr | grep "connected" | awk '{print $1}')
# Check if xrandr command succeeded (exit code 0)
if [[ $? -eq 0 ]]; then
  # Loop through connected displays
  for display in $connected_displays; do
    # Set 1080p 60Hz for each display (ignore errors)
    xrandr --output "$display" --mode 1920x1080 --rate 60 &>/dev/null
  done
fi

# set desktop display settings
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

# Script to clone git repos
# Specify the paths and URLs
zsh_plug_dir="$HOME/.zsh"
fast_syntax_highlighting_url="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
fzf_tab_url="https://github.com/Aloxaf/fzf-tab.git"
zsh_autosuggestions_url="https://github.com/zsh-users/zsh-autosuggestions.git"

# Remove existing directories
rm -rf "${zsh_plug_dir}/fast-syntax-highlighting"
rm -rf "${zsh_plug_dir}/fzf-tab"
rm -rf "${zsh_plug_dir}/zsh-autosuggestions"

# Clone the repositories
git clone "${fast_syntax_highlighting_url}" "${zsh_plug_dir}/fast-syntax-highlighting"
git clone "${fzf_tab_url}" "${zsh_plug_dir}/fzf-tab"
git clone "${zsh_autosuggestions_url}" "${zsh_plug_dir}/zsh-autosuggestions"

