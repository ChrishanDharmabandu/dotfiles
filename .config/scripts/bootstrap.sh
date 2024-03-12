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

# set resoltion globally
## Get a list of connected monitors
monitors=$(xrandr --listmonitors | grep -oP '\b\w+\b')
## Set the resolution for each connected monitor to 1920x1080
for monitor in $monitors; do
    xrandr --output $monitor --mode 1920x1080 --fb 1920x1080 --panning 1920x1080
done

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
