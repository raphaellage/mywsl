eval "$(~/.homebrew/bin/brew shellenv)"

source ~/.profile
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

export PATH="$HOME/.local/bin:$PATH"

eval "$(starship init zsh)"

# aliases
alias ls="exa  --icons"
alias cat="bat"