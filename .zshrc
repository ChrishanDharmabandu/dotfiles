# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Enable Vi mode
set -o vi

# Use modern completion system
autoload -U compinit; compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Sourcing
source ~/.alias
source ~/.zsh/
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

#starship
eval "$(starship init zsh)"
# zoxide (cd repalcement)
eval "$(zoxide init zsh)"

#FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Exports tools
export EDITOR=nvim
export PAGER='less -R'
export TERM="xterm-256color"

# Man page fix
# Define ANSI escape codes for less
export LESS_TERMCAP_mb=$'\e[01;31m'  # Bold
export LESS_TERMCAP_md=$'\e[01;38;5;7m' # Another bold/bright style
export LESS_TERMCAP_me=$'\e[0m'       # Reset all attributes
export LESS_TERMCAP_se=$'\e[0m'       # End standout mode
export LESS_TERMCAP_so=$'\e[01;44;33m' # Standout (e.g., yellow text on blue background for sections)
export LESS_TERMCAP_us=$'\e[04;37m'   # Underline
export LESS_TERMCAP_ue=$'\e[0m'       # End underline

# Tell 'man' to use 'less' and interpret raw control characters
export MANPAGER='less -R'
# Export path
# Prioritize user-installed language binaries and then custom local scripts
export PATH="$HOME/.local/bin:$PATH" # Custom scripts first
export PATH="$HOME/.local/bin/scripts:$PATH" # Custom scripts first
export PATH="$HOME/.cargo/bin:$PATH" # Rust binaries
export PATH="/home/$USER/.local/share/gem/ruby/3.0.0/bin:$PATH" # Ruby Gems binaries

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Only alias on macOS (Darwin)
if [[ "$(uname)" == "Darwin" ]]; then
  alias python="python3"
  alias pip="pip3"
fi

# fast fetch on load
fastfetch
cowsay 'HAVE YOU TMUXED, DO YOU NEED TO TMUX?'

# >>>>>> custom todolist
# Print the contents of the .todo.md file, using a more explicit method:
echo "$(bat ~/todo.hl.md)"
# <<<<<< custom todolist

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/squishy-macos/.lmstudio/bin"
# End of LM Studio CLI section

alias nproc="gnproc"
