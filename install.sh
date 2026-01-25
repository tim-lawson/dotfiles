#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Create symlinks
ln -sf "$DOTFILES/config/ghostty" ~/.config/ghostty
ln -sf "$DOTFILES/config/yabai" ~/.config/yabai
ln -sf "$DOTFILES/config/skhd" ~/.config/skhd
ln -sf "$DOTFILES/zshrc" ~/.zshrc
ln -sf "$DOTFILES/ssh_config" ~/.ssh/config

echo "dotfiles: installed...\\n"