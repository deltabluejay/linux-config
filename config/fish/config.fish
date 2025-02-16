if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Disable greeting
set -U fish_greeting

# Aliases
abbr --add db distrobox
abbr --add venv pyenv activate
abbr --add ff fastfetch
alias vim="nvim"
alias vi="/usr/bin/vim"
alias ls="eza --icons=always"
alias l=ls
alias pwninit="pwninit --template-path ~/.config/solve.py"
alias codium="flatpak run com.vscodium.codium"

# Use starship prompt
starship init fish | source
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml

# Variables
set -x EDITOR nvim
set -x VISUAL nvim

# Zoxide
zoxide init fish --cmd j | source

# Pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/Applications/
pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

# Rbenv
set -x GEM_HOME $HOME/.gem

# Wal
#wal -R
#cat $HOME/.cache/wal/sequences
source ~/.cache/wal/colors.fish
