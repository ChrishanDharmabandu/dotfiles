#!/usr/bin/env bash

# Prompt for sudo password & set frontend
echo -e "\n>>>>>>>>>> Step 1 - sudo pw & set frontend <<<<<<<<<<\n"
sudo echo "Starting script with elevated privileges..."
export DEBIAN_FRONTEND=noninteractive

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

# Install apt packages
echo -e "\n>>>>>>>>>> Step 5 - installing apt packages <<<<<<<<<<\n"
sudo apt update && sudo apt upgrade -y
xargs -a "$HOME/.config/scripts/pack.list" sudo apt install -y


# Script to clone git repos
# Install fzf
echo -e "\n>>>>>>>>>> Step 6 - fzf install <<<<<<<<<<\n"
yes | git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Specify the paths and URLs
echo -e "\n>>>>>>>>>> Step 7 - zsh install plugins <<<<<<<<<<\n"
zsh_plug_dir="$HOME/.zsh"
fast_syntax_highlighting_url="https://github.com/zdharma/fast-syntax-highlighting.git"
fzf_tab_url="https://github.com/Aloxaf/fzf-tab.git"
zsh_autosuggestions_url="https://github.com/zsh-users/zsh-autosuggestions.git"

# Remove existing directories
rm -rf "${zsh_plug_dir}/fast-syntax-highlighting"
rm -rf "${zsh_plug_dir}/fzf-tab"
rm -rf "${zsh_plug_dir}/zsh-autosuggestions"

# Clone the repositories
git clone "${fast_syntax_highlighting_url}" "${zsh_plug_dir}/fast-syntax-highlighting"
mv ~/.zsh/fast-syntax-highlighting/*.zsh ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh #fix bug in script
git clone "${fzf_tab_url}" "${zsh_plug_dir}/fzf-tab"
git clone "${zsh_autosuggestions_url}" "${zsh_plug_dir}/zsh-autosuggestions"

# zsh-completions
# URL of the Debian package
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
echo -e "\n>>>>>>>>>> Step 8 - Installing Neovim latest <<<<<<<<<<\n"
wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
# Move it to /usr/local/bin
sudo mv /tmp/nvim.appimage /usr/local/bin/nvim
# Make it executable
sudo chmod +x /usr/local/bin/nvim
echo "Neovim installed successfully!"

# rust
echo -e "\n>>>>>>>>>> Step 9 - Installing Rust & some goodies <<<<<<<<<<\n"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# source path
source "$HOME/.cargo/env"
# eza
cargo install eza
# yazi
cargo install --locked yazi-fm
# zoxide
cargo install zoxide --locked

# starship
echo -e "\n>>>>>>>>>> Step 10 - Installing starship <<<<<<<<<<\n"
echo -e "\n>>>>>>>>>> This can take some time <<<<<<<<<<\n"
curl -sS https://starship.rs/install.sh | sh -s -- -y

# qtile & i3 dependency in python
echo -e "\n>>>>>>>>>> Step 11 - installing qtile & python dependencies <<<<<<<<<<\n"
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
sudo apt install xserver-xorg xinit -y
sudo apt install libpangocairo-1.0-0 -y
sudo apt install python3-pip python3-xcffib python3-cairocffi -y
pip install qtile i3ipc iwlib
git clone https://github.com/elParaguayo/qtile-extras.git ~/temp/qtile-extras
pip install ~/temp/qtile-extras

# zsh default shell
echo -e "\n>>>>>>>>>> Step 12 - zsh default shell <<<<<<<<<<\n"
chsh -s $(which zsh)

# Install Brave Browser
echo -e "\n>>>>>>>>>> Step 13 - Install brave browser <<<<<<<<<<\n"
sudo apt install curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

# install tmux plugin manager
echo -e "\n>>>>>>>>>> Step 14 - Install tmux plugins <<<<<<<<<<\n"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "remember to leader+I, for tmux tmp loading"
echo "remember to 'config remote set-url origin git@github.com:chrishandharmabandu/dotfiles.git' for github auth login"

# pop os i3 style window binds
# Set up workspace configurations
gsettings set org.gnome.mutter dynamic-workspaces false 
gsettings set org.gnome.desktop.wm.preferences num-workspaces 8 
gsettings set org.gnome.shell.keybindings switch-to-application-1 [] 
gsettings set org.gnome.shell.keybindings switch-to-application-2 [] 
gsettings set org.gnome.shell.keybindings switch-to-application-3 [] 
gsettings set org.gnome.shell.keybindings switch-to-application-4 [] 
gsettings set org.gnome.shell.keybindings switch-to-application-5 [] 
gsettings set org.gnome.shell.keybindings switch-to-application-6 [] 
gsettings set org.gnome.shell.keybindings switch-to-application-7 [] 
gsettings set org.gnome.shell.keybindings switch-to-application-8 [] 
gsettings set org.gnome.shell.keybindings switch-to-application-9 [] 

# Set keybindings for switching workspaces
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']" 
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']" 
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']" 
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']" 
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']" 
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']" 
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']" 
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']" 
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']" 
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']" 

# Set keybindings for moving windows to different workspaces
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']" 
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']" 
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']" 
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']" 
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']" 
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']" 
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']" 
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']" 
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']" 
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']" 
# Set keybinding for toggling fullscreen with Mod+F
gsettings set org.gnome.mutter.keybindings toggle-fullscreen "['<Mod4>f']"
# Set keybinding for opening browser with Mod+B
gsettings set org.gnome.desktop.wm.keybindings browser "['<Mod4>b']"
# set kitty as default term
gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty'

echo -e "\nbootstrap complete"

