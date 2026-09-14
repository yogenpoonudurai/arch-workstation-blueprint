# ~/.zshrc
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"
export EDITOR=nvim
export TERMINAL=alacritty

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias n='nvim'
alias h='hyprctl'

# minimal prompt
PS1='[%n@%m %1~]$ '
