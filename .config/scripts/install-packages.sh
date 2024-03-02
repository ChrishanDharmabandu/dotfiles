#!/bin/bash

# Set the correct path to the package list file
package_list_file=/home/$SUDO_USER/.config/scripts/packages-list.txt

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit
fi

# Check if the package list file exists
if [ ! -f "$package_list_file" ]; then
    echo "Package list file not found: $package_list_file"
    exit 1
fi

# Detect the package manager
if command -v pacman &> /dev/null; then
    # For Arch Linux (Pacman)
    pacman -S --needed - < "$package_list_file"
elif command -v apt-get &> /dev/null; then
    # For Ubuntu/Debian (APT)
    apt-get install -y $(cat "$package_list_file")
else
    echo "Unsupported package manager. Please update the script with the appropriate command."
    exit 1
fi

echo "Packages installed successfully."

