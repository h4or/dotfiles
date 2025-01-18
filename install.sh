#!/bin/bash

set -e  # Exit on any error

# Define directories
DOTFILES_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config/h4orwm"
BACKUP_DIR="$HOME/dotfiles_backup"

# Ensure the script is run as a non-root user
if [ "$EUID" -eq 0 ]; then
    echo "Please run this script as a regular user, not as root."
    exit 1
fi

# 1. Update system and install prerequisites
echo "Updating system and installing prerequisites..."
sudo pacman -Syu --noconfirm
if ! grep -q "\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i '/#\[multilib\]/,+1s/^#//' /etc/pacman.conf
    sudo pacman -Syu --noconfirm
fi
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S --noconfirm yay
fi

# 2. Backup existing dotfiles
echo "Creating backup of existing dotfiles..."
mkdir -p "$BACKUP_DIR"

backup_and_remove() {
    if [ -e "$1" ]; then
        echo "Backing up $1 to $BACKUP_DIR"
        mv "$1" "$BACKUP_DIR"
    fi
}

# 3. Setup configuration files
echo "Setting up configuration files..."
mkdir -p "$CONFIG_DIR"
cp -r "$DOTFILES_DIR/config/"* "$HOME/.config/"
cp -r "$DOTFILES_DIR/dmenu" "$CONFIG_DIR/"
cp -r "$DOTFILES_DIR/dwm" "$CONFIG_DIR/"
cp -r "$DOTFILES_DIR/pictures" "$CONFIG_DIR/"
cp -r "$DOTFILES_DIR/scripts" "$CONFIG_DIR/"
cp -r "$DOTFILES_DIR/slstatus" "$CONFIG_DIR/"

# Extract the `home` folder to ~/
echo "Extracting home folder contents to $HOME..."
cp -r "$DOTFILES_DIR/home/." "$HOME/"

# 4. Install Zsh and Oh My Zsh
echo "Installing Zsh and Oh My Zsh..."
sudo pacman -S --noconfirm zsh
backup_and_remove "$HOME/.bashrc"
backup_and_remove "$HOME/.bash_profile"
backup_and_remove "$HOME/.bash_logout"
chsh -s "$(which zsh)"  # Change default shell to Zsh

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Replacing Oh My Zsh default .zshrc with custom version..."
cp "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"

# 5. Build and install dwm, dmenu, and slstatus
echo "Building and installing dwm, dmenu, and slstatus..."
for folder in dwm dmenu slstatus; do
    echo "Installing $folder..."
    (cd "$CONFIG_DIR/$folder" && sudo make install)
done

echo "Dotfiles setup completed successfully!"

