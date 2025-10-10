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
abbr --add dc docker compose
alias l=ls
alias r=ranger
alias pwninit="pwninit --template-path ~/.config/solve.py"
alias cat="bat -p -P"

if test "$CONTAINER_ID" = "kali"; or test "$CONTAINER_ID" = "ubuntu"
    alias cat="batcat -p -P"
end

# Variables
set -x EDITOR nvim
set -x VISUAL nvim
set -x TERM xterm-256color # for kitty terminal
set -x BN_USER_DIRECTORY "~/.config/binaryninja/"

fish_add_path $PYENV_ROOT/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/Applications/
fish_add_path $HOME/.gem/bin/
fish_add_path $HOME/Applications/codeql/

if test -z "$CONTAINER_ID"
    # Use starship prompt
    starship init fish | source
    set -x STARSHIP_CONFIG ~/.config/starship/starship.toml

    # Init Zoxide
    zoxide init fish --cmd j | source

    # Aliases
    alias vi="/usr/bin/vim"
    alias ls="eza --icons=always"
    alias less="moor"
    alias vim="nvim"

    # Pyenv
    set -Ux PYENV_ROOT $HOME/.pyenv
    pyenv init - | source
    status --is-interactive; and pyenv virtualenv-init - | source

    # Rbenv
    set -x GEM_HOME $HOME/.gem
    status --is-interactive; and rbenv init - --no-rehash fish | source
end


# Wal
#wal -R
#cat $HOME/.cache/wal/sequences
source ~/.cache/wal/colors.fish
