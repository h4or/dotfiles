#!/bin/bash

set -e  # Exit on any error

# Define directories
DOTFILES_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config/h4orwm"
BACKUP_DIR="$HOME/dotfiles_backup"
CHECK_FILE="$HOME/.dotfiles_installed"

# Ensure the script is run as a non-root user
if [ "$EUID" -eq 0 ]; then
    echo "Please run this script as a regular user, not as root."
    exit 1
fi

# 1. Check if the script has been run before (using a checkpoint file)
if [ -f "$CHECK_FILE" ]; then
    echo "The script has already been run. Exiting..."
    exit 0
fi

# 2. Update system and install prerequisites using yay (AUR & official)
echo "Updating system and installing dependencies with yay..."

# Ensure yay is installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install all required dependencies using yay
yay -S --needed --noconfirm \
    libxinerama \
    libfontconfig \
    libx11 \
    libxft \
    ttf-dejavu \
    ttf-liberation \
    xorg-fonts-75dpi \
    xorg-fonts-100dpi \
    kitty \
    pavucontrol \
    xclip \
    maim \
    thunar \
    feh \
    picom \
    dunst \
    libx11 \
	htop \
	google-chrome \
	noto-fonts \
	noto-fonts-emoji \
	adapta-gtk-theme

# 3. Setup configuration files
echo "Setting up configuration files..."
mkdir -p "$CONFIG_DIR"
cp -r "$DOTFILES_DIR/config/"* "$HOME/.config/"
cp -r "$DOTFILES_DIR/dmenu" "$CONFIG_DIR/"
cp -r "$DOTFILES_DIR/dwm" "$CONFIG_DIR/"
cp -r "$DOTFILES_DIR/pictures" "$CONFIG_DIR/"
cp -r "$DOTFILES_DIR/scripts" "$CONFIG_DIR/"
cp -r "$DOTFILES_DIR/slstatus" "$CONFIG_DIR/"

# Clone Neovim configuration
NVIM_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_DIR" ]; then
    echo "Backing up existing Neovim configuration..."
    mv "$NVIM_DIR" "$BACKUP_DIR/"
fi
echo "Cloning Neovim configuration into $NVIM_DIR..."
git clone https://github.com/h4or/nvim-config.git "$NVIM_DIR"

# Extract the `home` folder to ~/
echo "Extracting home folder contents to $HOME..."
cp -r "$DOTFILES_DIR/home/." "$HOME/"

# 4. Install Zsh and Oh My Zsh (only if not installed)
if ! command -v zsh &> /dev/null; then
    echo "Installing Zsh..."
    yay -S --noconfirm zsh
fi

backup_and_remove() {
    if [ -e "$1" ]; then
        echo "Backing up $1 to $BACKUP_DIR"
        mv "$1" "$BACKUP_DIR"
    fi
}

backup_and_remove "$HOME/.bashrc"
backup_and_remove "$HOME/.bash_profile"
backup_and_remove "$HOME/.bash_logout"
chsh -s "$(which zsh)"  # Change default shell to Zsh

echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed. Skipping installation."
fi

echo "Replacing Oh My Zsh default .zshrc with custom version..."
cp "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"

# 5. Build and install dwm, dmenu, and slstatus (check if already installed)
echo "Building and installing dwm, dmenu, and slstatus..."
for folder in dwm dmenu slstatus; do
    echo "Installing $folder..."
    if [ ! -d "$CONFIG_DIR/$folder/.installed" ]; then
        (cd "$CONFIG_DIR/$folder" && sudo make clean install)
        touch "$CONFIG_DIR/$folder/.installed"  # Mark folder as installed
    else
        echo "$folder is already installed. Skipping."
    fi
done

# Create checkpoint file to prevent running the script again
touch "$CHECK_FILE"

echo "Dotfiles setup completed successfully!"

