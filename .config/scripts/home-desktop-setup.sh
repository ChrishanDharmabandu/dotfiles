#!/bin/bash
#Font installer
bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)" 

# zsh default shell
chsh -s $(which zsh)

# set default display settings
xrandr --output DP-0 --mode 1920x1080 --rate 239.76 --primary --output HDMI-0 --mode 1920x1080 --rate 60 --same-as DP-0

