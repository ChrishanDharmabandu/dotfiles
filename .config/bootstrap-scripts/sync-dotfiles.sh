#!/usr/bin/env bash

# Sync dotfiles with git repository
# This script helps with common dotfile operations

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Define config alias function
config() {
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

# Show usage
show_usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  status    - Show git status"
    echo "  add       - Add all changes"
    echo "  commit    - Commit with message"
    echo "  push      - Push changes"
    echo "  pull      - Pull changes"
    echo "  auto      - Add, commit, and push automatically"
    echo "  diff      - Show differences"
    echo "  log       - Show commit log"
    echo ""
    echo "Examples:"
    echo "  $0 status"
    echo "  $0 commit 'Update config'"
    echo "  $0 auto"
}

# Main function
main() {
    local cmd="${1:-status}"
    
    # Check if dotfiles repo exists
    if [ ! -d "$HOME/.dotfiles" ]; then
        error "Dotfiles repository not found. Run bootstrap script first."
        exit 1
    fi
    
    case "$cmd" in
        "status")
            config status
            ;;
        "add")
            config add -u
            log "Changes staged"
            ;;
        "commit")
            local message="${2:-auto-update $(date)}"
            config commit -m "$message"
            log "Changes committed: $message"
            ;;
        "push")
            config push
            log "Changes pushed to repository"
            ;;
        "pull")
            config pull
            log "Changes pulled from repository"
            ;;
        "auto")
            log "Adding changes..."
            config add -u
            
            if config diff --cached --quiet; then
                warn "No changes to commit"
            else
                log "Committing changes..."
                config commit -m "auto-update $(date '+%Y-%m-%d %H:%M:%S')"
                
                log "Pushing changes..."
                config push
                
                log "Auto-sync completed successfully!"
            fi
            ;;
        "diff")
            config diff
            ;;
        "log")
            config log --oneline -10
            ;;
        "-h"|"--help")
            show_usage
            ;;
        *)
            error "Unknown command: $cmd"
            show_usage
            exit 1
            ;;
    esac
}

main "$@"

