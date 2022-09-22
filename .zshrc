eval "$(~/.homebrew/bin/brew shellenv)"

source ~/.profile
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export PATH="$HOME/.local/bin:$PATH"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

eval "$(starship init zsh)"

# aliases
alias ls="exa  --icons"
alias cat="bat"