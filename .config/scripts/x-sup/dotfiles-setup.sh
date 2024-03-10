#!/usr/bin/env bash

# Clone dotfiles repository
echo "Cloning dotfiles repository..."
git clone --bare https://github.com/chrishandharmabandu/dotfiles.git $HOME/.dotfiles

function config {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# Backup existing dotfiles
echo "Backing up existing dotfiles..."
mkdir -p .dotfiles-backup
config checkout

# Handle existing dotfiles
if [ $? = 0 ]; then
  echo "Checked out dotfiles from git@github.com:chrishandharmabandu/dotfiles.git";
else
  echo "Moving existing dotfiles to ~/.dotfiles-backup";
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi

config checkout --force
config config status.showUntrackedFiles no

# Clone Git repositories for Zsh plugins
echo "Cloning Zsh plugins..."
zsh_plug_dir="$HOME/.zsh"
fast_syntax_highlighting_url="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
fzf_tab_url="https://github.com/Aloxaf/fzf-tab.git"
zsh_autosuggestions_url="https://github.com/zsh-users/zsh-autosuggestions.git"

# Remove existing directories
echo "Removing existing Zsh plugin directories..."
rm -rf "${zsh_plug_dir}/fast-syntax-highlighting"
rm -rf "${zsh_plug_dir}/fzf-tab"
rm -rf "${zsh_plug_dir}/zsh-autosuggestions"

# Clone the repositories
echo "Cloning Zsh plugins from Git..."
git clone "${fast_syntax_highlighting_url}" "${zsh_plug_dir}/fast-syntax-highlighting"
git clone "${fzf_tab_url}" "${zsh_plug_dir}/fzf-tab"
git clone "${zsh_autosuggestions_url}" "${zsh_plug_dir}/zsh-autosuggestions"

# Set Zsh as the default shell
echo "Setting Zsh as the default shell..."
chsh -s "$(which zsh)"

# Set default display settings
echo "Setting default display settings..."
xrandr --output DP-0 --mode 1920x1080 --rate 239.76 --primary --output HDMI-0 --mode 1920x1080 --rate 60 --same-as DP-0

# Configure getty@tty1.service
echo "Configuring getty@tty1.service..."
override_file="/etc/systemd/system/getty@tty1.service.d/override.conf"
current_user=$(whoami)

service_content="[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin $current_user %I \$TERM
Type=idle"

# Check if override.conf already exists
if [ -e "$override_file" ]; then
    # If it exists, append the content
    echo "Appending content to $override_file..."
    echo "$service_content" | sudo tee -a "$override_file"
else
    # If it doesn't exist, create the file with the content
    echo "Creating $override_file with content..."
    echo "$service_content" | sudo tee "$override_file"
fi

# Edit the service using SYSTEMD_EDITOR
echo "Opening $override_file for editing..."
sudo SYSTEMD_EDITOR=vim systemctl edit getty@tty1.service

# Install fzf
echo "Installing fzf..."
yes | git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install



echo "Setup script completed successfully!"
