#!/bin/bash
# source alias
shopt -s expand_aliases
source "$HOME/.alias"

# Check the current remote URL
config remote -v

# Change the remote URL to SSH
config remote set-url origin git@github.com:chrishandharmabandu/dotfiles.git

# Verify the updated remote URL
config remote -v

# Push changes with upstream branch
config push --set-upstream origin master

