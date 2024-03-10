# Purpose
Store dotfiles to transport any linux setup

## Ansible complete setup
```
curl -s https://raw.githubusercontent.com/chrishandharmabandu/dotfiles/master/install.sh | bash
```

# How it works
## Setting Up the Bare Repository

If you're setting up dotfiles for the first time, follow these steps to create a bare Git repository:

```Bash
git init --bare $HOME/.dotfiles
```
> This initializes a "bare" Git repository at ~/.dotfiles.
> Create an alias to interact with the repository easily. Add the following lines to your shell configuration file (e.g., ~/.bashrc, ~/.zshrc, or ~/.config/fish/config.fish), and then source the file:

```Bash
alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
```
> The --work-tree=$HOME option sets the directory that the repository tracks to your home directory.

## Configure the repository to not show untracked files by default
`config config --local status.showUntrackedFiles no`

## Tracking Files
```bash
config add ~/.bashrc
config add ~/.zshrc
config add ~/.config/fish/config.fish
config commit -m "Add .bashrc/.zshrc/config.fish file"
config push
```
# Acknowledgement
Heavily inspired by [dotfiles-in-a-git-repository](https://mjones44.medium.com/storing-dotfiles-in-a-git-repository-53f765c0005d)

