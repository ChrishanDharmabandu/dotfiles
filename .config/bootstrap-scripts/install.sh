#!/usr/bin/env bash

# One-liner installer script
# Usage: curl -fsSL https://raw.githubusercontent.com/chrishandharmabandu/dotfiles/master/.config/bootstrap-scripts/install.sh | bash

set -euo pipefail

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Create temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

log "Downloading bootstrap script..."
curl -fsSL https://raw.githubusercontent.com/chrishandharmabandu/dotfiles/master/.config/bootstrap-scripts/bootstrap.sh -o bootstrap.sh

log "Making script executable..."
chmod +x bootstrap.sh

log "Running bootstrap..."
./bootstrap.sh

# Cleanup
cd /
rm -rf "$TMP_DIR"

log "Installation complete!"

