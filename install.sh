#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
# Add packages you want to install here
PACKAGES=(
    "neovim"
    "fzf"
    "zsh"
    "git"
)

# --- Script Start ---
echo "Starting dotfiles setup..."

# --- Package Installation ---
install_packages() {
    echo "---"
    echo "Installing packages..."
    
    # Check for Arch Linux (pacman)
    if command -v pacman &> /dev/null; then
        echo "Detected Arch Linux."
        
        # Check for yay, otherwise use pacman
        if command -v yay &> /dev/null;
        then
            echo "Using 'yay' to install packages."
            yay -Syu --noconfirm "${PACKAGES[@]}"
        else
            echo "Using 'pacman' to install packages. You may be prompted for your password."
            sudo pacman -Syu --noconfirm "${PACKAGES[@]}"
        fi
    # Add checks for other OSes here (e.g., Debian/Ubuntu, macOS)
    # elif command -v apt-get &> /dev/null; then
    #     echo "Detected Debian/Ubuntu."
    #     sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}"
    else
        echo "WARNING: Could not detect package manager. Please install packages manually:"
        echo "${PACKAGES[@]}"
    fi
    echo "Package installation complete."
}

# --- Symlinking ---
link_files() {
    echo "---"
    echo "Linking configuration files..."
    
    # Directory where this script is located
    local DOTFILES_DIR
    DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    local BACKUP_DIR=~/dotfiles_backup_$(date +%Y%m%d_%H%M%S)

    echo "Your existing dotfiles will be backed up to: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    # Function to create a symlink, backing up the original if it exists
    _link_single_file() {
        local source="$DOTFILES_DIR/$1"
        local target="$HOME/$2"

        if [ ! -d "$(dirname "$target")" ]; then
            echo "-> Creating directory $(dirname "$target")"
            mkdir -p "$(dirname "$target")"
        fi

        if [ -e "$target" ] || [ -L "$target" ]; then
            echo "-> Backing up existing $target to $BACKUP_DIR"
            mv "$target" "$BACKUP_DIR/"
        fi

        echo "-> Linking $source to $target"
        ln -s "$source" "$target"
        echo "   ...done"
    }

    # --- List of files to link ---
    _link_single_file "nvim" ".config/nvim"
    _link_single_file ".zshrc" ".zshrc"
    # Add more files here in the future
    # _link_single_file ".gitconfig" ".gitconfig"

    echo "File linking complete."
}


# --- Main Execution ---
install_packages
link_files

echo "---"
echo "✅ Dotfiles setup complete!"
echo "You may need to restart your shell for all changes to take effect."