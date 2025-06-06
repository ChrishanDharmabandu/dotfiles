#!/usr/bin/env bash

# Update package lists with recently installed packages
# This script helps maintain current package lists

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}
# Function to get all explicitly installed packages
get_all_packages() {
    if command -v pacman > /dev/null 2>&1; then
        log "Getting all explicitly installed packages..."
        
        # Get all explicitly installed packages
        all_packages=$(pacman -Qe | awk '{print $1}' | sort)
        
        if [ -n "$all_packages" ]; then
            echo "$all_packages"
        else
            warn "No explicitly installed packages found"
        fi
    else
        warn "pacman not found. This script is designed for Arch-based systems."
    fi
}

# Function to get pip packages
get_pip_packages() {
    if command -v pip > /dev/null 2>&1; then
        log "Getting pip packages..."
        
        # Get all pip packages (excluding pip, setuptools, wheel which are often base packages)
        pip_packages=$(pip list --format=freeze | grep -v -E '^(pip|setuptools|wheel)==' | sort)
        
        if [ -n "$pip_packages" ]; then
            echo "$pip_packages"
        else
            log "No pip packages found (excluding base packages)"
        fi
    else
        log "pip not found, skipping pip package list generation"
    fi
}

# Function to update package lists
update_package_lists() {
    local recent_packages="$1"
    
    # Check which packages are AUR packages
    aur_packages=""
    official_packages=""
    
    while read -r pkg; do
        if pacman -Si "$pkg" > /dev/null 2>&1; then
            official_packages+="$pkg\n"
        else
            aur_packages+="$pkg\n"
        fi
    done <<< "$recent_packages"

    # Rewrite official package list
    log "Rewriting official package list..."
    printf "%b" "$official_packages" > "${SCRIPT_DIR}/pkglist.txt" 
    
    # Rewrite AUR package list
    log "Rewriting AUR package list..."
    printf "%b" "$aur_packages" > "${SCRIPT_DIR}/pkglist-aur.txt"
}

# Main function
main() {
    log "Capturing all explicitly installed packages..."
    
    # Update pacman packages
    all_packages=$(get_all_packages)
    update_package_lists "$all_packages"
    
    # Update pip packages
    pip_packages=$(get_pip_packages)
    if [ -n "$pip_packages" ]; then
        log "Rewriting pip requirements file..."
        echo "$pip_packages" > "${SCRIPT_DIR}/requirements.txt"
    fi
    
    log "Package lists updated successfully!"
    log "Files updated:"
    log "  - pkglist.txt (official packages)"
    log "  - pkglist-aur.txt (AUR packages)"
    if [ -n "$pip_packages" ]; then
        log "  - requirements.txt (pip packages)"
    fi
    log "Review the changes and commit them to your dotfiles repo."
}

# Show usage if help requested
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    echo "Usage: $0"
    echo "  Captures all explicitly installed packages and rewrites package lists"
    echo ""
    echo "This script will:"
    echo "  - Get all explicitly installed packages (pacman)"
    echo "  - Separate them into official repos and AUR packages"
    echo "  - Get all pip packages"
    echo "  - Completely rewrite pkglist.txt, pkglist-aur.txt, and requirements.txt"
    exit 0
fi

main "$@"

