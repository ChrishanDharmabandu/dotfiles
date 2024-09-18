{ pkgs, ... }:

{
  home.packages = with pkgs; [
    picom
    timeshift
    variety
    pcmanfm
    arandr
    rofi
  ];
}

