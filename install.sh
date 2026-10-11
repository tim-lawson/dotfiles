#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$1" dst="$2" backup
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
        mv "$dst" "$backup"
        echo "Backed up $dst to $backup"
    fi
    ln -s "$src" "$dst"
}

if ! command -v brew >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

for brew_prefix in /opt/homebrew /usr/local; do
    if [ -x "$brew_prefix/bin/brew" ]; then
        eval "$("$brew_prefix/bin/brew" shellenv)"
        break
    fi
done

# Untrusted third-party tap; brew won't load its formulae otherwise.
brew tap asmvik/formulae
brew trust asmvik/formulae

brew bundle --file="$DOTFILES/Brewfile"

if ! command -v uv >/dev/null 2>&1; then
    # No PATH edits: zshrc handles it, and ~/.zshrc may be a symlink into here.
    curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
fi
export PATH="$HOME/.local/bin:$PATH"

link "$DOTFILES/config/ghostty" ~/.config/ghostty
link "$DOTFILES/config/yabai" ~/.config/yabai
link "$DOTFILES/config/skhd" ~/.config/skhd
link "$DOTFILES/zshenv" ~/.zshenv
link "$DOTFILES/zprofile" ~/.zprofile
link "$DOTFILES/zshrc" ~/.zshrc
link "$DOTFILES/ssh_config" ~/.ssh/config
link "$DOTFILES/beets/config.yaml" ~/.config/beets/config.yaml
chmod 700 ~/.ssh

# config.yaml includes this; keep the token out of the repo. The placeholder has
# to be non-empty or the discogs plugin falls back to OAuth and prompts for input
# on every beets command.
if [ ! -e ~/.config/beets/secrets.yaml ]; then
    printf 'discogs:\n  user_token: REPLACE_ME\n' > ~/.config/beets/secrets.yaml
fi
chmod 600 ~/.config/beets/secrets.yaml

uv tool install --python 3.12 \
    --constraints "$DOTFILES/beets/constraints.txt" \
    --with-requirements "$DOTFILES/beets/plugins.txt" \
    beets

cat <<'EOF'

dotfiles: installed. Remaining manual steps:

  1. Grant Accessibility to yabai and skhd
     System Settings > Privacy & Security > Accessibility

  2. Add the yabai sudoers rule (redo after every yabai upgrade):
     echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d ' ' -f 1) $(which yabai) --load-sa"
     sudo visudo -f /private/etc/sudoers.d/yabai

  3. yabai --start-service && skhd --start-service

  4. ssh-keygen -t ed25519
EOF
