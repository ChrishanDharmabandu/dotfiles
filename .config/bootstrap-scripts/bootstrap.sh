#!/usr/bin/env bash

# Cross-platform Dotfiles Bootstrap Script
# Supports Arch Linux, macOS (Homebrew), and Debian-based systems

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME}"

# Logging functions
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if command -v pacman >/dev/null 2>&1; then
        echo "arch"
    elif command -v brew >/dev/null 2>&1; then
        echo "macos"
    elif command -v apt >/dev/null 2>&1; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Packages that are not available or equivalent in Homebrew
declare -A BREW_INCOMPATIBLE=(
    # Arch-specific packages
    ["base"]="Base system - not applicable"
    ["base-devel"]="Xcode command line tools - install with: xcode-select --install"
    ["amd-ucode"]="AMD microcode - not applicable on macOS"
    ["alsa-firmware"]="Audio system - macOS uses CoreAudio"
    ["alsa-plugins"]="Audio system - macOS uses CoreAudio"
    ["alsa-utils"]="Audio system - macOS uses CoreAudio"
    ["bluez"]="Bluetooth - macOS has built-in Bluetooth"
    ["bluez-hid2hci"]="Bluetooth - macOS has built-in Bluetooth"
    ["bluez-libs"]="Bluetooth - macOS has built-in Bluetooth"
    ["bluez-utils"]="Bluetooth - macOS has built-in Bluetooth"
    
    # CachyOS-specific packages
    ["cachyos-fish-config"]="CachyOS-specific configuration"
    ["cachyos-gaming-applications"]="CachyOS-specific gaming setup"
    ["cachyos-gaming-meta"]="CachyOS-specific gaming meta package"
    ["cachyos-hello"]="CachyOS welcome application"
    ["cachyos-hooks"]="CachyOS-specific hooks"
    ["cachyos-hyprland-settings"]="CachyOS-specific Hyprland settings"
    ["cachyos-kernel-manager"]="CachyOS kernel manager"
    ["cachyos-keyring"]="CachyOS keyring"
    ["cachyos-micro-settings"]="CachyOS-specific micro settings"
    ["cachyos-mirrorlist"]="CachyOS mirror list"
    ["cachyos-nord-gtk-theme-git"]="CachyOS-specific theme"
    ["cachyos-packageinstaller"]="CachyOS package installer"
    ["cachyos-plymouth-theme"]="CachyOS boot theme"
    ["cachyos-rate-mirrors"]="CachyOS mirror rating tool"
    ["cachyos-settings"]="CachyOS-specific settings"
    ["cachyos-v3-mirrorlist"]="CachyOS mirror list"
    ["cachyos-v4-mirrorlist"]="CachyOS mirror list"
    ["cachyos-wallpapers"]="CachyOS wallpapers"
    ["cachyos-zsh-config"]="CachyOS-specific zsh config"
    
    # System-level packages not applicable to macOS
    ["accountsservice"]="System service - not applicable on macOS"
    ["appimagelauncher"]="AppImage launcher - not needed on macOS"
    ["arandr"]="X11 display configuration - macOS uses different system"
    ["bpftune-git"]="Linux kernel tuning - not applicable on macOS"
    ["btrfs-assistant"]="BTRFS filesystem tool - macOS uses APFS"
    ["btrfs-progs"]="BTRFS filesystem utilities - macOS uses APFS"
    ["rasdaemon"]="Linux RAS daemon - not applicable on macOS"
    ["snapd"]="Snap package manager - not needed on macOS"
    ["snapper-gui-git"]="BTRFS snapshot GUI - macOS uses Time Machine"
    
    # AUR packages that likely won't work
    ["dmenu-rs"]="X11 application launcher - macOS doesn't use X11"
    ["docker-desktop"]="Available as direct download for macOS"
    ["qtile-extras"]="X11 window manager extensions - macOS has its own WM"
    ["qutebrowser-git"]="Git version - use stable 'qutebrowser' instead"
    ["warp-terminal"]="Available as direct download for macOS"
    ["youtube-cli"]="May work - try 'yt-dlp' instead"
)

# Convert Arch package names to Homebrew equivalents
declare -A BREW_EQUIVALENTS=(
    # CLI tools (regular brew formulae)
    ["bash-completion"]="bash-completion"
    ["bc"]="bc"
    ["bind"]="bind"
    ["btop"]="btop"
    ["fish"]="fish"
    ["git"]="git"
    ["micro"]="micro"
    ["neovim"]="neovim"
    ["nvim"]="neovim"
    ["starship"]="starship"
    ["zsh"]="zsh"
    ["awesome-terminal-fonts"]="font-awesome-terminal-fonts"
    
    # GUI applications that need cask
    ["alacritty"]="alacritty"
    ["bitwarden"]="bitwarden"
    ["discord"]="discord"
    ["kitty"]="kitty"
    ["obs-studio"]="obs"
    ["obsidian"]="obsidian"
    ["spotify"]="spotify"
    ["wezterm"]="wezterm"
    ["firefox"]="firefox"
    ["chromium"]="chromium"
    ["vlc"]="vlc"
    ["gimp"]="gimp"
    ["libreoffice"]="libreoffice"
    ["thunderbird"]="thunderbird"
    ["code"]="visual-studio-code"
    ["neovide"]="neovide"
    ["sublime-text"]="sublime-text"
    ["atom"]="atom"
    ["transmission"]="transmission"
    ["blender"]="blender"
    ["inkscape"]="inkscape"
    ["krita"]="krita"
    ["darktable"]="darktable"
    ["handbrake"]="handbrake"
    ["audacity"]="audacity"
    ["mpv"]="mpv"
    ["iina"]="iina"
    
    # No equivalents or different approaches needed
    ["atril"]="" # No direct equivalent, suggest alternative
    ["bemenu"]="" # X11-specific, no macOS equivalent
    ["bemenu-wayland"]="" # Wayland-specific, no macOS equivalent
    ["caja"]="" # MATE file manager, use Finder or alternatives
    ["caja-actions"]="" # MATE-specific
    ["celluloid"]="" # Linux media player, use IINA or VLC
    ["nautilus"]="" # GNOME file manager, use Finder
    ["pavucontrol"]="" # PulseAudio control, macOS uses different audio system
    ["rofi"]="" # X11 launcher, use Alfred or similar
)

# GUI applications that require Homebrew casks instead of regular formulae
declare -A BREW_CASKS=(
    ["alacritty"]="1"
    ["bitwarden"]="1"
    ["discord"]="1"
    ["kitty"]="1"
    ["obs-studio"]="1"
    ["obsidian"]="1"
    ["spotify"]="1"
    ["wezterm"]="1"
    ["firefox"]="1"
    ["chromium"]="1"
    ["vlc"]="1"
    ["gimp"]="1"
    ["libreoffice"]="1"
    ["thunderbird"]="1"
    ["code"]="1"
    ["neovide"]="1"
    ["sublime-text"]="1"
    ["atom"]="1"
    ["transmission"]="1"
    ["blender"]="1"
    ["inkscape"]="1"
    ["krita"]="1"
    ["darktable"]="1"
    ["handbrake"]="1"
    ["audacity"]="1"
    ["mpv"]="1"
    ["iina"]="1"
)

# Function to check if a package is available in Homebrew
check_brew_availability() {
    local package="$1"
    
    # Check if package is in incompatible list
    if [[ -n "${BREW_INCOMPATIBLE[$package]:-}" ]]; then
        return 1
    fi
    
    # Check if package has a Homebrew equivalent
    if [[ -n "${BREW_EQUIVALENTS[$package]:-}" ]]; then
        return 0
    fi
    
    # Try to search for the package in Homebrew
    if brew search "^${package}$" >/dev/null 2>&1; then
        return 0
    fi
    
    return 1
}

# Generate macOS-compatible package list
generate_macos_packages() {
    local incompatible_packages=()
    local installable_packages=()
    
    if [ -f "${SCRIPT_DIR}/pkglist.txt" ]; then
        log "Processing Arch packages for macOS compatibility..."
        
        while IFS= read -r package; do
            # Skip empty lines and comments
            [[ -z "$package" || "$package" =~ ^#.*$ ]] && continue
            
            if check_brew_availability "$package"; then
                # Use equivalent name if available, otherwise use original
                local brew_name="${BREW_EQUIVALENTS[$package]:-$package}"
                if [[ -n "$brew_name" ]]; then
                    installable_packages+=("$brew_name")
                fi
            else
                incompatible_packages+=("$package")
            fi
        done < "${SCRIPT_DIR}/pkglist.txt"
    fi
    
    # Create Brewfile for installable packages
    if [ ${#installable_packages[@]} -gt 0 ]; then
        log "Creating Brewfile with compatible packages..."
        {
            echo "# Generated Brewfile from Arch package list"
            echo "# $(date)"
            echo ""
            echo "# Regular formulae (CLI tools)"
            for package in "${installable_packages[@]}"; do
                # Check if this package should be a cask
                local original_name=""
                # Find the original package name that mapped to this brew name
                for arch_pkg in "${!BREW_EQUIVALENTS[@]}"; do
                    if [[ "${BREW_EQUIVALENTS[$arch_pkg]}" == "$package" ]]; then
                        original_name="$arch_pkg"
                        break
                    fi
                done
                
                # Use original name if found, otherwise use the package name itself
                local check_name="${original_name:-$package}"
                
                if [[ -n "${BREW_CASKS[$check_name]:-}" ]]; then
                    # Skip casks in this section
                    continue
                else
                    echo "brew \"$package\""
                fi
            done
            
            echo ""
            echo "# GUI Applications (casks)"
            for package in "${installable_packages[@]}"; do
                # Check if this package should be a cask
                local original_name=""
                # Find the original package name that mapped to this brew name
                for arch_pkg in "${!BREW_EQUIVALENTS[@]}"; do
                    if [[ "${BREW_EQUIVALENTS[$arch_pkg]}" == "$package" ]]; then
                        original_name="$arch_pkg"
                        break
                    fi
                done
                
                # Use original name if found, otherwise use the package name itself
                local check_name="${original_name:-$package}"
                
                if [[ -n "${BREW_CASKS[$check_name]:-}" ]]; then
                    echo "cask \"$package\""
                fi
            done
        } > "${SCRIPT_DIR}/Brewfile.generated"
    fi
    
    # List incompatible packages
    if [ ${#incompatible_packages[@]} -gt 0 ]; then
        warn "The following packages are not available or not applicable on macOS:"
        for package in "${incompatible_packages[@]}"; do
            local reason="${BREW_INCOMPATIBLE[$package]:-Unknown reason}"
            echo "  ❌ $package - $reason"
        done
        
        # Save to file for reference
        {
            echo "# Packages not available on macOS"
            echo "# Generated on $(date)"
            echo ""
            for package in "${incompatible_packages[@]}"; do
                local reason="${BREW_INCOMPATIBLE[$package]:-Unknown reason}"
                echo "$package # $reason"
            done
        } > "${SCRIPT_DIR}/macos-incompatible.txt"
    fi
}

# Install packages based on OS
install_packages() {
    local os="$1"
    
    case "$os" in
        "arch")
            if [ -f "${SCRIPT_DIR}/pkglist.txt" ]; then
                log "Installing packages from pkglist.txt..."
                # Filter out empty lines and comments
                local packages=($(grep -v '^#\|^$' "${SCRIPT_DIR}/pkglist.txt" | tr '\n' ' '))
                if [ ${#packages[@]} -gt 0 ]; then
                    sudo pacman -Syu --needed --noconfirm "${packages[@]}"
                fi
            fi
            
            if [ -f "${SCRIPT_DIR}/pkglist-aur.txt" ] && command -v yay >/dev/null 2>&1; then
                log "Installing AUR packages..."
                local aur_packages=($(grep -v '^#\|^$' "${SCRIPT_DIR}/pkglist-aur.txt" | tr '\n' ' '))
                if [ ${#aur_packages[@]} -gt 0 ]; then
                    yay -S --needed --noconfirm "${aur_packages[@]}"
                fi
            fi
            ;;
        "macos")
            # Generate macOS-compatible package list
            generate_macos_packages
            
            # Install using existing Brewfile if available
            if [ -f "${SCRIPT_DIR}/Brewfile" ]; then
                log "Installing packages from existing Brewfile..."
                brew bundle --file="${SCRIPT_DIR}/Brewfile"
            elif [ -f "${SCRIPT_DIR}/Brewfile.generated" ]; then
                log "Installing packages from generated Brewfile..."
                brew bundle --file="${SCRIPT_DIR}/Brewfile.generated"
            fi
            ;;
        "debian")
            if [ -f "${SCRIPT_DIR}/packages-debian.txt" ]; then
                log "Installing packages from packages-debian.txt..."
                local debian_packages=($(grep -v '^#\|^$' "${SCRIPT_DIR}/packages-debian.txt" | tr '\n' ' '))
                if [ ${#debian_packages[@]} -gt 0 ]; then
                    sudo apt update && sudo apt install -y "${debian_packages[@]}"
                fi
            fi
            ;;
        *)
            warn "Unknown OS. Skipping package installation."
            ;;
    esac
    
    # Install pip packages if requirements.txt exists
    if [ -f "${SCRIPT_DIR}/requirements.txt" ] && command -v pip >/dev/null 2>&1; then
        log "Installing Python packages from requirements.txt..."
        pip install -r "${SCRIPT_DIR}/requirements.txt"
    fi
}

# Main bootstrap function
main() {
    log "Starting dotfiles bootstrap..."
    
    # Prompt for sudo password up front
    sudo -v
    
    # Detect OS
    OS=$(detect_os)
    log "Detected OS: $OS"
    
    # === 1. Clone dotfiles ===
    if [ ! -d "${HOME_DIR}/.dotfiles" ]; then
        log "Cloning dotfiles repository..."
        git clone --bare https://github.com/chrishandharmabandu/dotfiles.git "${HOME_DIR}/.dotfiles"
        
        function config {
           git --git-dir="${HOME_DIR}/.dotfiles/" --work-tree="${HOME_DIR}" "$@"
        }
        
        log "Backing up any pre-existing dotfiles..."
        mkdir -p "${HOME_DIR}/.dotfiles-backup"
        if config checkout; then
            log "Checked out dotfiles successfully."
        else
            warn "Backing up conflicting files..."
            config checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | while read -r file; do
                mkdir -p "$(dirname "${HOME_DIR}/.dotfiles-backup/$file")"
                mv "${HOME_DIR}/$file" "${HOME_DIR}/.dotfiles-backup/$file"
            done
            config checkout --force
        fi
        
        config config status.showUntrackedFiles no
    else
        log "Dotfiles already cloned. Updating..."
        config pull
    fi
    
    # === 2. Install packages ===
    install_packages "$OS"
    
    # === 3. Setup shell (only for Linux/macOS) ===
    if [ "$OS" != "unknown" ]; then
        if command -v zsh >/dev/null 2>&1; then
            log "Setting up Zsh plugins..."
            zsh_plug_dir="${HOME_DIR}/.zsh"
            mkdir -p "$zsh_plug_dir"
            
            declare -A plugins=(
                [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
                [fzf-tab]="https://github.com/Aloxaf/fzf-tab.git"
                [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
            )
            
            for name in "${!plugins[@]}"; do
                if [ ! -d "$zsh_plug_dir/$name" ]; then
                    log "Cloning ${name}..."
                    git clone "${plugins[$name]}" "$zsh_plug_dir/$name"
                fi
            done
            
            # Change default shell (Linux only)
            if [ "$OS" = "arch" ] && [ "$SHELL" != "$(which zsh)" ]; then
                log "Setting Zsh as default shell..."
                chsh -s "$(which zsh)"
            fi
        fi
        
        # === 4. Install fzf ===
        if [ ! -d "${HOME_DIR}/.fzf" ]; then
            log "Installing fzf..."
            git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME_DIR}/.fzf"
            yes | "${HOME_DIR}/.fzf/install" --all
        fi
    fi
    
    log "✅ Bootstrap completed successfully!"
    log "Please restart your shell or run 'source ~/.zshrc' to apply changes."
}

# Run main function
main "$@"

