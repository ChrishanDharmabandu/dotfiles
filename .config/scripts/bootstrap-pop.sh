#!/usr/bin/env bash

# Install git if not already installed
if ! [ -x "$(command -v git)" ]; then
  sudo apt install git -y
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

# Script to clone git repos
# Install fzf
echo "Installing fzf..."
yes | git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

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

# Unsecure apt packages bypass (warning, read scripts before executing)
# Define the configuration file path
config_file="/etc/apt/apt.conf.d/99allow-insecure-repositories"
# Create or overwrite the configuration file with the option to allow insecure repositories
cat <<EOF > "$config_file"
Acquire::AllowInsecureRepositories "true";
EOF
# Inform the user about the completion of the setup
echo "Insecure repositories are now allowed. Hope you read this script before executing"
# Update the APT package cache
apt update
echo "APT package cache updated."

# zsh-completions
echo 'deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-completions/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/shells:zsh-users:zsh-completions.list
curl -fsSL https://download.opensuse.org/repositories/shells:zsh-users:zsh-completions/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_zsh-users_zsh-completions.gpg > /dev/null
sudo apt update
sudo apt install zsh-completions -y

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# qtile
sudo apt install xserver-xorg xinit
sudo apt install libpangocairo-1.0-0
sudo apt install python3-pip python3-xcffib python3-cairocffi
pip install qtile
pip install qtile-extras

# eza
sudo apt update
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# Install apt packages
xargs -a "$HOME/.config/scripts/pack.list" sudo apt install

# zsh default shell
chsh -s $(which zsh)

# yazi
# Define the URL
url="https://github.com/sxyazi/yazi/releases"
# Check if the 'xdg-open' command is available
if command -v xdg-open &> /dev/null; then
    # If available, use 'xdg-open' to open the URL in the default web browser
    xdg-open "$url"
elif command -v open &> /dev/null; then
    # If 'xdg-open' is not available, but 'open' command is available (for macOS)
    open "$url"
else
    # If neither 'xdg-open' nor 'open' is available, print an error message
    echo "Error: Unable to open browser. Please install xdg-utils or use a browser manually."
    exit 1
fi

echo "Bootstrap script completed"
