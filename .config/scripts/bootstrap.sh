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

# Install Ansible if not already installed
if ! [ -x "$(command -v ansible)" ]; then
  echo "Installing Ansible with pip..."
  sudo pacman -S python-pip --noconfirm  # Install pip if not already installed
  sudo pip install ansible
fi

# Run Ansible playbook
cd $HOME/.config/scripts/
# Install Ansible galaxy requirements
ansible-galaxy install -r requirements.yml
ansible-playbook --diff main.yml

echo "Bootstrap script completed"
