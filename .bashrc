# Enable Vi mode
set -o vi

# Sourcing
source ~/.alias

#export path
export PATH="/home/$USER/.local/share/gem/ruby/3.0.0/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/squishy-macos/.lmstudio/bin"
# End of LM Studio CLI section


# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/squishy/.lmstudio/bin"
# End of LM Studio CLI section

