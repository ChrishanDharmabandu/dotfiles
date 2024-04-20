#!/usr/bin/env bash

# Prompt for sudo password
sudo echo "Starting script with elevated privileges..."

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
source "$HOME/.zshrc"

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

# URL of the Debian package
# zsh-completions
PACKAGE_URL="https://download.opensuse.org/repositories/shells:/zsh-users:/zsh-completions/Debian_10/amd64/zsh-completions_0.34.0-1+2.2_amd64.deb"
# Temporarily change to /tmp directory
cd /tmp || exit
# Download the Debian package
wget "$PACKAGE_URL" -O zsh-completions.deb
# Install the package without prompting
sudo dpkg -i zsh-completions.deb
# Clean up downloaded package
rm zsh-completions.deb

# Install Neovim latest
echo "Installing Neovim..."
wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
# Move it to /usr/local/bin
sudo mv /tmp/nvim.appimage /usr/local/bin/nvim
# Make it executable
sudo chmod +x /usr/local/bin/nvim
echo "Neovim installed successfully!"

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# qtile
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
sudo apt install xserver-xorg xinit
sudo apt install libpangocairo-1.0-0
sudo apt install python3-pip python3-xcffib python3-cairocffi
pip install qtile
git clone https://github.com/elParaguayo/qtile-extras.git ~/temp/qtile-extras
pip install ~/temp/qtile-extras

# Install apt packages
xargs -a "$HOME/.config/scripts/pack.list" sudo apt install

# zsh default shell
chsh -s $(which zsh)
source ~/.zshrc

# Install Neovim latest
# Define the URL of the Neovim nightly release .deb file
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb"
# Temporary directory to download the .deb file
TEMP_DIR=$(mktemp -d)
# Download the Neovim .deb file
wget "$NEOVIM_URL" -P "$TEMP_DIR"
# Install Neovim from the downloaded .deb file
sudo dpkg -i "$TEMP_DIR/nvim-linux64.deb"
# Clean up temporary directory
rm -rf "$TEMP_DIR"


# Install Brave Browser
sudo apt install curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

# install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "remember to leader+I, for tmux tmp loading"
echo "remember to 'config remote set-url origin git@github.com:chrishandharmabandu/dotfiles.git' for github auth login"

# eza
cargo install eza

# yazi
cargo install --locked yazi-fm

echo "Bootstrap script completed"

# # pop os i3 style window binds
# # Set up workspace configurations
# gsettings set org.gnome.mutter dynamic-workspaces false 
# gsettings set org.gnome.desktop.wm.preferences num-workspaces 8 
# gsettings set org.gnome.shell.keybindings switch-to-application-1 [] 
# gsettings set org.gnome.shell.keybindings switch-to-application-2 [] 
# gsettings set org.gnome.shell.keybindings switch-to-application-3 [] 
# gsettings set org.gnome.shell.keybindings switch-to-application-4 [] 
# gsettings set org.gnome.shell.keybindings switch-to-application-5 [] 
# gsettings set org.gnome.shell.keybindings switch-to-application-6 [] 
# gsettings set org.gnome.shell.keybindings switch-to-application-7 [] 
# gsettings set org.gnome.shell.keybindings switch-to-application-8 [] 
# gsettings set org.gnome.shell.keybindings switch-to-application-9 [] 
#
# # Set keybindings for switching workspaces
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']" 
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']" 
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']" 
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']" 
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']" 
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']" 
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']" 
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']" 
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']" 
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']" 
#
# # Set keybindings for moving windows to different workspaces
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']" 
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']" 
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']" 
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']" 
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']" 
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']" 
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']" 
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']" 
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']" 
# gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']" 
# # Set keybinding for toggling fullscreen with Mod+F
# gsettings set org.gnome.mutter.keybindings toggle-fullscreen "['<Mod4>f']"
# # Set keybinding for opening browser with Mod+B
# gsettings set org.gnome.desktop.wm.keybindings browser "['<Mod4>b']"
# # set kitty as default term
# gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty'

