export PATH="$HOME/.local/bin:$PATH"

# fzf shell integration (Ctrl+R for history, Ctrl+T for files, Alt+C for cd)
source <(fzf --zsh)

# Aliases - drop-in replacements with nicer defaults
alias cat='bat'
alias ls='eza'
alias ll='eza -la'
alias la='eza -a'

# bun completions
[ -s "/Users/timlawson/.bun/_bun" ] && source "/Users/timlawson/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
