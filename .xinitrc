#!/bin/bash

# xrandr commands for both configurations
xrandr --output DP-0 --mode 1920x1080 --rate 239.76 --primary --output HDMI-0 --mode 1920x1080 --rate 60 --same-as DP-0

case $1 in
    i3)
        exec i3
        ;;
    gnome)
        exec gnome-shell
        ;;
    *)
        echo "Invalid choice. Exiting."
        ;;
esac

