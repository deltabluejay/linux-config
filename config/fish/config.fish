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
	    exit
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
# Set editor/visual
if type -q nvim
    set -x EDITOR nvim
    set -x VISUAL nvim
else if type -q vim
    set -x EDITOR vim
    set -x VISUAL vim
end

# Generic aliases
alias l=ls
type -q ranger; and alias r="ranger"
type -q vim; and alias vi="vim"
type -q nvim; and alias vim="nvim"
type -q eza; and alias ls="eza --icons=always"
type -q moor; and alias less="moor"
type -q fastfetch; and abbr --add ff fastfetch
type -q bat; and alias cat="bat -p -P"
type -q batcat; and alias cat="batcat -p -P"

# Init Zoxide
type -q zoxide; and zoxide init fish --cmd j | source

# Init starship prompt
if type -q starship
    starship init fish | source
    set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
end