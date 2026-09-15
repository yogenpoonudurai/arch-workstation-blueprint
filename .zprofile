# ~/.zprofile — zsh login, UWSM autostart (mirrors ~/.bash_profile)
[[ -f ~/.zshrc ]] && . ~/.zshrc

if uwsm check may-start -q; then
  exec uwsm start hyprland.desktop
fi
