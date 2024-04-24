#!/bin/bash
git --git-dir=$HOME/.dotfiles --work-tree=$HOME remote set-url origin git@github.com:chrishandharmabandu/dotfiles.git

git --git-dir=$HOME/.dotfiles --work-tree=$HOME push --set-upstream origin master
