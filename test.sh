#!/usr/bin/env bash

# Prompt for sudo password
echo -e "\n>>>>>>>>>> Step 1 - sudo pw <<<<<<<<<<\n"
sudo echo "Starting script with elevated privileges..."

# Install git if not already installed
echo -e "\n>>>>>>>>>> Step 2 - install git <<<<<<<<<<\n"
if ! [ -x "$(command -v git)" ]; then
  sudo apt install git -y
fi

# Clone dotfiles repository
echo -e "\n>>>>>>>>>> Step 3 - Clone dotfiles Repo <<<<<<<<<<\n"
git clone --bare https://github.com/chrishandharmabandu/dotfiles.git $HOME/.dotfiles
function config {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# Backup existing dotfiles
echo -e "\n>>>>>>>>>> Step 4 - Backing up existing dotfiles <<<<<<<<<<\n"
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

