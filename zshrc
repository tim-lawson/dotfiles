export PATH="$HOME/.local/bin:$PATH"

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# Aliases
alias cat='bat'
alias ls='eza'
alias ll='eza -la'
alias la='eza -a'

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
if [ -s "$BUN_INSTALL/_bun" ]; then
    source "$BUN_INSTALL/_bun"
fi

# Photo import. ~/.zshrc is a symlink into the repo, and :A resolves it.
source "${${:-$HOME/.zshrc}:A:h}/photos.zsh"
