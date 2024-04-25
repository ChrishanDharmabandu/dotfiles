#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Define the new font face and size
FONTSIZE="16x32"

# Check if the font settings are already defined in the file
if grep -q "^FONTFACE=" /etc/default/console-setup && grep -q "^FONTSIZE=" /etc/default/console-setup; then
    sed -i -E "s/^FONTSIZE=.*/FONTSIZE=\"$FONTSIZE\"/" /etc/default/console-setup
else
    # Add font settings if they don't exist
    echo "FONTFACE=\"$FONTFACE\"" >> /etc/default/console-setup
    echo "FONTSIZE=\"$FONTSIZE\"" >> /etc/default/console-setup
fi

# Apply changes
sudo update-initramfs -u

echo "Font face and size updated successfully."

# Update GRUB configuration
sed -i 's/^#\(GRUB_GFXMODE=\)640x480/\11024x768/' /etc/default/grub
if ! grep -q "^GRUB_GFXPAYLOAD_LINUX=" /etc/default/grub; then
    echo "GRUB_GFXPAYLOAD_LINUX=1024x768" >> /etc/default/grub
fi

# Apply changes to GRUB
sudo update-grub
