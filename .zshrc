# ~/.zshrc
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"
export EDITOR=nvim
export TERMINAL=alacritty

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias n='nvim'
alias h='hyprctl'

# starship prompt (only if installed: sudo pacman -S starship)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  PS1='[%n@%m %1~]$ '
fi
