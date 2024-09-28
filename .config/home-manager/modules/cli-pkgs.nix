{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bash-completion
    curl
    docker
    docker-compose
    git
    jq
    neofetch
    ntfs3g
    tree
    unrar-free
    unzip
    wget
    yt-dlp
    zip
    xclip
    less
    tldr
    ranger
    yazi
    os-prober
    tmux
    btop
    unar
    fd
    p7zip
    python3
    gcc
    zoxide
    nodejs_22
  ];
}

