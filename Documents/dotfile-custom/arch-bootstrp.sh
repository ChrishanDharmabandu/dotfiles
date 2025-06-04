#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Prompt for sudo password up front
sudo -v

# === 1. Clone dotfiles ===
log "Cloning dotfiles repository..."
git clone --bare https://github.com/chrishandharmabandu/dotfiles.git "$HOME/.dotfiles"

function config {
   git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

log "Backing up any pre-existing dotfiles..."
mkdir -p "$HOME/.dotfiles-backup"
if config checkout; then
    log "Checked out dotfiles successfully."
else
    warn "Backing up conflicting files..."
    config checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | while read -r file; do
        mkdir -p "$(dirname "$HOME/.dotfiles-backup/$file")"
        mv "$HOME/$file" "$HOME/.dotfiles-backup/$file"
    done
    config checkout --force
fi

config config status.showUntrackedFiles no

# === 2. Install system packages from pkglist ===
if [ -f ./pkglist.txt ]; then
    log "Installing packages from pkglist.txt..."
    sudo pacman -Syu --needed --noconfirm $(<./pkglist.txt)
else
    warn "pkglist.txt not found. Skipping package installation."
fi

# === 3. Install yay (AUR helper) ===
if ! command -v yay > /dev/null; then
    log "Installing yay AUR helper..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    log "yay already installed, skipping..."
fi

# === 4. Install AUR packages ===
if [ -f ./pkglist-aur.txt ]; then
    log "Installing AUR packages from pkglist-aur.txt..."
    yay -S --needed --noconfirm $(<./pkglist-aur.txt)
else
    warn "pkglist-aur.txt not found. Skipping AUR package installation."
fi

# === 5. Setup GitHub CLI authentication ===
log "Setting up GitHub CLI authentication..."
if command -v gh > /dev/null; then
    if ! gh auth status > /dev/null; then
        warn "GitHub CLI not authenticated. Please run 'gh auth login' after setup."
        log "You can authenticate with: gh auth login --hostname github.com --git-protocol https --web"
    else
        log "GitHub CLI already authenticated."
    fi
else
    warn "GitHub CLI not installed. Install it manually if needed."
fi

# === 6. Setup Zsh and Plugins ===
log "Setting up Zsh plugins..."
zsh_plug_dir="$HOME/.zsh"
mkdir -p "$zsh_plug_dir"

declare -A plugins=(
    [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    [fzf-tab]="https://github.com/Aloxaf/fzf-tab.git"
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
)

for name in "${!plugins[@]}"; do
    log "Cloning ${name}..."
    rm -rf "$zsh_plug_dir/$name"
    git clone "${plugins[$name]}" "$zsh_plug_dir/$name"
done

log "Setting Zsh as default shell..."
chsh -s "$(which zsh)"

# === 7. Setup TTY autologin ===
log "Configuring getty@tty1.service autologin..."
override_file="/etc/systemd/system/getty@tty1.service.d/override.conf"
current_user=$(whoami)

service_content="[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin $current_user %I \$TERM
Type=idle"

sudo mkdir -p "$(dirname "$override_file")"
echo "$service_content" | sudo tee "$override_file" > /dev/null

log "Reloading systemd daemon..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart getty@tty1

# === 8. Install fzf ===
log "Installing fzf..."
rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install --all

# === 9. Setup Git configuration ===
log "Setting up Git configuration..."
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email
git config --global user.name "$git_username"
git config --global user.email "$git_email"
git config --global init.defaultBranch main

# === 10. Enable essential services ===
log "Enabling essential services..."
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable docker

log "\n✅ Setup complete! Please reboot and run 'gh auth login' to authenticate GitHub CLI."
warn "Don't forget to:"
warn "  - Run 'gh auth login' for GitHub authentication"
warn "  - Configure your SSH keys if needed"
warn "  - Reboot to apply all changes"

# === 3. Setup Zsh and Plugins ===
echo "Setting up Zsh plugins..."
zsh_plug_dir="$HOME/.zsh"
mkdir -p "$zsh_plug_dir"

declare -A plugins=(
    [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    [fzf-tab]="https://github.com/Aloxaf/fzf-tab.git"
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
)

for name in "${!plugins[@]}"; do
    echo "Cloning ${name}..."
    rm -rf "$zsh_plug_dir/$name"
    git clone "${plugins[$name]}" "$zsh_plug_dir/$name"
done

echo "Setting Zsh as default shell..."
chsh -s "$(which zsh)"

# === 4. Setup TTY autologin ===
echo "Configuring getty@tty1.service autologin..."
override_file="/etc/systemd/system/getty@tty1.service.d/override.conf"
current_user=$(whoami)

service_content="[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin $current_user %I \$TERM
Type=idle"

sudo mkdir -p "$(dirname "$override_file")"
echo "$service_content" | sudo tee "$override_file" > /dev/null

echo "Reloading systemd daemon..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart getty@tty1

# === 5. Install fzf ===
echo "Installing fzf..."
rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install --all

echo -e "\n✅ All done. Dotfiles and packages set up!"

