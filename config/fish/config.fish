# Disable greeting
set -U fish_greeting

# Don't run if in container
if test -n "$CONTAINER_ID"
    exit
end

# OS-specific
if status is-interactive
    if string match -q "/byu*" $HOME
        # BYU
        source "$HOME/.config/fish/byu.fish"
    else
        switch $(uname)
            case Linux
                # Linux
                source "$HOME/.config/fish/linux.fish"
            case Darwin
                # MacOS
                source "$HOME/.config/fish/darwin.fish"
        end
    end
end

### Common between Linux and MacOS ###
fish_add_path $HOME/.local/bin/

# Set editor/visual
if type -q nvim
    set -x EDITOR nvim
    set -x VISUAL nvim
else if type -q vim
    set -x EDITOR vim
    set -x VISUAL vim
end

# Fix kitty terminal
if string match -q "xterm-kitty" $TERM
    set -x TERM xterm-256color
end

# Generic aliases
alias l=ls
alias c=clear
type -q ranger; and alias r="ranger"
type -q vim; and alias vi=$(which vim)
type -q nvim; and alias vim="nvim"
type -q eza; and alias ls="eza --icons=always"
type -q moor; and alias less="moor"
type -q fastfetch; and abbr --add ff fastfetch
type -q bat; and alias cat="bat -p -P"
type -q batcat; and alias cat="batcat -p -P"

# Init Zoxide
type -q zoxide; and zoxide init fish --cmd j | source

# Pretty root shell
alias ssu="sudo --preserve-env=HOME -i"

# Init starship prompt
if type -q starship
    starship init fish | source
    set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
end

# Init pyenv
if type -q pyenv
    abbr --add venv pyenv activate
    set -Ux PYENV_ROOT $HOME/.pyenv
    test -d $PYENV_ROOT/bin; and fish_add_path $PYENV_ROOT/bin
    pyenv init - fish | source
end

