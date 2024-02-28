if [ "$1" == "gnome-session" ]; then
    exec gnome-session
else
    exec i3
fi

