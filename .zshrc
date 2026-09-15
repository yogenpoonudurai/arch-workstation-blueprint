# ~/.zshrc — OMZ + starship, keyboard-first, Hyprland-safe
# Login autostart lives in ~/.zprofile (uwsm) — do not add exec/login logic here.
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"
export EDITOR=nvim
export TERMINAL=alacritty
# Toolchain bins (user-space installs)
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in *":$PNPM_HOME/bin:"*) ;; *) export PATH="$PNPM_HOME/bin:$PATH" ;; esac
case ":$PATH:" in *":$HOME/go/bin:"*) ;; *) export PATH="$HOME/go/bin:$PATH" ;; esac
case ":$PATH:" in *":$HOME/.cargo/bin:"*) ;; *) export PATH="$HOME/.cargo/bin:$PATH" ;; esac

# mise + direnv (activate when installed via pacman)
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd z)"

# --- Oh-My-Zsh (plugins only; prompt via starship) ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(
  git
  archlinux
  sudo
  history
  history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# --- Completion: case-insensitive, menu select, cache ---
zmodload zsh/complist 2>/dev/null || true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"
mkdir -p "$HOME/.cache/zsh"

# --- History: large, shared, persistent ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history inc_append_history extended_history
setopt hist_ignore_dups hist_ignore_all_dups hist_ignore_space hist_verify hist_reduce_blanks
# Up/Down → substring search (type prefix, then Up)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# --- Suggestions: ghost text, accept with Ctrl+Space or → ---
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
bindkey '^ ' autosuggest-accept
bindkey '^[[C' forward-char 2>/dev/null || true

# --- Aliases ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias n='nvim'
alias h='hyprctl'
# Silent AUR installs (bare `yay` stays interactive so -Syu never runs unattended)
alias yayi='yay -S --noconfirm --answerdiff None --answerclean None'

# --- fzf integration (installed) ---
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
# Ctrl+R fuzzy history via fzf when available
if command -v fzf >/dev/null 2>&1; then
  fzf-history-widget() { print -z "$(fc -rl 1 | awk '{$1=""; print substr($0,2)}' | fzf --tac --query="$BUFFER")"; }
  zle -N fzf-history-widget 2>/dev/null || true
fi

# --- Prompt: starship preferred, minimal fallback ---
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  PS1='[%n@%m %1~]$ '
fi
