#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# Silent AUR installs (bare `yay` stays interactive so -Syu never runs unattended)
alias yayi='yay -S --noconfirm --answerdiff None --answerclean None'

# starship prompt (only if installed: sudo pacman -S starship)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
else
  PS1='[\u@\h \W]\$ '
fi

# opencode
export PATH=/home/yp/.opencode/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
