#!/bin/bash

# Define the content to echo into the file
CONFIG_CONTENT='Section "InputClass"
    Identifier "Microsoft Surface 045E:09AF Touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
    Option "Tapping" "on"
    Option "ClickMethod" "clickfinger"
    Option "NaturalScrolling" "true"
EndSection'

# Echo the content into the specified file with sudo
echo "$CONFIG_CONTENT" | sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf > /dev/null

# Check if the echo command was successful
if [ $? -eq 0 ]; then
    echo "Configuration echoed successfully."
else
    echo "Failed to echo configuration."
fi

