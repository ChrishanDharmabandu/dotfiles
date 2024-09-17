#!/usr/bin/env bash

# Define a function for git operations in the dotfiles repo
function config() {
  git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

# Clone dotfiles repository
echo -e "\n>>>>>>>>>> Step 3 - Clone dotfiles Repo <<<<<<<<<<\n"
if ! git clone --bare https://github.com/chrishandharmabandu/dotfiles.git "$HOME/.dotfiles"; then
  echo "Error: Failed to clone dotfiles repository."
  exit 1
fi

# Backup existing dotfiles
echo -e "\n>>>>>>>>>> Step 4 - Backing up existing dotfiles <<<<<<<<<<\n"
mkdir -p "$HOME/.dotfiles-backup"

# Try checking out the dotfiles, handle existing dotfiles
if config checkout; then
  echo "Checked out dotfiles from git@github.com:chrishandharmabandu/dotfiles.git"
else
  echo "Backing up existing dotfiles to ~/.dotfiles-backup"
  config checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | while IFS= read -r file; do
    mv "$file" "$HOME/.dotfiles-backup/"
  done
fi

# Force checkout to apply dotfiles
config checkout --force

# Configure Git to not show untracked files
config config status.showUntrackedFiles no

echo -e "\nDotfiles setup complete!"
