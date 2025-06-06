# Bootstrap Scripts

This directory contains scripts to set up dotfiles and packages across different operating systems.

## Files

- `bootstrap.sh` - Main bootstrap script (works on Arch/CachyOS, macOS, Debian)
- `pkglist.txt` - Official Arch/CachyOS packages
- `pkglist-aur.txt` - AUR packages
- `update-packages.sh` - Update package lists with recently installed packages
- `generate-brewfile.sh` - Generate macOS Brewfile from Arch package lists
- `Brewfile` - macOS package list (generated)

## Usage

### Quick Setup (Curl)

```bash
# Download and run bootstrap script
curl -fsSL https://raw.githubusercontent.com/chrishandharmabandu/dotfiles/master/.config/bootstrap-scripts/bootstrap.sh | bash
```

### Manual Setup

```bash
# Clone repository
git clone https://github.com/chrishandharmabandu/dotfiles.git
cd dotfiles/.config/bootstrap-scripts

# Make scripts executable
chmod +x *.sh

# Run bootstrap
./bootstrap.sh
```

### Update Package Lists

```bash
# Check packages installed in last 7 days
./update-packages.sh

# Check packages installed in last 14 days
./update-packages.sh 14
```

### For macOS Users

```bash
# Generate Brewfile from Arch package lists
./generate-brewfile.sh

# Install packages
brew bundle --file=Brewfile
```

## Platform Support

- **Arch Linux/CachyOS**: Full support with pacman and AUR
- **macOS**: Homebrew support with package mapping
- **Debian/Ubuntu**: Basic apt support (manual package list needed)

## Notes

- Scripts use relative paths for portability
- Package lists are automatically maintained
- Bootstrap script detects OS and adapts accordingly
- SSH keys need to be set up separately for git operations

