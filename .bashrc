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
