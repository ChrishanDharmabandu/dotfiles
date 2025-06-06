#!/usr/bin/env bash

# Generate Brewfile for macOS from Arch package lists
# This creates a rough equivalent for macOS users

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${SCRIPT_DIR}/Brewfile"

# Common package mappings from Arch to Homebrew
declare -A pkg_map=(
    ["git"]="git"
    ["neovim"]="neovim"
    ["tmux"]="tmux"
    ["zsh"]="zsh"
    ["curl"]="curl"
    ["wget"]="wget"
    ["ripgrep"]="ripgrep"
    ["nodejs"]="node"
    ["npm"]="npm"
    ["python"]="python@3.12"
    ["firefox"]="--cask firefox"
    ["discord"]="--cask discord"
    ["obsidian"]="--cask obsidian"
    ["spotify"]="--cask spotify"
    ["kitty"]="--cask kitty"
    ["alacritty"]="--cask alacritty"
    ["wezterm"]="--cask wezterm"
    ["bitwarden"]="--cask bitwarden"
    ["docker"]="--cask docker"
    ["starship"]="starship"
    ["zoxide"]="zoxide"
    ["btop"]="btop"
    ["yazi"]="yazi"
)

# Generate Brewfile
generate_brewfile() {
    echo "# Generated Brewfile for macOS" > "$BREWFILE"
    echo "# Based on Arch Linux package lists" >> "$BREWFILE"
    echo "" >> "$BREWFILE"
    
    if [ -f "${SCRIPT_DIR}/pkglist.txt" ]; then
        echo "# Core packages" >> "$BREWFILE"
        while read -r pkg; do
            if [ -n "$pkg" ] && [[ ! "$pkg" =~ ^#.* ]]; then
                if [ "${pkg_map[$pkg]:-}" ]; then
                    echo "brew \"${pkg_map[$pkg]}\"" >> "$BREWFILE"
                fi
            fi
        done < "${SCRIPT_DIR}/pkglist.txt"
    fi
    
    echo "" >> "$BREWFILE"
    echo "# Additional GUI applications" >> "$BREWFILE"
    echo "brew \"--cask visual-studio-code\"" >> "$BREWFILE"
    echo "brew \"--cask rectangle\"" >> "$BREWFILE"
    echo "brew \"--cask raycast\"" >> "$BREWFILE"
    
    echo "Brewfile generated at: $BREWFILE"
}

generate_brewfile

