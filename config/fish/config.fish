if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Disable greeting
set -U fish_greeting

# Aliases
abbr --add db distrobox
abbr --add ff fastfetch
abbr --add venv pyenv activate
abbr --add lvenv source ./venv/bin/activate.fish
abbr --add mklvenv python3 -m venv venv
alias vim="nvim"
alias vi="/usr/bin/vim"
alias ls="eza --icons=always"
alias l=ls
alias pwninit="pwninit --template-path ~/.config/solve.py"
alias codium="flatpak run com.vscodium.codium"
alias cat="bat -p -P"

if test "$CONTAINER_ID" = "kali"
    alias cat="batcat -p -P"
end

# Use starship prompt
starship init fish | source
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml

# Variables
set -x EDITOR nvim
set -x VISUAL nvim

# Zoxide
zoxide init fish --cmd j | source

fish_add_path $PYENV_ROOT/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/Applications/
fish_add_path $HOME/.gem/bin/

if test -z "$CONTAINER_ID"
    # Pyenv
    set -Ux PYENV_ROOT $HOME/.pyenv
    pyenv init - | source
    status --is-interactive; and pyenv virtualenv-init - | source
end

# Rbenv
set -x GEM_HOME $HOME/.gem

# Wal
#wal -R
#cat $HOME/.cache/wal/sequences
source ~/.cache/wal/colors.fish
