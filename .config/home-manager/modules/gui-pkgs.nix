{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gparted
    syncthing
    ffmpeg
    kitty
    mpv
    vlc
    qbittorrent
    rsync
    firefox
  ];
}

