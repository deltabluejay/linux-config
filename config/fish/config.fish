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

# Use starship prompt
starship init fish | source
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
