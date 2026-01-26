#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$1" dst="$2"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        mv "$dst" "$dst.backup"
        echo "Backed up $dst to $dst.backup"
    fi
    ln -s "$src" "$dst"
}

link "$DOTFILES/config/ghostty" ~/.config/ghostty
link "$DOTFILES/config/yabai" ~/.config/yabai
link "$DOTFILES/config/skhd" ~/.config/skhd
link "$DOTFILES/zshrc" ~/.zshrc
link "$DOTFILES/ssh_config" ~/.ssh/config

echo "dotfiles: installed..."