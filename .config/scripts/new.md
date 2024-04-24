trackpad.md


Pretty old post but hopefully useful for new people coming here for Xorg, the solution is to create a new conf file for xorg on /etc/X11/xorg.conf.d

In order to see your identifier you must install xinput and run xinput list

/etc/X11/xorg.conf.d/30-touchpad.conf:

Section "InputClass"
        Identifier "ETPS/2 Elantech Touchpad"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
Option "Tapping" "on"
Option "NaturalScrolling" "true"
EndSection

Logout and login, tapping and natural scrolling should work properly.

Source: https://wiki.archlinux.org/title/Libinput

Options:

    Option "Tapping" "on": tapping a.k.a. tap-to-click
    Option "ClickMethod" "clickfinger": trackpad no longer has middle and right button areas and instead two-finger click is a context click and three-finger click is a middle click, see the docs.
    Option "NaturalScrolling" "true": natural (reverse) scrolling
    Option "ScrollMethod" "edge": edge (vertical) scrolling
