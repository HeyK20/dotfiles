#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BACKUP_DIR=~/dotfiles_backup_$(date +%Y%m%d_%H%M%S)

echo "Dotfiles installation script"
echo "============================"
echo "Your existing dotfiles will be backed up to: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Function to create a symlink, backing up the original if it exists
# Arguments:
#   $1: source file/dir in the dotfiles repo (e.g., nvim)
#   $2: target path in the home directory (e.g., .config/nvim)
link_file() {
    local source="$DOTFILES_DIR/$1"
    local target="$HOME/$2"

    # If the target's directory doesn't exist, create it
    if [ ! -d "$(dirname "$target")" ]; then
        echo "-> Creating directory $(dirname "$target")"
        mkdir -p "$(dirname "$target")"
    fi

    # If the target already exists, back it up
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "-> Backing up existing $target to $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    fi

    echo "-> Linking $source to $target"
    ln -s "$source" "$target"
    echo "   ...done"
}

# --- List of files to link ---
# Format: link_file "source_in_repo" "destination_in_home"

link_file "nvim" ".config/nvim"
link_file ".zshrc" ".zshrc"

# Add more files here in the future
# link_file ".gitconfig" ".gitconfig"
# link_file "kitty" ".config/kitty"

echo ""
echo "✅ Dotfiles setup complete!"
