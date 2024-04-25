# Enable Vi mode
set -o vi

# Sourcing
source ~/.alias

#starship
eval "$(starship init bash)"
#zoxide (cd replacement)
eval "$(zoxide init bash)"

#FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"

# Exports
export TERM=kitty
export TERMINAL=kitty
export BROWSER=brave-browser
export EDITOR=nvim

#export path
export PATH="/home/$USER/.local/share/gem/ruby/3.0.0/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"
