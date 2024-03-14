#!/usr/bin/env bash

# Install git if not already installed
if ! [ -x "$(command -v git)" ]; then
  sudo pacman -S git --noconfirm
fi

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

# zsh default shell
chsh -s $(which zsh)

# set generic display settings
## Get connected displays
connected_displays=$(xrandr | grep "connected" | awk '{print $1}')
## Check if xrandr command succeeded (exit code 0)
if [[ $? -eq 0 ]]; then
  # Loop through connected displays
  for display in $connected_displays; do
    # Set 1080p 60Hz for each display (ignore errors)
    xrandr --output "$display" --mode 1920x1080 --rate 60 &>/dev/null
  done
fi

# set desktop display settings if possible
xrandr --output DP-0 --mode 1920x1080 --rate 239.76 --primary --output HDMI-0 --mode 1920x1080 --rate 60 --same-as DP-0

# Script to create or append content to getty@tty1.service override.conf

# Define the path to the override.conf file
override_file="/etc/systemd/system/getty@tty1.service.d/override.conf"

# Get the current username
current_user=$(whoami)

service_content="[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin $current_user %I \$TERM
Type=idle"

# Check if override.conf already exists
if [ -e "$override_file" ]; then
    # If it exists, append the content
    echo "$service_content" | sudo tee -a "$override_file"
else
    # If it doesn't exist, create the file with the content
    echo "$service_content" | sudo tee "$override_file"
fi

# Script to clone git repos
# Install fzf
echo "Installing fzf..."
yes | git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Specify the paths and URLs
zsh_plug_dir="$HOME/.zsh"
fast_syntax_highlighting_url="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
fzf_tab_url="https://github.com/Aloxaf/fzf-tab.git"
zsh_autosuggestions_url="https://github.com/zsh-users/zsh-autosuggestions.git"

# Remove existing directories
rm -rf "${zsh_plug_dir}/fast-syntax-highlighting"
rm -rf "${zsh_plug_dir}/fzf-tab"
rm -rf "${zsh_plug_dir}/zsh-autosuggestions"

# Clone the repositories
git clone "${fast_syntax_highlighting_url}" "${zsh_plug_dir}/fast-syntax-highlighting"
git clone "${fzf_tab_url}" "${zsh_plug_dir}/fzf-tab"
git clone "${zsh_autosuggestions_url}" "${zsh_plug_dir}/zsh-autosuggestions"


# Install Ansible if not already installed
if ! [ -x "$(command -v ansible)" ]; then
  sudo pacman -S ansible --noconfirm
fi

# Run Ansible playbook
cd $HOME/.config/scripts/
# Install Ansible galaxy requirements
ansible-galaxy install -r requirements.yml
ansible-playbook --diff main.yml

echo "Bootstrap script completed"
