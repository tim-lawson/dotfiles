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

# Completions. ~/.zfunc is untracked: tools generate their scripts into it on
# each machine (e.g. `fin --install-completion` writes _fin). Keep the next line
# verbatim -- Typer's installer appends it to ~/.zshrc (this file) if missing.
fpath+=~/.zfunc; autoload -Uz compinit; compinit
zstyle ':completion:*' menu select
